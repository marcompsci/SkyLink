import SwiftUI

struct SOSTriageGridView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var chosen: SOSSituation?

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What happened?").skyLabel(SOSPalette.dim)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(SOSSituation.allCases) { situation in
                    SOSSituationTile(situation: situation, isChosen: chosen == situation) {
                        withAnimation(SkyMotion.respecting(reduceMotion, SkyMotion.press)) {
                            chosen = situation
                        }
                    }
                }
            }

            if chosen != nil {
                Text("Next: Auto decides whether this is fixable where you are, or whether you need a tow. That judgement is M2.")
                    .font(SkyType.caption)
                    .foregroundStyle(SOSPalette.dim)
                    .transition(.opacity)
            }
        }
    }
}
