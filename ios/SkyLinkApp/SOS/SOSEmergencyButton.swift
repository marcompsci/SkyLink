import SwiftUI

/// Always visible, never gated, never below the fold on a short screen.
struct SOSEmergencyButton: View {
    var body: some View {
        Link(destination: URL(string: "tel://911")!) {
            HStack(spacing: 9) {
                Image(systemName: "phone.fill")
                Text("Fire, smoke or injury — call 911")
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundStyle(SkyLinkPalette.stopRed)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(SOSPalette.card, in: .rect(cornerRadius: 14))
            .overlay { RoundedRectangle(cornerRadius: 14).stroke(SOSPalette.border, lineWidth: 1.5) }
        }
    }
}
