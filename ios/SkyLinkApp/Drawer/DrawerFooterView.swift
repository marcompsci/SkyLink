import SwiftUI

struct DrawerFooterView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button("Saved & History", systemImage: "bookmark.fill") {
                router.show(.serviceLog)
            }

            Label("Plan & Settings", systemImage: "gearshape.fill")
                .foregroundStyle(SkyLinkPalette.grease)
        }
        .font(.system(size: 14, weight: .medium))
        .tint(SkyLinkPalette.chrome)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 44)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(SkyLinkPalette.garageBlack)
                .frame(height: 1)
        }
    }
}
