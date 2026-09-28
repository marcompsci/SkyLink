import Foundation
import SwiftUI
import SwiftData

// MARK: - Vehicle

@Model
final class Vehicle {
    var id: UUID
    var make: String
    var model: String
    var year: Int
    var vin: String
    var mileage: Int
    var notes: String
    var dateAdded: Date

    init(make: String, model: String, year: Int, vin: String = "", mileage: Int = 0) {
        self.id = UUID()
        self.make = make
        self.model = model
        self.year = year
        self.vin = vin
        self.mileage = mileage
        self.notes = ""
        self.dateAdded = Date()
    }

    var displayName: String { "\(year) \(make) \(model)" }
}

// MARK: - Fault Code

@Model
final class FaultCode {
    var id: UUID
    var code: String
    var shortDescription: String
    var longDescription: String
    var severityRaw: Int
    var dateRead: Date
    var isResolved: Bool
    var vehicleId: UUID?

    init(code: String, shortDescription: String, longDescription: String,
         severity: FaultSeverity, vehicleId: UUID? = nil) {
        self.id = UUID()
        self.code = code
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.severityRaw = severity.rawValue
        self.dateRead = Date()
        self.isResolved = false
        self.vehicleId = vehicleId
    }

    var severity: FaultSeverity { FaultSeverity(rawValue: severityRaw) ?? .medium }
}

enum FaultSeverity: Int, Codable {
    case low = 0, medium = 1, high = 2, critical = 3

    var label: String {
        switch self {
        case .low: "Low"
        case .medium: "Medium"
        case .high: "High"
        case .critical: "Critical"
        }
    }

    var badgeLevel: SeverityBadge.Level {
        switch self {
        case .low: .low
        case .medium: .medium
        case .high: .high
        case .critical: .critical
        }
    }
}

// MARK: - SOS Session

@Model
final class SOSSession {
    var id: UUID
    var date: Date
    var latitude: Double
    var longitude: Double
    var address: String
    var mileMarker: String
    var issueTypeRaw: String
    var isResolved: Bool
    var pendingLocationShare: Bool

    init(latitude: Double, longitude: Double, address: String,
         mileMarker: String = "", issueType: TriageIssue = .other) {
        self.id = UUID()
        self.date = Date()
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.mileMarker = mileMarker
        self.issueTypeRaw = issueType.rawValue
        self.isResolved = false
        self.pendingLocationShare = false
    }

    var issueType: TriageIssue { TriageIssue(rawValue: issueTypeRaw) ?? .other }

    var shareText: String {
        var text = "My car broke down at: \(address)"
        if !mileMarker.isEmpty { text += " (near mile marker \(mileMarker))" }
        return text
    }
}

// MARK: - MindFlow Entry

@Model
final class MindFlowEntry {
    var id: UUID
    var date: Date
    var transcription: String
    var moodRaw: String
    var tags: [String]
    var durationSeconds: Double

    init(transcription: String, mood: MindFlowMood = .neutral,
         tags: [String] = [], duration: Double = 0) {
        self.id = UUID()
        self.date = Date()
        self.transcription = transcription
        self.moodRaw = mood.rawValue
        self.tags = tags
        self.durationSeconds = duration
    }

    var mood: MindFlowMood { MindFlowMood(rawValue: moodRaw) ?? .neutral }
}

enum MindFlowMood: String, CaseIterable {
    case great, good, neutral, low, stressed

    var symbol: String {
        switch self {
        case .great: "sun.max.fill"
        case .good: "cloud.sun.fill"
        case .neutral: "cloud.fill"
        case .low: "cloud.rain.fill"
        case .stressed: "bolt.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .great: .safeGreen
        case .good: .skyBlue
        case .neutral: .textSecondary
        case .low: .warningAmber
        case .stressed: .sosRed
        }
    }
}

// MARK: - Triage

enum TriageIssue: String, CaseIterable, Codable {
    case wontStart  = "Won't Start"
    case flatTire   = "Flat Tire"
    case overheating = "Overheating"
    case outOfFuel  = "Out of Fuel"
    case lockedOut  = "Locked Out"
    case other      = "Something Else"

    var symbol: String {
        switch self {
        case .wontStart:   "key.fill"
        case .flatTire:    "circle.slash"
        case .overheating: "thermometer.high"
        case .outOfFuel:   "fuelpump.fill"
        case .lockedOut:   "lock.fill"
        case .other:       "questionmark.circle.fill"
        }
    }

    var defaultDispatch: DispatchType {
        switch self {
        case .wontStart:   .jumpStart
        case .flatTire:    .tireChange
        case .overheating: .tow
        case .outOfFuel:   .fuelDelivery
        case .lockedOut:   .lockout
        case .other:       .tow
        }
    }
}

enum DispatchType: String, CaseIterable {
    case tow          = "Tow Truck"
    case jumpStart    = "Jump Start"
    case fuelDelivery = "Fuel Delivery"
    case lockout      = "Lockout Service"
    case tireChange   = "Tire Change"

    var symbol: String {
        switch self {
        case .tow:          "truck.box.fill"
        case .jumpStart:    "bolt.fill"
        case .fuelDelivery: "fuelpump.fill"
        case .lockout:      "lock.open.fill"
        case .tireChange:   "circle.fill"
        }
    }

    var searchQuery: String {
        switch self {
        case .tow:          "towing service"
        case .jumpStart:    "roadside assistance"
        case .fuelDelivery: "fuel delivery"
        case .lockout:      "auto locksmith"
        case .tireChange:   "mobile tire change"
        }
    }
}

// MARK: - Repair Guide Data

struct RepairGuide {
    let issue: TriageIssue
    let title: String
    let safetyWarning: String?
    let steps: [RepairStep]

    static let guides: [TriageIssue: RepairGuide] = [
        .flatTire: RepairGuide(
            issue: .flatTire,
            title: "Changing a Flat Tire",
            safetyWarning: "Only attempt this on a level surface well off the road. Never change a tire on a freeway shoulder at night.",
            steps: [
                RepairStep("Turn on your hazard lights and park on a flat, stable surface far from traffic.",
                           symbol: "light.beacon.max.fill",
                           checkpoint: "Car is fully stopped and in park."),
                RepairStep("Get the spare tire, jack, and lug wrench from your trunk.",
                           symbol: "wrench.and.screwdriver.fill",
                           checkpoint: "Spare tire is inflated and ready."),
                RepairStep("Loosen the lug nuts slightly (counterclockwise) before jacking the car — just break them free, don't remove yet.",
                           symbol: "circle.hexagongrid.fill",
                           checkpoint: "Each lug nut moves when turned."),
                RepairStep("Place the jack under the vehicle's jack point (usually a notch in the frame near the flat tire). Raise until the flat is 6 inches off the ground.",
                           symbol: "arrow.up.to.line.compact",
                           checkpoint: "Tire clears the ground. Car is stable on jack."),
                RepairStep("Remove the lug nuts completely and pull off the flat tire.",
                           symbol: "minus.circle.fill",
                           checkpoint: "Flat tire is off."),
                RepairStep("Mount the spare tire. Hand-tighten lug nuts in a star pattern.",
                           symbol: "plus.circle.fill",
                           checkpoint: "Spare is seated flush on the hub."),
                RepairStep("Lower the jack slowly until the tire touches the ground. Tighten lug nuts fully in a star pattern.",
                           symbol: "arrow.down.to.line.compact",
                           checkpoint: "All lug nuts are tight."),
                RepairStep("Drive slowly — spare tires are limited to 50 mph. Get your regular tire repaired or replaced today.",
                           symbol: "gauge.with.dots.needle.33percent",
                           checkpoint: nil)
            ]
        ),
        .wontStart: RepairGuide(
            issue: .wontStart,
            title: "Jump Starting Your Car",
            safetyWarning: "Never jump a cracked or leaking battery. Do not allow jumper cable clamps to touch each other.",
            steps: [
                RepairStep("Position the working car so its battery is close to yours. Turn both cars off.",
                           symbol: "car.2.fill",
                           checkpoint: "Both cars are off."),
                RepairStep("Connect the RED (positive +) cable to the dead battery's positive terminal.",
                           symbol: "plus.circle.fill",
                           checkpoint: "Red clamp is on dead battery positive."),
                RepairStep("Connect the other RED clamp to the working battery's positive terminal.",
                           symbol: "plus.circle.fill",
                           checkpoint: "Red cable connects both positive terminals."),
                RepairStep("Connect the BLACK (negative −) clamp to the working battery's negative terminal.",
                           symbol: "minus.circle.fill",
                           checkpoint: "Black clamp is on good battery negative."),
                RepairStep("Connect the other BLACK clamp to an unpainted metal surface on your car's engine block — NOT the dead battery.",
                           symbol: "bolt.fill",
                           checkpoint: "Black clamp is on bare metal, not battery."),
                RepairStep("Start the working car and let it run 2–3 minutes.",
                           symbol: "timer",
                           checkpoint: "Working car is running."),
                RepairStep("Start your car. If it starts, remove cables in REVERSE order: black from engine, black from good battery, red from good battery, red from your battery.",
                           symbol: "key.fill",
                           checkpoint: "Your car is running. Cables removed safely.")
            ]
        ),
        .outOfFuel: RepairGuide(
            issue: .outOfFuel,
            title: "Out of Fuel",
            safetyWarning: nil,
            steps: [
                RepairStep("Coast to a safe stop as far off the road as possible. Turn on hazard lights.",
                           symbol: "light.beacon.max.fill",
                           checkpoint: "Car is safely off the road."),
                RepairStep("Call for fuel delivery or ask someone to bring a gas can.",
                           symbol: "phone.fill",
                           checkpoint: "Help is on the way."),
                RepairStep("When fuel arrives, add at least 1 gallon. Some fuel-injected cars need a few cranks to prime the fuel system before starting.",
                           symbol: "fuelpump.fill",
                           checkpoint: "Fuel added."),
                RepairStep("Turn the key to 'On' (not start) for 5 seconds, then off. Repeat twice before cranking — this primes the fuel pump.",
                           symbol: "key.fill",
                           checkpoint: "Engine starts normally.")
            ]
        )
    ]
}

struct RepairStep {
    let instruction: String
    let symbol: String
    let checkpoint: String?

    init(_ instruction: String, symbol: String, checkpoint: String?) {
        self.instruction = instruction
        self.symbol = symbol
        self.checkpoint = checkpoint
    }
}
