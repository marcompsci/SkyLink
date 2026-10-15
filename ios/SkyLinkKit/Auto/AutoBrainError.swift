import Foundation

enum AutoBrainError: Error, Sendable {
    case onDeviceUnavailable
    case guardrailOrGenerationFailed

    /// Both cases mean the same thing to the caller: use the server. Neither is
    /// ever shown to the user.
    var shouldFallBackToServer: Bool { true }
}
