import SwiftUI

/// The most important screen in the app.
///
/// Safety before diagnosis: the script and the one question come first, and
/// nothing else appears until the user answers. There is no entitlement check
/// anywhere in this file or anything it calls — see
/// docs/adr/0002-sos-is-never-metered.md.
struct SOSView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var answeredSafe: Bool?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SOSSafetyScriptView()

                if answeredSafe == nil {
                    SOSSafetyQuestionView(onAnswer: answer)
                        .transition(.opacity.combined(with: .offset(y: reduceMotion ? 0 : 12)))
                } else {
                    SOSLocationCardView()
                        .transition(.opacity.combined(with: .offset(y: reduceMotion ? 0 : 12)))
                    SOSTriageGridView()
                        .transition(.opacity.combined(with: .offset(y: reduceMotion ? 0 : 12)))
                }

                SOSEmergencyButton()
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .background(SOSPalette.ground.ignoresSafeArea())
        .navigationTitle("Roadside SOS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(SOSPalette.ground, for: .navigationBar)
        // A real moment, so it earns a real haptic — heavier than a tap.
        .sensoryFeedback(.success, trigger: answeredSafe) { _, new in new == true }
        .sensoryFeedback(.warning, trigger: answeredSafe) { _, new in new == false }
    }

    private func answer(_ safe: Bool) {
        withAnimation(SkyMotion.respecting(reduceMotion, SkyMotion.transition)) {
            answeredSafe = safe
        }
    }
}

#Preview {
    NavigationStack { SOSView() }
        .preferredColorScheme(.dark)
}
