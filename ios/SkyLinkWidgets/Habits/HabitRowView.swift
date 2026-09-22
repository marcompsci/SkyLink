import SwiftUI

struct HabitRowView: View {
    let habit: Habit

    var body: some View {
        HStack(spacing: 10) {
            Button(intent: ToggleHabitIntent(habitID: habit.id)) {
                Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(habit.isDoneToday ? SkyLinkPalette.mindflowYellow : .white.opacity(0.65))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(habit.isDoneToday ? "Mark \(habit.title) not done" : "Mark \(habit.title) done")

            Text(habit.title)
                .font(.system(size: 14, weight: .medium))
                .strikethrough(habit.isDoneToday, color: .white.opacity(0.5))
                .foregroundStyle(habit.isDoneToday ? .white.opacity(0.6) : .white)
                .lineLimit(1)

            Spacer(minLength: 4)

            if habit.streak > 0 {
                Text("\(habit.streak)d")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundStyle(SkyLinkPalette.mindflowYellow.opacity(0.9))
            }
        }
    }
}
