import SwiftUI

struct GarageView: View {
    @Environment(GarageStore.self) private var garage
    @Environment(AppRouter.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

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
            .scrollIndicators(.hidden)

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
                    .buttonStyle(.control)
            }
            ToolbarItem(placement: .principal) {
                Text("The Garage").skyLabel(SkyLinkPalette.grease)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Roadside help", systemImage: "exclamationmark.triangle.fill", action: openSOS)
                    .labelStyle(.iconOnly)
                    .tint(SkyLinkPalette.stopRed)
                    .buttonStyle(.control)
            }
        }
        // Translucent chrome with content passing under it, rather than an
        // opaque bar sitting on top.
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        // Swipe in from the left edge, the same direction the drawer travels.
        .gesture(edgeSwipe)
    }

    private var edgeSwipe: some Gesture {
        DragGesture(minimumDistance: 12)
            .onEnded { value in
                guard value.startLocation.x < 24,
                      value.predictedEndTranslation.width > 80 else { return }
                openDrawer()
            }
    }

    private func openDrawer() {
        withAnimation(SkyMotion.respecting(reduceMotion, SkyMotion.drawer)) {
            router.isDrawerOpen = true
        }
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
