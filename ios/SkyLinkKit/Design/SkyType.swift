import SwiftUI

/// Typography that scales with the user's text size.
///
/// Every size in this app used to be a hard-coded point value, which is the
/// fastest way to make an interface feel machine-made: it ignores the one
/// setting people actually change, and it breaks at accessibility sizes.
/// These are relative styles — they scale, and they keep their hierarchy
/// while scaling.
///
/// Tracking is size-specific, per Apple's guidance: negative on large display
/// text, slightly positive on small text. Leading tracks size inversely.
enum SkyType {
    /// Screen titles. Tight and slightly negative-tracked.
    static let display = Font.system(.largeTitle, weight: .bold)
    /// Section heads, vehicle names.
    static let title = Font.system(.title2, weight: .bold)
    /// Card titles.
    static let heading = Font.system(.headline, weight: .semibold)
    /// Default reading size.
    static let body = Font.system(.body)
    /// Supporting copy under a heading.
    static let callout = Font.system(.callout)
    /// Metadata, timestamps.
    static let caption = Font.system(.caption)
    /// The tracked small-caps labels — "SERVICE LOG", "FIRST — GET SAFE".
    static let label = Font.system(.caption2, weight: .bold)
    /// Numbers that should align in a column: mileage, money, distances.
    static let mono = Font.system(.footnote, design: .monospaced)
    /// Large numbers — the cost total, the mileage readout.
    static let monoLarge = Font.system(.title3, design: .monospaced, weight: .semibold)
}

extension View {
    /// A tracked, uppercased micro-label. Positive tracking because the text
    /// is small — the opposite of what display text wants.
    func skyLabel(_ colour: Color) -> some View {
        self
            .font(SkyType.label)
            .tracking(1.6)
            .textCase(.uppercase)
            .foregroundStyle(colour)
    }

    /// Display text gets negative tracking so it doesn't read as loose at size.
    func skyDisplay() -> some View {
        self
            .font(SkyType.display)
            .tracking(-0.8)
    }
}
