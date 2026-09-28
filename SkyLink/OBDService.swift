import Foundation
import CoreBluetooth
import Observation

// ELM327 BLE OBD-II service
@Observable
final class OBDService: NSObject {

    enum ConnectionState {
        case disconnected, scanning, connecting, initializing, connected, error(String)
    }

    // MARK: - State
    var connectionState: ConnectionState = .disconnected
    var faultCodes: [OBDFaultCode] = []
    var liveData = OBDLiveData()
    var availableDevices: [CBPeripheral] = []

    // MARK: - ELM327 UUIDs (most common BLE dongle)
    private let serviceUUID        = CBUUID(string: "FFE0")
    private let characteristicUUID = CBUUID(string: "FFE1")

    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var dataCharacteristic: CBCharacteristic?
    private var responseBuffer = ""
    private var pendingCommand: ((String) -> Void)?
    private var initQueue: [String] = []

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    // MARK: - Public API

    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        availableDevices = []
        connectionState = .scanning
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        // Also scan without filter to catch all OBD devices
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func connect(to peripheral: CBPeripheral) {
        centralManager.stopScan()
        connectionState = .connecting
        connectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
    }

    func disconnect() {
        if let p = connectedPeripheral { centralManager.cancelPeripheralConnection(p) }
        resetState()
    }

    func readFaultCodes() {
        sendCommand("03") { [weak self] response in
            self?.parseDTCResponse(response)
        }
    }

    func clearFaultCodes() {
        sendCommand("04") { [weak self] _ in
            DispatchQueue.main.async { self?.faultCodes = [] }
        }
    }

    func readLiveData() {
        // Read RPM (010C), Speed (010D), Coolant Temp (0105) sequentially
        sendCommand("010C") { [weak self] r in
            self?.liveData.rpm = self?.parseRPM(r)
            self?.sendCommand("010D") { r2 in
                self?.liveData.speedKPH = self?.parseSpeed(r2)
                self?.sendCommand("0105") { r3 in
                    self?.liveData.coolantTempC = self?.parseCoolantTemp(r3)
                }
            }
        }
    }

    // MARK: - ELM327 Initialization Sequence

    private func initializeELM327() {
        connectionState = .initializing
        let commands = ["ATZ", "ATE0", "ATL0", "ATSP0", "ATH0"]
        runCommandQueue(commands) { [weak self] in
            DispatchQueue.main.async { self?.connectionState = .connected }
        }
    }

    private func runCommandQueue(_ commands: [String], completion: @escaping () -> Void) {
        var remaining = commands
        func next() {
            guard !remaining.isEmpty else { completion(); return }
            let cmd = remaining.removeFirst()
            sendCommand(cmd) { _ in next() }
        }
        next()
    }

    // MARK: - Send / Receive

    private func sendCommand(_ command: String, handler: @escaping (String) -> Void) {
        guard let char = dataCharacteristic, let p = connectedPeripheral else { return }
        pendingCommand = handler
        responseBuffer = ""
        let data = Data((command + "\r").utf8)
        p.writeValue(data, for: char, type: .withResponse)
    }

    private func handleResponse(_ raw: String) {
        responseBuffer += raw
        // ELM327 signals end of response with ">"
        if responseBuffer.contains(">") {
            let cleaned = responseBuffer
                .replacingOccurrences(of: ">", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let handler = pendingCommand
            pendingCommand = nil
            responseBuffer = ""
            handler?(cleaned)
        }
    }

    // MARK: - Parsing

    private func parseDTCResponse(_ response: String) {
        var codes: [OBDFaultCode] = []
        let hex = response
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
        guard hex.count >= 4, !hex.hasPrefix("43") == false else { return }
        // Mode 43 response: "43 01 33 00 00 00 00" etc.
        var idx = hex.startIndex
        // skip mode byte "43"
        if hex.hasPrefix("43") { idx = hex.index(idx, offsetBy: 2) }
        while hex.distance(from: idx, to: hex.endIndex) >= 4 {
            let end = hex.index(idx, offsetBy: 4)
            let codeHex = String(hex[idx..<end])
            if codeHex != "0000", let code = dtcFromHex(codeHex) {
                codes.append(code)
            }
            idx = end
        }
        DispatchQueue.main.async { self.faultCodes = codes }
    }

    private func dtcFromHex(_ hex: String) -> OBDFaultCode? {
        guard hex.count == 4, let value = UInt16(hex, radix: 16) else { return nil }
        let prefix: Character
        switch (value >> 14) & 0x03 {
        case 0: prefix = "P"
        case 1: prefix = "C"
        case 2: prefix = "B"
        default: prefix = "U"
        }
        let code = String(format: "%@%04X", String(prefix), value & 0x3FFF)
        let info = OBDFaultCode.knownCodes[code] ?? ("Unknown fault: \(code)", FaultSeverity.medium)
        return OBDFaultCode(code: code, description: info.0, severity: info.1)
    }

    private func parseRPM(_ r: String) -> Int? {
        guard r.count >= 8 else { return nil }
        let clean = r.replacingOccurrences(of: " ", with: "")
        guard clean.count >= 8 else { return nil }
        let a = clean.index(clean.startIndex, offsetBy: 4)
        let b = clean.index(a, offsetBy: 2)
        let c = clean.index(b, offsetBy: 2)
        guard let va = UInt8(String(clean[a..<b]), radix: 16),
              let vb = UInt8(String(clean[b..<c]), radix: 16) else { return nil }
        return (Int(va) * 256 + Int(vb)) / 4
    }

    private func parseSpeed(_ r: String) -> Int? {
        guard r.count >= 6 else { return nil }
        let clean = r.replacingOccurrences(of: " ", with: "")
        guard clean.count >= 6 else { return nil }
        let a = clean.index(clean.startIndex, offsetBy: 4)
        let b = clean.index(a, offsetBy: 2)
        return UInt8(String(clean[a..<b]), radix: 16).map { Int($0) }
    }

    private func parseCoolantTemp(_ r: String) -> Int? {
        guard r.count >= 6 else { return nil }
        let clean = r.replacingOccurrences(of: " ", with: "")
        guard clean.count >= 6 else { return nil }
        let a = clean.index(clean.startIndex, offsetBy: 4)
        let b = clean.index(a, offsetBy: 2)
        return UInt8(String(clean[a..<b]), radix: 16).map { Int($0) - 40 }
    }

    private func resetState() {
        connectedPeripheral = nil
        dataCharacteristic = nil
        responseBuffer = ""
        pendingCommand = nil
        DispatchQueue.main.async { self.connectionState = .disconnected }
    }
}

// MARK: - CBCentralManagerDelegate
extension OBDService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn { } // ready
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? ""
        let isOBD = name.lowercased().contains("obd") ||
                    name.lowercased().contains("elm") ||
                    name.lowercased().contains("v-link")
        if isOBD, !availableDevices.contains(where: { $0.identifier == peripheral.identifier }) {
            availableDevices.append(peripheral)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectionState = .error(error?.localizedDescription ?? "Connection failed")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        resetState()
    }
}

// MARK: - CBPeripheralDelegate
extension OBDService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == serviceUUID {
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let chars = service.characteristics else { return }
        for char in chars where char.uuid == characteristicUUID {
            dataCharacteristic = char
            peripheral.setNotifyValue(true, for: char)
            initializeELM327()
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value,
              let str = String(data: data, encoding: .utf8) else { return }
        handleResponse(str)
    }
}

// MARK: - Supporting Types

struct OBDLiveData {
    var rpm: Int?
    var speedKPH: Int?
    var coolantTempC: Int?

    var speedMPH: Int? { speedKPH.map { Int(Double($0) * 0.621) } }
    var coolantTempF: Int? { coolantTempC.map { Int(Double($0) * 9/5 + 32) } }
}

struct OBDFaultCode: Identifiable {
    let id = UUID()
    let code: String
    let description: String
    let severity: FaultSeverity

    // Bundled knowledge base of common OBD-II codes
    static let knownCodes: [String: (String, FaultSeverity)] = [
        "P0300": ("Random/Multiple Cylinder Misfire Detected", .high),
        "P0301": ("Cylinder 1 Misfire Detected", .high),
        "P0302": ("Cylinder 2 Misfire Detected", .high),
        "P0303": ("Cylinder 3 Misfire Detected", .high),
        "P0304": ("Cylinder 4 Misfire Detected", .high),
        "P0171": ("System Too Lean (Bank 1)", .medium),
        "P0172": ("System Too Rich (Bank 1)", .medium),
        "P0420": ("Catalyst System Efficiency Below Threshold (Bank 1)", .medium),
        "P0440": ("Evaporative Emission System Malfunction", .low),
        "P0442": ("Evaporative Emission System Leak Detected (Small Leak)", .low),
        "P0455": ("Evaporative Emission System Leak Detected (Large Leak)", .medium),
        "P0128": ("Coolant Temperature Below Thermostat Regulating Temperature", .medium),
        "P0505": ("Idle Air Control System Malfunction", .medium),
        "P0101": ("Mass Air Flow Sensor Circuit Range/Performance", .medium),
        "P0102": ("Mass Air Flow Sensor Circuit Low Input", .medium),
        "P0113": ("Intake Air Temperature Sensor Circuit High Input", .medium),
        "P0131": ("O2 Sensor Circuit Low Voltage (Bank 1, Sensor 1)", .medium),
        "P0141": ("O2 Sensor Heater Circuit Malfunction (Bank 1, Sensor 2)", .medium),
        "P0320": ("Ignition/Distributor Engine Speed Input Circuit Malfunction", .high),
        "P0335": ("Crankshaft Position Sensor A Circuit Malfunction", .critical),
        "P0340": ("Camshaft Position Sensor A Circuit Malfunction (Bank 1)", .high),
        "P0401": ("Exhaust Gas Recirculation Insufficient Flow Detected", .medium),
        "P0404": ("Exhaust Gas Recirculation Circuit Range/Performance", .medium),
        "P0500": ("Vehicle Speed Sensor Malfunction", .medium),
        "P0601": ("Internal Control Module Memory Check Sum Error", .critical),
        "P0606": ("ECM/PCM Processor Fault", .critical),
        "P0700": ("Transmission Control System Malfunction", .high),
        "P0715": ("Input/Turbine Speed Sensor A Circuit Malfunction", .high),
        "P1000": ("OBD Systems Readiness Test Not Complete", .low),
        "C0035": ("Right Front Wheel Speed Sensor Circuit", .high),
        "C0040": ("Left Front Wheel Speed Sensor Circuit", .high),
        "B0001": ("Driver Frontal Stage 1 Air Bag Module Deployment Control", .critical),
        "U0100": ("Lost Communication With ECM/PCM \"A\"", .critical),
        "U0073": ("Control Module Communication Bus Off", .critical),
    ]
}
