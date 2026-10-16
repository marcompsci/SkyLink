import SwiftUI

/// The most important screen in the app.
///
/// Safety before diagnosis: the script and the one question come first, and
/// nothing else appears until the user answers. There is no entitlement check
/// anywhere in this file or anything it calls — see
/// docs/adr/0002-sos-is-never-metered.md.
struct SOSView: View {
    @State private var answeredSafe: Bool?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SOSSafetyScriptView()

                if answeredSafe == nil {
                    SOSSafetyQuestionView(onAnswer: answer)
                } else {
                    SOSLocationCardView()
                    SOSTriageGridView()
                }

                SOSEmergencyButton()
            }
            .padding(20)
        }
        .background(SOSPalette.ground.ignoresSafeArea())
        .navigationTitle("Roadside SOS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(SOSPalette.ground, for: .navigationBar)
    }

    private func answer(_ safe: Bool) {
        withAnimation(.snappy) { answeredSafe = safe }
    }
}

#Preview {
    NavigationStack { SOSView() }
        .preferredColorScheme(.dark)
}
