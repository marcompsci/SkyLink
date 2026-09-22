import SwiftUI

/// Shown when nothing has been published to the App Group yet.
///
/// Never falls back to sample data: a widget that shows invented numbers
/// on a fresh install teaches people not to trust it.
struct WidgetEmptyView: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "square.dashed")
                .font(.system(size: 18))
                .foregroundStyle(.white.opacity(0.6))

            Text(message)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
