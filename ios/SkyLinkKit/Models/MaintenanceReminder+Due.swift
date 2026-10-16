import Foundation

extension MaintenanceReminder {
    /// Miles left before this is due, if the reminder tracks mileage.
    func milesRemaining(currentMileage: Int) -> Int? {
        guard let intervalMiles, let lastDoneMileage else { return nil }
        return (lastDoneMileage + intervalMiles) - currentMileage
    }

    /// The date this is due, if the reminder tracks time.
    func dueDate(calendar: Calendar = .current) -> Date? {
        guard let intervalMonths, let lastDoneAt else { return nil }
        return calendar.date(byAdding: .month, value: intervalMonths, to: lastDoneAt)
    }

    /// Whichever comes first decides the status.
    func severity(currentMileage: Int, now: Date = .now) -> DiagnosticSeverity {
        var worst = DiagnosticSeverity.safe

        if let miles = milesRemaining(currentMileage: currentMileage) {
            if miles <= 0 { worst = .limited }
            else if miles <= 500 { worst = max(worst, .soon) }
        }

        if let due = dueDate() {
            let days = Calendar.current.dateComponents([.day], from: now, to: due).day ?? 0
            if days <= 0 { worst = .limited }
            else if days <= 30 { worst = max(worst, .soon) }
        }

        return worst
    }

    /// Plain-language, both units, because one of them is meaningless to any
    /// given driver and we don't know which.
    func summary(currentMileage: Int) -> String {
        let miles = milesRemaining(currentMileage: currentMileage)
        let due = dueDate()

        switch (miles, due) {
        case let (miles?, due?):
            return "\(Self.milesPhrase(miles)) or \(due.formatted(.dateTime.month().year()))"
        case let (miles?, nil):
            return Self.milesPhrase(miles)
        case let (nil, due?):
            return due.formatted(.dateTime.month().day().year())
        default:
            return "No schedule set"
        }
    }

    private static func milesPhrase(_ miles: Int) -> String {
        miles <= 0 ? "Overdue" : "^[\(miles) mile](inflect: true)"
    }
}

extension DiagnosticSeverity: Comparable {
    private var rank: Int {
        switch self {
        case .safe: 0
        case .soon: 1
        case .limited: 2
        case .stop: 3
        }
    }

    static func < (lhs: DiagnosticSeverity, rhs: DiagnosticSeverity) -> Bool {
        lhs.rank < rhs.rank
    }
}
