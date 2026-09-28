import SwiftUI
import SwiftData
import CoreLocation
#if canImport(MessageUI)
import MessageUI
#endif

// MARK: - SOS Root View

struct SOSView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        let sos = env.sos
        let battery = env.battery

        ZStack {
            Color.skyBackground.ignoresSafeArea()

            if battery.isLow && sos.phase != .inactive {
                LowBatterySOSView()
            } else {
                switch sos.phase {
                case .inactive:
                    SOSStandbyView()
                case .safetyInstructions:
                    SafetyInstructionsView()
                case .safetyQuestion:
                    SafetyQuestionView()
                case .locationCapture:
                    LocationCaptureView()
                case .emergencyCheck:
                    EmergencyCheckView()
                case .triage:
                    TriageView()
                case .assessment:
                    AssessmentView()
                case .selfHelp(let issue):
                    SelfHelpView(issue: issue)
                case .dispatch(let issue, let dispatchType):
                    DispatchView(issue: issue, dispatchType: dispatchType)
                case .completed:
                    SOSCompletedView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: sos.phase)
        .onChange(of: sos.phase) { _, phase in
            saveSessionIfNeeded(phase: phase)
        }
    }

    private func saveSessionIfNeeded(phase: SOSPhase) {
        guard phase == .locationCapture || phase == .emergencyCheck else { return }
        let loc = env.location
        let session = SOSSession(
            latitude: loc.currentLocation?.coordinate.latitude ?? 0,
            longitude: loc.currentLocation?.coordinate.longitude ?? 0,
            address: loc.currentAddress,
            issueType: env.sos.selectedIssue ?? .other
        )
        modelContext.insert(session)
        try? modelContext.save()
    }
}

// MARK: - Standby

private struct SOSStandbyView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "light.beacon.max.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.sosRed)
                Text("Roadside SOS")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.textPrimary)
                Text("One tap for immediate help.\nFree, always. Works offline.")
                    .font(.callout)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            Button {
                env.sos.activate()
            } label: {
                Text("I Need Help")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 22)
                    .background(Color.sosRed)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.horizontal, 32)
            Text("Or say: \u{201C}Sky, I need help\u{201D}")
                .font(.footnote)
                .foregroundStyle(Color.textTertiary)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Safety Instructions

private struct SafetyInstructionsView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var step = 0

    private let instructions: [(String, String)] = [
        ("Turn on your hazard lights now.", "light.beacon.max.fill"),
        ("If the car still moves, get off the road.", "arrow.right.to.line"),
        ("Exit from the passenger side — away from traffic.", "figure.walk"),
        ("Stand behind the guardrail. Never between your car and traffic.", "exclamationmark.shield.fill")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Progress
            HStack(spacing: 6) {
                ForEach(0..<instructions.count, id: \.self) { i in
                    Capsule()
                        .fill(i <= step ? Color.sosRed : Color.borderSubtle)
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            Spacer()

            let current = instructions[min(step, instructions.count - 1)]
            VStack(spacing: 28) {
                Image(systemName: current.1)
                    .font(.system(size: 72))
                    .foregroundStyle(Color.sosRed)
                Text(current.0)
                    .font(.title.bold())
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            VStack(spacing: 14) {
                Button {
                    if step < instructions.count - 1 {
                        step += 1
                        env.voice.speak(instructions[step].0)
                    } else {
                        env.sos.advanceToSafetyQuestion()
                    }
                } label: {
                    Text(step < instructions.count - 1 ? "Next" : "I understand — continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.sosRed)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button("Skip safety steps — I know them") {
                    env.sos.advanceToSafetyQuestion()
                }
                .font(.footnote)
                .foregroundStyle(Color.textSecondary)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Safety Question

private struct SafetyQuestionView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            VStack(spacing: 16) {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.safeGreen)
                Text("Are you somewhere safe now?")
                    .font(.title.bold())
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 14) {
                Button {
                    env.sos.confirmSafe(true)
                } label: {
                    Text("Yes, I'm safe")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.safeGreen)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    env.sos.confirmSafe(false)
                } label: {
                    Text("No — I need immediate help")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.sosRed)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}

// MARK: - Location Capture

private struct LocationCaptureView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var copied = false
    @State private var showMessageSheet = false
    #if canImport(MessageUI)
    @State private var canSendSMS = MFMessageComposeViewController.canSendText()
    #else
    private let canSendSMS = false
    #endif

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                Image(systemName: "location.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(Color.skyBlue)

                Text("Your Location")
                    .font(.title2.bold())
                    .foregroundStyle(Color.textPrimary)

                SkyCard(elevated: true) {
                    VStack(alignment: .leading, spacing: 8) {
                        if env.location.isLocating {
                            HStack { ProgressView(); Text("Locating…").foregroundStyle(Color.textSecondary) }
                        } else {
                            Text(env.location.currentAddress)
                                .font(.body.weight(.medium))
                                .foregroundStyle(Color.textPrimary)
                            if let loc = env.location.currentLocation {
                                Text(String(format: "%.5f°, %.5f°",
                                            loc.coordinate.latitude,
                                            loc.coordinate.longitude))
                                    .font(.caption)
                                    .foregroundStyle(Color.textSecondary)
                            }
                        }
                    }
                    .padding(16)
                }
                .padding(.horizontal, 24)
            }

            Spacer()

            VStack(spacing: 12) {
                if canSendSMS {
                    Button {
                        showMessageSheet = true
                    } label: {
                        Label("Text My Location", systemImage: "message.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.skyBlue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }

                Button {
                    copyToPasteboard(env.location.shareText())
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { copied = false }
                } label: {
                    Label(copied ? "Copied!" : "Copy Location", systemImage: copied ? "checkmark" : "doc.on.doc.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.skyCard)
                        .foregroundStyle(Color.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    env.voice.speak(env.location.shareText())
                } label: {
                    Label("Read Aloud", systemImage: "speaker.wave.2.fill")
                        .font(.callout)
                        .foregroundStyle(Color.textSecondary)
                }

                SkyPrimaryButton("Continue", systemImage: "arrow.right", color: .safeGreen) {
                    env.sos.advanceToEmergencyCheck()
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $showMessageSheet) {
            #if canImport(MessageUI)
            MessageComposeView(body: env.location.shareText())
            #else
            Text("Messaging not available on this device.")
                .padding()
            #endif
        }
    }
}

// MARK: - Emergency Check

private struct EmergencyCheckView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var showingCall = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color.warningAmber)
                Text("Do you see fire, smoke, injuries, or was there a collision?")
                    .font(.title2.bold())
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            if showingCall {
                SkyCard(elevated: true) {
                    VStack(spacing: 12) {
                        Text("Your address:")
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                        Text(env.location.currentAddress)
                            .font(.body.bold())
                            .foregroundStyle(Color.textPrimary)
                            .multilineTextAlignment(.center)
                        Text("Read this address to the 911 dispatcher.")
                            .font(.footnote)
                            .foregroundStyle(Color.textSecondary)
                    }
                    .padding(20)
                }
                .padding(.horizontal, 24)

                Button {
                    env.sos.call911()
                } label: {
                    Label("Call 911", systemImage: "phone.fill")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 22)
                        .background(Color.sosRed)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
            } else {
                VStack(spacing: 14) {
                    Button {
                        withAnimation { showingCall = true }
                        env.sos.reportEmergency(isEmergency: true)
                    } label: {
                        Text("Yes — there is an emergency")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.sosRed)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    Button {
                        env.sos.reportEmergency(isEmergency: false)
                    } label: {
                        Text("No — everyone is OK")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.safeGreen)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal, 24)
            }

            Spacer()
        }
    }
}

// MARK: - Triage

private struct TriageView: View {
    @Environment(AppEnvironment.self) private var env

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 24) {
            Text("What's going on?")
                .font(.title.bold())
                .foregroundStyle(Color.textPrimary)
                .padding(.top, 40)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(TriageIssue.allCases, id: \.self) { issue in
                    Button {
                        env.sos.selectIssue(issue)
                    } label: {
                        VStack(spacing: 14) {
                            Image(systemName: issue.symbol)
                                .font(.system(size: 36))
                                .foregroundStyle(Color.sosRed)
                            Text(issue.rawValue)
                                .font(.callout.weight(.semibold))
                                .foregroundStyle(Color.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.skyCard)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(.horizontal, 20)
            Spacer()
        }
    }
}

// MARK: - Assessment Spinner

private struct AssessmentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ProgressView()
                .scaleEffect(1.8)
                .tint(Color.skyBlue)
            Text("Checking your situation…")
                .font(.title3.weight(.medium))
                .foregroundStyle(Color.textSecondary)
            Spacer()
        }
    }
}

// MARK: - Self Help

private struct SelfHelpView: View {
    @Environment(AppEnvironment.self) private var env
    let issue: TriageIssue
    @State private var currentStep = 0
    @State private var completedSteps: Set<Int> = []

    private var guide: RepairGuide? { RepairGuide.guides[issue] }

    var body: some View {
        if let guide {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 4) {
                    Text(guide.title)
                        .font(.title2.bold())
                        .foregroundStyle(Color.textPrimary)
                    if let warning = guide.safetyWarning {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(Color.warningAmber)
                            Text(warning)
                                .font(.caption)
                                .foregroundStyle(Color.warningAmber)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(12)
                        .background(Color.warningAmber.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 24)

                Spacer()

                let step = guide.steps[currentStep]
                RepairStepCard(
                    stepNumber: currentStep + 1,
                    total: guide.steps.count,
                    instruction: step.instruction,
                    symbol: step.symbol,
                    checkpoint: step.checkpoint,
                    isComplete: completedSteps.contains(currentStep)
                )
                .padding(.horizontal, 20)
                .onAppear { env.voice.speak(step.instruction) }

                Spacer()

                VStack(spacing: 12) {
                    if !completedSteps.contains(currentStep) {
                        Button {
                            completedSteps.insert(currentStep)
                        } label: {
                            Label("Mark Step Done", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.safeGreen)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }

                    HStack(spacing: 12) {
                        if currentStep > 0 {
                            Button {
                                currentStep -= 1
                                env.voice.speak(guide.steps[currentStep].instruction)
                            } label: {
                                Label("Back", systemImage: "chevron.left")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.skyCard)
                                    .foregroundStyle(Color.textSecondary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }

                        if currentStep < guide.steps.count - 1 {
                            Button {
                                currentStep += 1
                                env.voice.speak(guide.steps[currentStep].instruction)
                            } label: {
                                Label("Next Step", systemImage: "chevron.right")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.skyBlue)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        } else {
                            Button {
                                env.sos.complete()
                            } label: {
                                Label("All Done!", systemImage: "checkmark.seal.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.safeGreen)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
        } else {
            VStack(spacing: 20) {
                Text("Guide not available for this issue.")
                    .foregroundStyle(Color.textSecondary)
                SkyPrimaryButton("Get Help Instead", color: .sosRed) {
                    env.sos.phase = .dispatch(issue, issue.defaultDispatch)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - Dispatch

private struct DispatchView: View {
    @Environment(AppEnvironment.self) private var env
    let issue: TriageIssue
    let dispatchType: DispatchType

    var reason: String? { env.sos.triageAssessment?.reason }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: dispatchType.symbol)
                    .font(.system(size: 64))
                    .foregroundStyle(Color.skyBlue)
                Text("Call for \(dispatchType.rawValue)")
                    .font(.title.bold())
                    .foregroundStyle(Color.textPrimary)
                if let r = reason {
                    Text(r)
                        .font(.callout)
                        .foregroundStyle(Color.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
            }

            SkyCard(elevated: true) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your location")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.textTertiary)
                    Text(env.location.currentAddress)
                        .font(.callout.weight(.medium))
                        .foregroundStyle(Color.textPrimary)
                }
                .padding(16)
            }
            .padding(.horizontal, 24)

            VStack(spacing: 14) {
                Button {
                    env.sos.callDispatch(type: dispatchType)
                } label: {
                    Label("Call \(dispatchType.rawValue)", systemImage: "phone.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.skyBlue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    env.sos.call911()
                } label: {
                    Label("Call 911 Instead", systemImage: "phone.fill")
                        .font(.callout)
                        .foregroundStyle(Color.sosRed)
                }

                Button("Done") { env.sos.complete() }
                    .font(.callout)
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
    }
}

// MARK: - Completed

private struct SOSCompletedView: View {
    @Environment(AppEnvironment.self) private var env
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color.safeGreen)
            Text("Glad you're OK.")
                .font(.largeTitle.bold())
                .foregroundStyle(Color.textPrimary)
            Button("Close SOS") { env.sos.deactivate() }
                .font(.headline)
                .padding(.horizontal, 32).padding(.vertical, 14)
                .background(Color.skyCard)
                .foregroundStyle(Color.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
    }
}

// MARK: - Low Battery Mode (black screen, huge text, voice-only)

private struct LowBatterySOSView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var textSent = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 40) {
                Spacer()
                Image(systemName: "battery.25percent")
                    .font(.system(size: 56))
                    .foregroundStyle(.yellow)
                Text("Low Battery")
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(.white)
                Text(env.location.currentAddress)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Button {
                    copyToPasteboard(env.location.shareText())
                    textSent = true
                    env.voice.speak("Location copied.")
                } label: {
                    Text(textSent ? "Copied!" : "Copy My Location")
                        .font(.system(size: 28, weight: .black))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                        .background(textSent ? Color.safeGreen : Color.sosRed)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 20)

                Button {
                    env.sos.call911()
                } label: {
                    Text("Call 911")
                        .font(.system(size: 28, weight: .black))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                        .background(Color.sosRed)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .onAppear {
            env.voice.speak("Battery low. Tap to copy your location or call 9 1 1.")
        }
    }
}

// MARK: - MessageUI Bridge

// MARK: - Cross-platform pasteboard helper
private func copyToPasteboard(_ text: String) {
    #if os(iOS)
    UIPasteboard.general.string = text
    #elseif os(macOS)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(text, forType: .string)
    #endif
}

#if canImport(MessageUI)
struct MessageComposeView: UIViewControllerRepresentable {
    let body: String
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(dismiss: dismiss) }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let dismiss: DismissAction
        init(dismiss: DismissAction) { self.dismiss = dismiss }
        func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                          didFinishWith result: MessageComposeResult) {
            dismiss()
        }
    }
}
#endif
