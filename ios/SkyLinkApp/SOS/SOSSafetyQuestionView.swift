import SwiftUI

struct SOSSafetyQuestionView: View {
    let onAnswer: (Bool) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Are you somewhere safe now?")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(SOSPalette.text)

            HStack(spacing: 10) {
                Button("Yes, I'm safe") { onAnswer(true) }
                    .buttonStyle(SOSButtonStyle(kind: .affirm))

                Button("No — help me") { onAnswer(false) }
                    .buttonStyle(SOSButtonStyle(kind: .urgent))
            }
        }
    }
}
