import SwiftUI

// MARK: - Colors
extension Color {
    static let skyBackground   = Color(red: 0.04, green: 0.04, blue: 0.07)
    static let skyCard         = Color(red: 0.08, green: 0.08, blue: 0.12)
    static let skyCardElevated = Color(red: 0.11, green: 0.11, blue: 0.17)
    static let skyBlue         = Color(red: 0.04, green: 0.52, blue: 1.00)
    static let sosRed          = Color(red: 1.00, green: 0.23, blue: 0.19)
    static let safeGreen       = Color(red: 0.19, green: 0.82, blue: 0.35)
    static let warningAmber    = Color(red: 1.00, green: 0.62, blue: 0.04)
    static let textPrimary     = Color.white
    static let textSecondary   = Color(white: 0.60)
    static let textTertiary    = Color(white: 0.38)
    static let borderSubtle    = Color(white: 0.14)
}

// MARK: - Card
struct SkyCard<Content: View>: View {
    var elevated = false
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .background(elevated ? Color.skyCardElevated : Color.skyCard)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Voice Pulse
struct VoicePulseView: View {
    let isActive: Bool
    @State private var pulse = false

    var body: some View {
        ZStack {
            if isActive {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .stroke(Color.skyBlue.opacity(0.28 - Double(i) * 0.07), lineWidth: 2)
                        .scaleEffect(pulse ? 1.0 + Double(i) * 0.45 : 1.0)
                        .animation(
                            .easeOut(duration: 1.3).repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.32),
                            value: pulse
                        )
                }
            }
            Circle()
                .fill(isActive ? Color.skyBlue : Color.skyCard)
                .frame(width: 72, height: 72)
            Image(systemName: isActive ? "waveform" : "mic.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(isActive ? .white : Color.textSecondary)
        }
        .onAppear { pulse = isActive }
        .onChange(of: isActive) { _, v in pulse = v }
    }
}

// MARK: - SOS Button
struct SOSFloatingButton: View {
    let action: () -> Void
    @State private var pressing = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.sosRed)
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.sosRed.opacity(0.55),
                            radius: pressing ? 6 : 14, y: pressing ? 2 : 5)
                Text("SOS")
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(.white)
            }
        }
        .scaleEffect(pressing ? 0.90 : 1.0)
        .animation(.spring(response: 0.18), value: pressing)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressing = true }
                .onEnded   { _ in pressing = false }
        )
    }
}

// MARK: - Repair Step Card
struct RepairStepCard: View {
    let stepNumber: Int
    let total: Int
    let instruction: String
    let symbol: String
    let checkpoint: String?
    let isComplete: Bool

    var body: some View {
        SkyCard(elevated: true) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Step \(stepNumber) of \(total)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.textSecondary)
                    Spacer()
                    if isComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color.safeGreen)
                    }
                }
                Image(systemName: symbol)
                    .font(.system(size: 52))
                    .foregroundStyle(Color.skyBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                Text(instruction)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                if let cp = checkpoint {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(Color.safeGreen)
                            .font(.callout)
                        Text(cp)
                            .font(.callout)
                            .foregroundStyle(Color.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(Color.safeGreen.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Severity Badge
struct SeverityBadge: View {
    enum Level { case low, medium, high, critical }
    let level: Level

    private var color: Color {
        switch level {
        case .low:      return .safeGreen
        case .medium:   return .warningAmber
        case .high:     return .sosRed
        case .critical: return .sosRed
        }
    }
    private var label: String {
        switch level {
        case .low:      return "LOW"
        case .medium:   return "MEDIUM"
        case .high:     return "HIGH"
        case .critical: return "CRITICAL"
        }
    }

    var body: some View {
        Text(label)
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(color)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(color.opacity(0.15))
            .clipShape(Capsule())
    }
}

// MARK: - Primary Button
struct SkyPrimaryButton: View {
    let title: String
    let systemImage: String?
    let color: Color
    let action: () -> Void

    init(_ title: String, systemImage: String? = nil, color: Color = .skyBlue, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let img = systemImage {
                    Image(systemName: img)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Section Header
struct SkySectionHeader: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(Color.textTertiary)
            .tracking(1.4)
    }
}
