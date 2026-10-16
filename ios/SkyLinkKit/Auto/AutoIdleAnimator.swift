import SwiftUI

/// Blinks Auto on an irregular beat while he is idle.
///
/// Deliberately small: a slow blink and nothing else. He is a mechanic with a
/// face, not a pet — no idle fidgets, no attention-seeking, nothing that asks
/// to be watched. See the closing note in docs/14-auto-the-mechanic.md.
@MainActor
@Observable
final class AutoIdleAnimator {
    private(set) var isBlinking = false

    private var task: Task<Void, Never>?

    func start() {
        guard task == nil else { return }

        task = Task { [weak self] in
            while !Task.isCancelled {
                // 3–7s between blinks; a fixed interval reads as a machine fault.
                let gap = UInt64.random(in: 3_000_000_000...7_000_000_000)
                try? await Task.sleep(nanoseconds: gap)
                guard !Task.isCancelled else { return }

                self?.isBlinking = true
                try? await Task.sleep(nanoseconds: 140_000_000)
                self?.isBlinking = false
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        isBlinking = false
    }

    deinit {
        task?.cancel()
    }
}
