import Foundation

/// Why the on-device model can or cannot be used right now.
///
/// Apple Intelligence needs iOS 26+ on a capable device with the feature
/// enabled. That excludes a large share of the installed base — including the
/// older phones budget-conscious drivers are most likely to carry. So this is
/// a routing input, never an error to show someone.
enum AutoBrainAvailability: Equatable, Sendable {
    case onDevice
    case serverOnly(reason: Reason)

    enum Reason: String, Sendable {
        case deviceNotEligible
        case appleIntelligenceNotEnabled
        case modelNotReady
        case osTooOld
        case unknown
    }

    var canUseOnDevice: Bool { self == .onDevice }
}
