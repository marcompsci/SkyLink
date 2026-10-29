import SwiftUI

struct ReminderRowView: View {
    let reminder: MaintenanceReminder
    let mileage: Int

    private var severity: DiagnosticSeverity {
        reminder.severity(currentMileage: mileage)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 9) {
            Image(systemName: severity.symbolName)
                .font(.system(.subheadline))
                .foregroundStyle(severity.tint)

            VStack(alignment: .leading, spacing: 3) {
                Text(reminder.title)
                    .font(.system(.footnote, weight: .semibold))
                    .foregroundStyle(severity == .safe ? SkyLinkPalette.chrome : severity.tint)

                Text(reminder.summary(currentMileage: mileage))
                    .font(.system(.caption))
                    .foregroundStyle(SkyLinkPalette.grease)
            }

            Spacer(minLength: 0)
        }
        .padding(13)
        .background(severity.tint.opacity(0.12), in: .rect(cornerRadius: 13))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(severity.tint)
                .frame(width: 3)
                .clipShape(.rect(cornerRadius: 2))
        }
    }
}
