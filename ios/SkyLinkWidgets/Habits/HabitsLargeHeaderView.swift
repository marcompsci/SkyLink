import SwiftUI

struct HabitsLargeHeaderView: View {
    let updatedAt: Date

    var body: some View {
        HStack {
            Text("MindFlow · Today")
                .font(.system(size: 11, weight: .semibold))
                .textCase(.uppercase)
                .foregroundStyle(.white.opacity(0.7))

            Spacer()

            // Widgets refresh on a budget, so the time is always stamped
            // rather than implied.
            Text(updatedAt, style: .time)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.white.opacity(0.55))
        }
    }
}
