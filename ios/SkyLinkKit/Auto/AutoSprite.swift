import Foundation

/// Auto's sprite sheet: 8 frames of 32×32 in one horizontal strip.
///
/// Art and the generator live in `design/auto/`. Add `auto-sheet.png` and its
/// @2x/@3x to the asset catalog **with "Preserve Vector Data" off and scaling
/// set to "Single Scale"** — the three files are already the three scales.
enum AutoSprite {
    static let imageName = "auto-sheet"
    static let frameSize = 32

    /// Index into the strip. Order is fixed by the generator's `frameOrder`.
    static func frameIndex(for state: AutoState, blinking: Bool = false) -> Int {
        if blinking && state == .idle { return 7 }

        switch state {
        case .idle: return 0
        case .listening: return 1
        case .thinking: return 2
        case .foundIt: return 3
        case .careful: return 4
        case .stop: return 5
        case .cantHelp: return 6
        }
    }

    /// Pixel art only looks right at whole multiples of its native size.
    /// A 50pt Auto has uneven pixels; 64 is the nearest honest size.
    static func snappedSize(near points: CGFloat) -> CGFloat {
        let multiple = max(1, (points / CGFloat(frameSize)).rounded())
        return multiple * CGFloat(frameSize)
    }
}
