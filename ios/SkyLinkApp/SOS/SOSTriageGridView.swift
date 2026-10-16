import SwiftUI

struct SOSTriageGridView: View {
    @State private var chosen: SOSSituation?

    private let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WHAT HAPPENED?")
                .font(.system(size: 11, weight: .bold))
                .kerning(1.4)
                .foregroundStyle(SOSPalette.dim)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(SOSSituation.allCases) { situation in
                    SOSSituationTile(situation: situation, isChosen: chosen == situation) {
                        chosen = situation
                    }
                }
            }

            if chosen != nil {
                Text("Next: Auto decides whether this is fixable where you are, or whether you need a tow. That judgement is M2.")
                    .font(.system(size: 12.5))
                    .foregroundStyle(SOSPalette.dim)
            }
        }
    }
}
