import Foundation
import Observation
#if canImport(UIKit)
import UIKit
#endif

@Observable
final class BatteryService {

    var level: Float = 1.0     // 0.0–1.0
    var isLow: Bool = false    // < 15%
    var isCritical: Bool = false  // < 5%

    private var timer: Timer?

    init() {
        #if canImport(UIKit)
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self, selector: #selector(update),
            name: UIDevice.batteryLevelDidChangeNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(update),
            name: UIDevice.batteryStateDidChangeNotification, object: nil
        )
        #endif
        update()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    @objc private func update() {
        #if canImport(UIKit)
        let raw = UIDevice.current.batteryLevel
        if raw >= 0 {
            level = raw
            isLow = raw < 0.15
            isCritical = raw < 0.05
        }
        #endif
    }

    var percentage: Int { Int(level * 100) }

    var systemImageName: String {
        switch level {
        case 0..<0.05: return "battery.0percent"
        case 0..<0.25: return "battery.25percent"
        case 0..<0.50: return "battery.50percent"
        case 0..<0.75: return "battery.75percent"
        default: return "battery.100percent"
        }
    }
}
