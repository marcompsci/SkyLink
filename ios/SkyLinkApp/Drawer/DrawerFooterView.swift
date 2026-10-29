import SwiftUI

struct DrawerFooterView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button("Saved & History", systemImage: "bookmark.fill") {
                router.show(.serviceLog)
            }
            .buttonStyle(.control)

            Label("Plan & Settings", systemImage: "gearshape.fill")
                .foregroundStyle(SkyLinkPalette.grease)
        }
        .font(SkyType.callout)
        .tint(SkyLinkPalette.chrome)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 44)
        // A fade, not a rule: the list continues underneath rather than
        // stopping at a line.
        .overlay(alignment: .top) {
            ScrollEdgeFade(edge: .top, height: 16)
                .offset(y: -16)
        }
    }
}
