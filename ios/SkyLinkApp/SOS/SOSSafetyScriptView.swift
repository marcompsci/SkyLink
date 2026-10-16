import SwiftUI

/// Spoken aloud and shown in large type, before any question about the car.
struct SOSSafetyScriptView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("FIRST — GET SAFE")
                .font(.system(size: 11, weight: .bold))
                .kerning(1.6)
                .foregroundStyle(SkyLinkPalette.chrome.opacity(0.85))

            Text("Hazard lights on. Get off the road if the car still moves.")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            Text("Then get out on the **passenger side** and stand behind the guardrail. Never between your car and traffic.")
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.92))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(SkyLinkPalette.stopRed, in: .rect(cornerRadius: 20))
    }
}
