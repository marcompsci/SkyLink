import Foundation
import Observation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - SOS State Machine
// IMPORTANT: SOS is free on every tier, forever.
// There are ZERO subscription or paywall checks anywhere in this file or in SOSView.
// Charging someone stranded on a highway is indefensible.

enum SOSPhase: Equatable {
    case inactive
    case safetyInstructions
    case safetyQuestion
    case locationCapture
    case emergencyCheck
    case triage
    case assessment
    case selfHelp(TriageIssue)
    case dispatch(TriageIssue, DispatchType)
    case completed
}

@Observable
final class SOSService {

    var phase: SOSPhase = .inactive
    var selectedIssue: TriageIssue?
    var triageAssessment: TriageAssessment?
    var isLowBattery: Bool = false

    // Injected dependencies
    var locationService: LocationService?
    var voiceService: VoiceService?
    var aiService: AIService?

    // MARK: - Activate

    func activate() {
        checkBattery()
        phase = .safetyInstructions
        voiceService?.speak(
            "Turn on your hazard lights. If the car still moves, get off the road. " +
            "Exit from the passenger side. Stand behind the guardrail — never between your car and traffic."
        )
        locationService?.captureLocation()
    }

    func deactivate() {
        voiceService?.stopSpeaking()
        phase = .inactive
        selectedIssue = nil
        triageAssessment = nil
    }

    // MARK: - Phase Transitions

    func advanceToSafetyQuestion() {
        phase = .safetyQuestion
        voiceService?.speak("Are you somewhere safe now?")
    }

    func confirmSafe(_ safe: Bool) {
        if safe {
            phase = .locationCapture
            voiceService?.speak("Got it. Locking your location now.")
        } else {
            // Not safe — skip everything, go straight to emergency
            phase = .emergencyCheck
            voiceService?.speak("Do you see fire, smoke, injuries, or was there a collision?")
        }
    }

    func advanceToEmergencyCheck() {
        phase = .emergencyCheck
        voiceService?.speak("Do you see fire, smoke, injuries, or was there a collision?")
    }

    func reportEmergency(isEmergency: Bool) {
        if isEmergency {
            // Emergency: stay on 911 screen — don't advance
            voiceService?.speak(
                "Call 911 now. Tell them your address: \(locationService?.currentAddress ?? "unknown location")"
            )
        } else {
            phase = .triage
            voiceService?.speak("What's going on with your car?")
        }
    }

    func selectIssue(_ issue: TriageIssue) {
        selectedIssue = issue
        phase = .assessment
        Task { await assess(issue: issue) }
    }

    private func assess(issue: TriageIssue) async {
        guard let ai = aiService else {
            await MainActor.run { phase = .dispatch(issue, issue.defaultDispatch) }
            return
        }
        let hour = Calendar.current.component(.hour, from: Date())
        let isNight = hour < 6 || hour >= 20
        let isHighway = locationService?.currentAddress.lowercased().contains("i-") == true ||
                        locationService?.currentAddress.lowercased().contains("hwy") == true ||
                        locationService?.currentAddress.lowercased().contains("freeway") == true

        let result = await ai.assessTriageSituation(
            issue: issue,
            isNight: isNight,
            isHighway: isHighway,
            batteryLow: isLowBattery
        )

        await MainActor.run {
            triageAssessment = result
            if result.canSelfFix {
                phase = .selfHelp(issue)
                voiceService?.speak("OK. I'll walk you through this step by step.")
            } else {
                phase = .dispatch(issue, result.recommendDispatch)
                let reason = result.reason ?? "Let's get you some help."
                voiceService?.speak(reason)
            }
        }
    }

    func complete() {
        phase = .completed
        voiceService?.speak("Glad you're OK. Take care.")
    }

    // MARK: - Battery

    private func checkBattery() {
        #if canImport(UIKit)
        UIDevice.current.isBatteryMonitoringEnabled = true
        let level = UIDevice.current.batteryLevel
        isLowBattery = level >= 0 && level < 0.15
        #endif
    }

    // MARK: - 911

    func call911() {
        guard let url = URL(string: "tel://911") else { return }
        openURL(url)
    }

    // MARK: - Dispatch Call

    func callDispatch(type: DispatchType) {
        let queries: [DispatchType: String] = [
            .tow:          "tel://18005555555",
            .jumpStart:    "tel://18005555555",
            .fuelDelivery: "tel://18005555555",
            .lockout:      "tel://18005555555",
            .tireChange:   "tel://18005555555",
        ]
        if let url = URL(string: queries[type] ?? "tel://411") {
            openURL(url)
        }
    }

    private func openURL(_ url: URL) {
        #if canImport(UIKit)
        UIApplication.shared.open(url)
        #endif
    }
}
