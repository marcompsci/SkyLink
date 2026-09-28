import Foundation
import Observation

@Observable
final class AppEnvironment {

    let voice    = VoiceService()
    let obd      = OBDService()
    let location = LocationService()
    let ai       = AIService()
    let sos      = SOSService()
    let battery  = BatteryService()

    init() {
        // Wire up cross-service dependencies
        sos.locationService = location
        sos.voiceService    = voice
        sos.aiService       = ai

        // Wake phrase from voice activates SOS
        voice.onWakePhrase = { [weak self] _ in
            guard let self else { return }
            if self.sos.phase == .inactive {
                self.sos.activate()
            }
        }

        // Request baseline permissions on first launch
        location.requestPermission()
        voice.requestPermissions()
    }
}
