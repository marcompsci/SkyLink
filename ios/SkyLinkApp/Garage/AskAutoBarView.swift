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
                        .font(SkyType.heading)
                        .foregroundStyle(SkyLinkPalette.chrome)

                    Text("\"What's that noise when I brake?\"")
                        .font(SkyType.caption)
                        .foregroundStyle(SkyLinkPalette.grease)
                        .lineLimit(1)
                }

                Spacer(minLength: 4)

                Image(systemName: "mic.fill")
                    .font(.system(.subheadline))
                    .foregroundStyle(SkyLinkPalette.garageBlack)
                    .frame(width: 38, height: 38)
                    .background(SkyLinkPalette.torqueOrange, in: .circle)
            }
            .padding(14)
            // Translucent, so the log scrolls visibly underneath instead of
            // disappearing behind an opaque slab. The bar reads as floating
            // above the content, which is what it is.
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 18))
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(SkyLinkPalette.torqueOrange.opacity(0.7), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.35), radius: 18, y: 6)
        }
        .buttonStyle(.card)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(alignment: .top) {
            ScrollEdgeFade(edge: .bottom, height: 28)
                .offset(y: -28)
        }
        .task { idle.start() }
        .onDisappear(perform: idle.stop)
    }

    private func openAsk() {
        router.show(.askAuto)
    }
}
