import SwiftUI

/// SOS runs warmer and darker than the rest of the app so it is unmistakable
/// at a glance, including by someone who has never opened this screen before.
enum SOSPalette {
    static let ground = Color(red: 0.078, green: 0.024, blue: 0.035)
    static let card = Color(red: 0.114, green: 0.051, blue: 0.067)
    static let border = Color(red: 0.227, green: 0.102, blue: 0.122)
    static let text = Color(red: 1.0, green: 0.953, blue: 0.945)
    static let dim = Color(red: 0.718, green: 0.612, blue: 0.592)
}
