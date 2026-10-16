import SwiftUI

struct ServiceLogView: View {
    @Environment(GarageStore.self) private var garage

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 9) {
                ForEach(garage.records) { record in
                    ServiceRecordRow(record: record)
                }
            }
            .padding(20)
        }
        .background(SkyLinkPalette.garageBlack)
        .navigationTitle("Service log")
        .navigationBarTitleDisplayMode(.inline)
    }
}
