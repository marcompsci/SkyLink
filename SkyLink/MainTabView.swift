import SwiftUI

struct MainTabView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var selectedTab = 0
    @State private var sosPresented = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                CarAssistantView()
                    .tabItem {
                        Label("Sky", systemImage: "waveform.and.car")
                    }
                    .tag(0)

                DiagnosticsView()
                    .tabItem {
                        Label("Diagnose", systemImage: "wrench.and.screwdriver.fill")
                    }
                    .tag(1)

                MindFlowView()
                    .tabItem {
                        Label("MindFlow", systemImage: "brain.head.profile")
                    }
                    .tag(2)

                CompanionView()
                    .tabItem {
                        Label("Companion", systemImage: "accessibility.fill")
                    }
                    .tag(3)
            }
            .tint(Color.skyBlue)

            // Floating SOS button — always visible
            if env.sos.phase == .inactive {
                SOSFloatingButton {
                    sosPresented = true
                    env.sos.activate()
                }
                .padding(.trailing, 20)
                .padding(.bottom, 90)
            }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: Binding(
            get: { env.sos.phase != .inactive },
            set: { if !$0 { env.sos.deactivate() } }
        )) {
            SOSView()
                .environment(env)
        }
        #else
        .sheet(isPresented: Binding(
            get: { env.sos.phase != .inactive },
            set: { if !$0 { env.sos.deactivate() } }
        )) {
            SOSView()
                .environment(env)
        }
        #endif
        .preferredColorScheme(.dark)
    }
}
