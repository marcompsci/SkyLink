import SwiftUI

struct GarageView: View {
    @Environment(GarageStore.self) private var garage
    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack(alignment: .top) {
            SkyLinkPalette.garageBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    VehicleCardView()
                    HealthStripView()
                    ServiceLogPreview()
                    Color.clear.frame(height: 90)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }

            HazardStripe().ignoresSafeArea(edges: .top)
        }
        .safeAreaInset(edge: .bottom) {
            AskAutoBarView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Menu", systemImage: "line.3.horizontal", action: openDrawer)
                    .labelStyle(.iconOnly)
                    .tint(SkyLinkPalette.chrome)
            }
            ToolbarItem(placement: .principal) {
                Text("THE GARAGE")
                    .font(.system(size: 11, weight: .bold))
                    .kerning(2)
                    .foregroundStyle(SkyLinkPalette.grease)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Roadside help", systemImage: "exclamationmark.triangle.fill", action: openSOS)
                    .labelStyle(.iconOnly)
                    .tint(SkyLinkPalette.stopRed)
            }
        }
        .toolbarBackground(SkyLinkPalette.garageBlack, for: .navigationBar)
    }

    private func openDrawer() {
        router.isDrawerOpen = true
    }

    private func openSOS() {
        router.show(.sos)
    }
}

#Preview {
    NavigationStack { GarageView() }
        .environment(GarageStore())
        .environment(AppRouter())
        .preferredColorScheme(.dark)
}
