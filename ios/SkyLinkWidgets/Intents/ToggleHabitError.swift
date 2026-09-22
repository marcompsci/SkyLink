import Foundation

enum ToggleHabitError: Error, CustomLocalizedStringResourceConvertible {
    case unknownHabit

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .unknownHabit: "That habit no longer exists."
        }
    }
}
