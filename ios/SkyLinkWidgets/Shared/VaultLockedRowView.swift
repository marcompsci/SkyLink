import SwiftUI

/// Stands in for private habits while the vault is locked.
///
/// The widget process holds no key and cannot decrypt anything, so this is
/// the honest rendering — not a blurred value that implies the data is
/// nearly there.
struct VaultLockedRowView: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock.fill")
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.55))

            Text("Private habits hidden")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.55))

            Spacer(minLength: 0)
        }
        .accessibilityLabel("Private habits are hidden while your vault is locked")
    }
}
