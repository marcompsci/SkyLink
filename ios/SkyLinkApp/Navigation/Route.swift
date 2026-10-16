import Foundation

enum Route: Hashable {
    case sos
    case guide(slug: String)
    case category(slug: String)
    case serviceLog
    case askAuto
}
