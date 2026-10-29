import SwiftUI

/// The drawer tracks your finger.
///
/// It used to open and close on tap with a canned animation and no way to
/// grab it. Now it moves 1:1 with the drag, resists when pushed past open,
/// and decides where to land from the *projected* end of your flick rather
/// than from where your finger happened to stop. A slow drag halfway back
/// stays open; a fast flick from the same place closes it. That difference
/// is most of what "feels native" means.
struct DrawerView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var drag: CGFloat = 0

    private let width: CGFloat = 320

    /// 1 = fully open, 0 = closed. The scrim reads this, so the dimming
    /// tracks the finger instead of waiting for the gesture to finish.
    private var progress: CGFloat {
        max(0, min(1, (width + offset) / width))
    }

    /// Dragging left is free. Dragging right past open meets resistance that
    /// grows the further you push — a soft wall rather than a dead stop.
    private var offset: CGFloat {
        drag <= 0 ? drag : rubberband(drag)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black
                .opacity(0.65 * progress)
                .ignoresSafeArea()
                .onTapGesture(perform: close)
                .accessibilityLabel("Close menu")
                .accessibilityAddTraits(.isButton)

            VStack(alignment: .leading, spacing: 0) {
                DrawerHeaderView()

                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(MaintenanceCategory.all) { category in
                            DrawerCategoryRow(category: category, onTap: open)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .scrollIndicators(.hidden)

                DrawerFooterView()
            }
            .frame(width: width)
            .background(SkyLinkPalette.steel)
            .ignoresSafeArea()
            .offset(x: offset)
            .gesture(dragGesture)
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                drag = value.translation.width
            }
            .onEnded { value in
                // Where the flick would come to rest, not where the finger
                // stopped. Past the halfway mark, it closes.
                let projected = value.predictedEndTranslation.width

                if projected < -width / 2 {
                    close()
                } else {
                    withAnimation(SkyMotion.respecting(reduceMotion, SkyMotion.drawer)) {
                        drag = 0
                    }
                }
            }
    }

    /// Progressive resistance: the first few points move almost freely, the
    /// next ones barely move at all.
    private func rubberband(_ overshoot: CGFloat) -> CGFloat {
        let constant: CGFloat = 0.55
        return (overshoot * width * constant) / (width + constant * abs(overshoot))
    }

    private func close() {
        withAnimation(SkyMotion.respecting(reduceMotion, SkyMotion.drawer)) {
            router.isDrawerOpen = false
            drag = 0
        }
    }

    private func open(_ category: MaintenanceCategory) {
        router.show(.category(slug: category.slug))
    }
}
