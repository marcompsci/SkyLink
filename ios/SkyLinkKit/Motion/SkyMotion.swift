import SwiftUI

/// Springs, not durations.
///
/// A spring is interruptible and velocity-aware by nature: it starts from
/// wherever the value currently is, so a gesture can grab and reverse it
/// mid-flight. A fixed-duration curve cannot do that, which is why
/// gesture-driven motion here never uses `.easeInOut`.
///
/// Two parameters do all the work:
/// - **dampingFraction** — 1.0 settles with no bounce; below 1.0 overshoots.
/// - **response** — roughly how long it takes to reach the target, in seconds.
///
/// Most UI is critically damped. Bounce is earned: it belongs where the
/// gesture itself carried momentum, not sprinkled on everything.
enum SkyMotion {
    /// Repositioning something that didn't come from a flick.
    static let reposition = Animation.spring(response: 0.4, dampingFraction: 1.0)

    /// Drawers and sheets. Slight overshoot because the user threw it.
    static let drawer = Animation.spring(response: 0.3, dampingFraction: 0.8)

    /// Press feedback. Fast and dead — a bouncy button feels cheap.
    static let press = Animation.spring(response: 0.22, dampingFraction: 1.0)

    /// State changes that aren't gesture-driven.
    static let transition = Animation.spring(response: 0.35, dampingFraction: 0.9)

    /// Honour the system setting: cross-fade instead of moving, and never
    /// overshoot. Returns nil so callers can drop the animation entirely.
    static func respecting(_ reduceMotion: Bool, _ animation: Animation) -> Animation {
        reduceMotion ? .easeOut(duration: 0.2) : animation
    }
}
