import SwiftUI

struct SOSSituationTile: View {
    let situation: SOSSituation
    let isChosen: Bool
    let onTap: () -> Void

    private var accent: Color {
        situation == .somethingElse ? SkyLinkPalette.oilTeal : SkyLinkPalette.torqueOrange
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 9) {
                Image(systemName: situation.symbolName)
                    .font(.system(.title3))
                    .foregroundStyle(accent)

                Text(situation.title)
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(SOSPalette.text)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(SOSPalette.card, in: .rect(cornerRadius: 15))
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isChosen ? accent : SOSPalette.border, lineWidth: isChosen ? 2 : 1)
            }
        }
        .buttonStyle(.card)
    }
}
