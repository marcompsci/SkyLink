import SwiftUI

struct RepairGuideView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.dismiss) private var dismiss

    let issue: TriageIssue
    @State private var currentStep = 0
    @State private var completedSteps: Set<Int> = []

    private var guide: RepairGuide? { RepairGuide.guides[issue] }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skyBackground.ignoresSafeArea()

                if let guide {
                    VStack(spacing: 0) {
                        // Safety warning banner
                        if let warning = guide.safetyWarning {
                            HStack(spacing: 10) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(Color.warningAmber)
                                Text(warning)
                                    .font(.caption)
                                    .foregroundStyle(Color.warningAmber)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(14)
                            .background(Color.warningAmber.opacity(0.08))
                        }

                        // Progress bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Color.borderSubtle.frame(height: 4)
                                Color.skyBlue
                                    .frame(width: geo.size.width * CGFloat(currentStep + 1) / CGFloat(guide.steps.count),
                                           height: 4)
                                    .animation(.easeInOut, value: currentStep)
                            }
                        }
                        .frame(height: 4)

                        ScrollView {
                            VStack(spacing: 20) {
                                RepairStepCard(
                                    stepNumber: currentStep + 1,
                                    total: guide.steps.count,
                                    instruction: guide.steps[currentStep].instruction,
                                    symbol: guide.steps[currentStep].symbol,
                                    checkpoint: guide.steps[currentStep].checkpoint,
                                    isComplete: completedSteps.contains(currentStep)
                                )
                                .padding(.horizontal, 16)
                                .padding(.top, 20)

                                // All steps overview
                                VStack(alignment: .leading, spacing: 8) {
                                    SkySectionHeader(title: "All Steps")
                                        .padding(.horizontal, 20)
                                    ForEach(guide.steps.indices, id: \.self) { i in
                                        Button { jump(to: i, guide: guide) } label: {
                                            HStack(spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(completedSteps.contains(i) ? Color.safeGreen
                                                              : (i == currentStep ? Color.skyBlue : Color.skyCard))
                                                        .frame(width: 28, height: 28)
                                                    if completedSteps.contains(i) {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 12, weight: .bold))
                                                            .foregroundStyle(.white)
                                                    } else {
                                                        Text("\(i + 1)")
                                                            .font(.caption.bold())
                                                            .foregroundStyle(i == currentStep ? .white : Color.textSecondary)
                                                    }
                                                }
                                                Text(guide.steps[i].instruction)
                                                    .font(.callout)
                                                    .foregroundStyle(i == currentStep ? Color.textPrimary : Color.textSecondary)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 6)
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 120)
                        }

                        // Controls
                        VStack(spacing: 10) {
                            if !completedSteps.contains(currentStep) {
                                Button {
                                    completedSteps.insert(currentStep)
                                } label: {
                                    Label("Mark Done", systemImage: "checkmark.circle.fill")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(Color.safeGreen)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }

                            HStack(spacing: 10) {
                                Button {
                                    if currentStep > 0 { jump(to: currentStep - 1, guide: guide) }
                                } label: {
                                    Label("Back", systemImage: "chevron.left")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(currentStep > 0 ? Color.skyCard : Color.borderSubtle)
                                        .foregroundStyle(currentStep > 0 ? Color.textPrimary : Color.textTertiary)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .disabled(currentStep == 0)

                                if currentStep < guide.steps.count - 1 {
                                    Button {
                                        jump(to: currentStep + 1, guide: guide)
                                    } label: {
                                        Label("Next", systemImage: "chevron.right")
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.skyBlue)
                                            .foregroundStyle(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                } else {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Label("Finished!", systemImage: "checkmark.seal.fill")
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(Color.safeGreen)
                                            .foregroundStyle(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.skyBackground)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("No guide available for this issue.")
                            .foregroundStyle(Color.textSecondary)
                        Button("Close") { dismiss() }
                    }
                }
            }
            .navigationTitle(guide?.title ?? issue.rawValue)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button {
                        if let guide {
                            env.voice.speak(guide.steps[currentStep].instruction)
                        }
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(Color.skyBlue)
                    }
                }
            }
        }
    }

    private func jump(to index: Int, guide: RepairGuide) {
        currentStep = index
        env.voice.speak(guide.steps[index].instruction)
    }
}

// Conform TriageIssue to Identifiable for sheet(item:)
extension TriageIssue: Identifiable {
    public var id: String { rawValue }
}
