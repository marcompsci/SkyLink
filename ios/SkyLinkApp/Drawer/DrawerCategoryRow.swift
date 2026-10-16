import SwiftUI

struct DrawerCategoryRow: View {
    let category: MaintenanceCategory
    let onTap: (MaintenanceCategory) -> Void

    private var isEmergency: Bool {
        category.slug == "roadside-emergencies"
    }

    var body: some View {
        Button {
            onTap(category)
        } label: {
            HStack(spacing: 13) {
                Image(systemName: category.symbolName)
                    .font(.system(size: 16))
                    .foregroundStyle(isEmergency ? SkyLinkPalette.stopRed : SkyLinkPalette.grease)
                    .frame(width: 22)

                Text(category.title)
                    .font(.system(size: 15))
                    .foregroundStyle(SkyLinkPalette.chrome)

                Spacer(minLength: 4)

                Text("\(category.jobCount)")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(SkyLinkPalette.grease)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 13)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}
