import SwiftUI

struct AskAutoBarView: View {
    @Environment(AppRouter.self) private var router
    @State private var idle = AutoIdleAnimator()

    var body: some View {
        Button(action: openAsk) {
            HStack(spacing: 13) {
                AutoSpriteView(state: .idle, size: 32, blinking: idle.isBlinking)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Ask Auto")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(SkyLinkPalette.chrome)

                    Text("\"What's that noise when I brake?\"")
                        .font(.system(size: 12.5))
                        .foregroundStyle(SkyLinkPalette.grease)
                        .lineLimit(1)
                }

                Spacer(minLength: 4)

                Image(systemName: "mic.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(SkyLinkPalette.garageBlack)
                    .frame(width: 38, height: 38)
                    .background(SkyLinkPalette.torqueOrange, in: .circle)
            }
            .padding(14)
            .background(SkyLinkPalette.steel, in: .rect(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(SkyLinkPalette.torqueOrange, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(SkyLinkPalette.garageBlack)
        .task { idle.start() }
        .onDisappear(perform: idle.stop)
    }

    private func openAsk() {
        router.show(.askAuto)
    }
}
