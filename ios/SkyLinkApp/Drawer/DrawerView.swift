import SwiftUI

struct DrawerView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.65)
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

                DrawerFooterView()
            }
            .frame(width: 320)
            .background(SkyLinkPalette.steel)
            .ignoresSafeArea()
        }
    }

    private func close() {
        router.isDrawerOpen = false
    }

    private func open(_ category: MaintenanceCategory) {
        router.show(.category(slug: category.slug))
    }
}
