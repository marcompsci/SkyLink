import Foundation

enum SOSSituation: String, CaseIterable, Identifiable, Sendable {
    case wontStart
    case flatTire
    case overheating
    case outOfFuel
    case lockedOut
    case somethingElse

    var id: String { rawValue }

    var title: String {
        switch self {
        case .wontStart: "Won't start"
        case .flatTire: "Flat tire"
        case .overheating: "Overheating"
        case .outOfFuel: "Out of fuel"
        case .lockedOut: "Locked out"
        case .somethingElse: "Something else"
        }
    }

    var symbolName: String {
        switch self {
        case .wontStart: "bolt.slash.fill"
        case .flatTire: "circle.bottomhalf.filled"
        case .overheating: "thermometer.high"
        case .outOfFuel: "fuelpump.slash.fill"
        case .lockedOut: "lock.fill"
        case .somethingElse: "mic.fill"
        }
    }
}
