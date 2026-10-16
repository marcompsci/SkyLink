import SwiftUI

/// Draws Auto at a whole multiple of 32pt, with no smoothing.
///
/// `.interpolation(.none)` is not optional. Smoothing a 32px sprite turns it to
/// mush, and it is the easiest way to ruin this art.
struct AutoSpriteView: View {
    let state: AutoState
    var size: CGFloat = 64
    var blinking: Bool = false

    private var snapped: CGFloat {
        AutoSprite.snappedSize(near: size)
    }

    private var scale: CGFloat {
        snapped / CGFloat(AutoSprite.frameSize)
    }

    private var frame: Int {
        AutoSprite.frameIndex(for: state, blinking: blinking)
    }

    var body: some View {
        Image(AutoSprite.imageName)
            .interpolation(.none)
            .resizable()
            .frame(
                width: CGFloat(AutoSprite.frameSize) * 8 * scale,
                height: snapped
            )
            .offset(x: -CGFloat(AutoSprite.frameSize) * scale * CGFloat(frame))
            .frame(width: snapped, height: snapped, alignment: .leading)
            .clipped()
            .accessibilityLabel(state.label)
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            ForEach(AutoState.allCases, id: \.self) { state in
                AutoSpriteView(state: state, size: 64)
            }
        }
        AutoSpriteView(state: .listening, size: 128)
    }
    .padding(40)
    .background(Color(red: 0.07, green: 0.08, blue: 0.10))
}
