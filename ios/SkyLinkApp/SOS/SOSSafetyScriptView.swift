import SwiftUI

/// Spoken aloud and shown in large type, before any question about the car.
struct SOSSafetyScriptView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("First — get safe").skyLabel(SkyLinkPalette.chrome.opacity(0.9))

            Text("Hazard lights on. Get off the road if the car still moves.")
                .font(.system(.title2, weight: .bold))
                .tracking(-0.4)
                .foregroundStyle(.white)

            Text("Then get out on the **passenger side** and stand behind the guardrail. Never between your car and traffic.")
                .font(SkyType.callout)
                .foregroundStyle(.white.opacity(0.92))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(SkyLinkPalette.stopRed, in: .rect(cornerRadius: 20))
    }
}
