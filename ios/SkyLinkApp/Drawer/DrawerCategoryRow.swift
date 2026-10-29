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
                    .font(.system(.callout))
                    .foregroundStyle(isEmergency ? SkyLinkPalette.stopRed : SkyLinkPalette.grease)
                    .frame(width: 22)

                Text(category.title)
                    .font(SkyType.body)
                    .foregroundStyle(SkyLinkPalette.chrome)

                Spacer(minLength: 4)

                Text("\(category.jobCount)")
                    .font(SkyType.mono)
                    .foregroundStyle(SkyLinkPalette.grease)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 13)
            .contentShape(.rect)
        }
        .buttonStyle(.card)
    }
}
