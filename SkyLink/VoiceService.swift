import Foundation
import Speech
import AVFoundation
import Observation

@Observable
final class VoiceService: NSObject {

    // MARK: - State
    var isListening = false
    var isSpeaking = false
    var transcript = ""
    var isPermissionGranted = false

    // MARK: - Private
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let synthesizer = AVSpeechSynthesizer()
    private var onFinalTranscript: ((String) -> Void)?

    // Callback fired when "sky" + trigger phrase is detected
    var onWakePhrase: ((String) -> Void)?

    private let wakePhrases = ["sky i need help", "sky help", "sky sos", "hey sky"]

    override init() {
        super.init()
        synthesizer.delegate = self
        requestPermissions()
    }

    // MARK: - Permissions
    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                self.isPermissionGranted = (status == .authorized)
            }
        }
        AVAudioApplication.requestRecordPermission { _ in }
    }

    // MARK: - Listening
    func startListening(onResult: @escaping (String) -> Void) {
        guard !isListening, isPermissionGranted else { return }
        onFinalTranscript = onResult
        transcript = ""

        do {
            #if os(iOS)
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            #endif

            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let request = recognitionRequest else { return }
            request.shouldReportPartialResults = true
            request.requiresOnDeviceRecognition = true

            let inputNode = audioEngine.inputNode
            let format = inputNode.outputFormat(forBus: 0)

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
            }

            recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
                guard let self else { return }
                if let result {
                    let text = result.bestTranscription.formattedString
                    DispatchQueue.main.async { self.transcript = text }
                    self.checkForWakePhrase(text)
                    if result.isFinal {
                        DispatchQueue.main.async { onResult(text) }
                        self.stopListening()
                    }
                } else if error != nil {
                    self.stopListening()
                }
            }

            audioEngine.prepare()
            try audioEngine.start()
            DispatchQueue.main.async { self.isListening = true }
        } catch {
            stopListening()
        }
    }

    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        DispatchQueue.main.async { self.isListening = false }
    }

    // MARK: - Speaking
    func speak(_ text: String, rate: Float = 0.50, pitch: Float = 1.0) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - Wake Phrase Detection
    private func checkForWakePhrase(_ text: String) {
        let lower = text.lowercased()
        for phrase in wakePhrases {
            if lower.contains(phrase) {
                DispatchQueue.main.async {
                    self.onWakePhrase?(text)
                }
                break
            }
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension VoiceService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = true }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async { self.isSpeaking = false }
    }
}
