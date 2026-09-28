import Foundation
import FoundationModels
import Observation

@Observable
final class AIService {

    var isThinking = false
    var lastError: String?

    private var session: LanguageModelSession?

    private let systemInstructions = """
    You are Sky, a voice-first AI car mechanic assistant built into the SkyLink iPhone app. \
    You help people who have never opened a hood. Your rules:

    1. SAFETY FIRST. Always check if a job is dangerous for a non-mechanic before walking them through it. \
       If it is dangerous — high-voltage hybrid systems, brake hydraulics, fuel line work, airbag components — \
       say clearly "This job is not safe to attempt without a professional mechanic" and stop.
    2. Keep answers SHORT. One clear action per response. No technical jargon.
    3. If the person is stranded or in distress, prioritize their safety over any repair advice.
    4. When referencing fault codes, explain what the code means in plain English and what a mechanic would check.
    5. For parts, give the part name and what store type carries it (auto parts store, dealer only, etc.).
    6. Never guess. If you are not confident, say so and recommend a mechanic.
    7. Format repair steps as a numbered list, one sentence each.
    """

    init() {
        resetSession()
    }

    // MARK: - Ask

    func ask(_ question: String) async -> String {
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                self.isThinking = true
                defer { self.isThinking = false }
                do {
                    guard let session = self.session else {
                        continuation.resume(returning: self.fallback(for: question))
                        return
                    }
                    let response = try await session.respond(to: question)
                    continuation.resume(returning: response.content)
                } catch {
                    self.lastError = error.localizedDescription
                    // If context window exceeded, reset and retry once
                    if case LanguageModelSession.GenerationError.exceededContextWindowSize = error {
                        self.resetSession()
                        if let s = self.session,
                           let r = try? await s.respond(to: question) {
                            continuation.resume(returning: r.content)
                        } else {
                            continuation.resume(returning: self.fallback(for: question))
                        }
                    } else {
                        continuation.resume(returning: self.fallback(for: question))
                    }
                }
            }
        }
    }

    // MARK: - Fault Code Explanation

    func explain(faultCode code: String) async -> String {
        if let known = OBDFaultCode.knownCodes[code] {
            let prompt = "Explain fault code \(code) (\(known.0)) in plain English. What does it mean for the driver? What should they do? Keep it to 3 sentences max."
            return await ask(prompt)
        }
        return await ask("Explain OBD-II fault code \(code) in plain English. What does it mean and what should the driver do?")
    }

    // MARK: - Triage Assessment
    // Returns true if the user should try to self-fix, false if they should call for help

    func assessTriageSituation(issue: TriageIssue, isNight: Bool, isHighway: Bool, batteryLow: Bool) async -> TriageAssessment {
        // Safety rules applied locally — never sent to model so they can't be overridden
        switch issue {
        case .overheating:
            return TriageAssessment(
                canSelfFix: false,
                reason: "An overheating engine can cause serious damage or burns if you open the hood. Do not attempt repairs. Call a tow.",
                recommendDispatch: .tow
            )
        case .flatTire:
            if isHighway && isNight {
                return TriageAssessment(
                    canSelfFix: false,
                    reason: "Changing a tire on a highway shoulder at night is dangerous. Call for roadside assistance instead.",
                    recommendDispatch: .tireChange
                )
            }
            if batteryLow {
                return TriageAssessment(
                    canSelfFix: false,
                    reason: "Your phone battery is low. Call for service now to ensure you stay connected.",
                    recommendDispatch: .tireChange
                )
            }
            return TriageAssessment(canSelfFix: true, reason: nil, recommendDispatch: .tireChange)
        case .lockedOut:
            return TriageAssessment(canSelfFix: false, reason: "Call a lockout service — they can open your car without damage.", recommendDispatch: .lockout)
        case .outOfFuel:
            return TriageAssessment(canSelfFix: true, reason: nil, recommendDispatch: .fuelDelivery)
        case .wontStart:
            if batteryLow {
                return TriageAssessment(canSelfFix: false, reason: "Your phone battery is low. Call for a jump start now.", recommendDispatch: .jumpStart)
            }
            return TriageAssessment(canSelfFix: true, reason: nil, recommendDispatch: .jumpStart)
        case .other:
            return TriageAssessment(canSelfFix: false, reason: "Without a diagnosis, the safest option is to call for a tow.", recommendDispatch: .tow)
        }
    }

    // MARK: - Private

    func resetSession() {
        session = LanguageModelSession(instructions: systemInstructions)
    }

    private func fallback(for question: String) -> String {
        let q = question.lowercased()
        if q.contains("check engine") || q.contains("fault code") || q.contains("obd") {
            return "Connect your OBD-II Bluetooth adapter and tap Diagnose to read your car's exact fault codes. That gives me real data to work with instead of a guess."
        }
        if q.contains("oil") {
            return "Most cars need an oil change every 5,000–7,500 miles. Check your dashboard for an oil change reminder, or look at the dipstick — oil should be amber-colored and between the two marks."
        }
        if q.contains("tire") || q.contains("flat") {
            return "For a flat tire on a safe location, I can walk you through changing it step by step. Tap the SOS button if you need roadside help."
        }
        if q.contains("battery") || q.contains("won't start") || q.contains("won't start") {
            return "If your car won't start and you hear clicking, the battery is likely dead. You'll need a jump start. Tap SOS → Won't Start and I'll walk you through it."
        }
        return "I'm having trouble reaching my AI right now. For emergencies, tap the red SOS button. For diagnostics, connect your OBD-II adapter and tap Diagnose."
    }
}

struct TriageAssessment {
    let canSelfFix: Bool
    let reason: String?
    let recommendDispatch: DispatchType
}
