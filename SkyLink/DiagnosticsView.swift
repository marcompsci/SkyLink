import SwiftUI
import SwiftData
import MapKit
import CoreBluetooth

// MARK: - Diagnostics + Part Finder (tab)

struct DiagnosticsView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skyBackground.ignoresSafeArea()
                VStack(spacing: 0) {
                    Picker("", selection: $selectedTab) {
                        Text("Fault Codes").tag(0)
                        Text("Live Data").tag(1)
                        Text("Parts").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    switch selectedTab {
                    case 0: FaultCodesTab()
                    case 1: LiveDataTab()
                    default: PartFinderTab()
                    }
                }
            }
            .navigationTitle("Diagnose")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    OBDStatusButton()
                }
            }
        }
    }
}

// MARK: - OBD Status Button

private struct OBDStatusButton: View {
    @Environment(AppEnvironment.self) private var env
    @State private var showingConnect = false

    var icon: String {
        switch env.obd.connectionState {
        case .connected:    return "cable.connector.horizontal"
        case .scanning, .connecting, .initializing: return "antenna.radiowaves.left.and.right"
        default:            return "cable.connector.horizontal"
        }
    }
    var tint: Color {
        switch env.obd.connectionState {
        case .connected:    return .safeGreen
        case .scanning, .connecting, .initializing: return .warningAmber
        default:            return .textSecondary
        }
    }

    var body: some View {
        Button { showingConnect = true } label: {
            Image(systemName: icon).foregroundStyle(tint)
        }
        .sheet(isPresented: $showingConnect) { OBDConnectSheet() }
    }
}

// MARK: - OBD Connect Sheet

private struct OBDConnectSheet: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.dismiss) private var dismiss

    var statusText: String {
        switch env.obd.connectionState {
        case .disconnected:   return "Not Connected"
        case .scanning:       return "Scanning for devices…"
        case .connecting:     return "Connecting…"
        case .initializing:   return "Initializing adapter…"
        case .connected:      return "Connected"
        case .error(let e):   return "Error: \(e)"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skyBackground.ignoresSafeArea()
                VStack(spacing: 24) {
                    SkyCard {
                        VStack(spacing: 12) {
                            Image(systemName: "cable.connector.horizontal")
                                .font(.system(size: 44))
                                .foregroundStyle(Color.skyBlue)
                            Text("OBD-II Adapter")
                                .font(.headline)
                                .foregroundStyle(Color.textPrimary)
                            Text("Plug an ELM327 Bluetooth adapter into your car's OBD-II port (under the dash, driver's side).")
                                .font(.callout)
                                .foregroundStyle(Color.textSecondary)
                                .multilineTextAlignment(.center)
                            Text(statusText)
                                .font(.callout.weight(.semibold))
                                .foregroundStyle(Color.skyBlue)
                        }
                        .padding(20)
                    }
                    .padding(.horizontal, 20)

                    if !env.obd.availableDevices.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            SkySectionHeader(title: "Found Devices")
                                .padding(.horizontal, 20)
                            ForEach(env.obd.availableDevices, id: \.identifier) { device in
                                Button {
                                    env.obd.connect(to: device)
                                } label: {
                                    HStack {
                                        Image(systemName: "cable.connector")
                                            .foregroundStyle(Color.skyBlue)
                                        Text(device.name ?? "Unknown Device")
                                            .foregroundStyle(Color.textPrimary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(Color.textTertiary)
                                    }
                                    .padding(14)
                                    .background(Color.skyCard)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    if case .connected = env.obd.connectionState {
                        SkyPrimaryButton("Done", color: .safeGreen) { dismiss() }
                            .padding(.horizontal, 20)
                    } else {
                        SkyPrimaryButton("Scan for Adapter", systemImage: "antenna.radiowaves.left.and.right") {
                            env.obd.startScan()
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("Connect Adapter")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Fault Codes Tab

private struct FaultCodesTab: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.modelContext) private var modelContext
    @State private var explaining: OBDFaultCode?

    var body: some View {
        Group {
            if env.obd.faultCodes.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    if case .connected = env.obd.connectionState {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(Color.safeGreen)
                        Text("No fault codes found")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(Color.textPrimary)
                        SkyPrimaryButton("Scan Now", systemImage: "magnifyingglass") {
                            env.obd.readFaultCodes()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        Image(systemName: "cable.connector.horizontal")
                            .font(.system(size: 56))
                            .foregroundStyle(Color.textTertiary)
                        Text("Connect your OBD-II adapter to read fault codes")
                            .font(.callout)
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    Spacer()
                }
            } else {
                List {
                    ForEach(env.obd.faultCodes) { code in
                        FaultCodeRow(code: code) {
                            explaining = code
                        }
                        .listRowBackground(Color.skyCard)
                    }
                    Section {
                        Button(role: .destructive) {
                            env.obd.clearFaultCodes()
                        } label: {
                            Label("Clear All Codes", systemImage: "trash")
                        }
                    }
                }
                #if os(iOS)
                .listStyle(.insetGrouped)
                #else
                .listStyle(.plain)
                #endif
                .scrollContentBackground(.hidden)
            }
        }
        .sheet(item: $explaining) { code in
            FaultCodeDetailSheet(code: code)
        }
    }
}

private struct FaultCodeRow: View {
    let code: OBDFaultCode
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(code.code)
                        .font(.headline.monospaced())
                        .foregroundStyle(Color.textPrimary)
                    Text(code.description)
                        .font(.callout)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                }
                Spacer()
                SeverityBadge(level: code.severity.badgeLevel)
            }
            .padding(.vertical, 4)
        }
    }
}

private struct FaultCodeDetailSheet: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.dismiss) private var dismiss
    let code: OBDFaultCode
    @State private var explanation = ""
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            ZStack {
                Color.skyBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text(code.code)
                                .font(.title.bold().monospaced())
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                            SeverityBadge(level: code.severity.badgeLevel)
                        }
                        Text(code.description)
                            .font(.title3.weight(.medium))
                            .foregroundStyle(Color.textSecondary)

                        Divider().background(Color.borderSubtle)

                        if isLoading {
                            HStack { ProgressView(); Text("Asking Sky…") }
                                .foregroundStyle(Color.textSecondary)
                        } else {
                            Text(explanation)
                                .font(.callout)
                                .foregroundStyle(Color.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Code Details")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
            .task {
                explanation = await env.ai.explain(faultCode: code.code)
                isLoading = false
            }
        }
    }
}

// MARK: - Live Data Tab

private struct LiveDataTab: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if case .connected = env.obd.connectionState {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        LiveDataCard(
                            title: "RPM",
                            value: env.obd.liveData.rpm.map { "\($0)" } ?? "—",
                            unit: "rpm",
                            symbol: "gauge.with.dots.needle.67percent"
                        )
                        LiveDataCard(
                            title: "Speed",
                            value: env.obd.liveData.speedMPH.map { "\($0)" } ?? "—",
                            unit: "mph",
                            symbol: "speedometer"
                        )
                        LiveDataCard(
                            title: "Coolant Temp",
                            value: env.obd.liveData.coolantTempF.map { "\($0)" } ?? "—",
                            unit: "°F",
                            symbol: "thermometer.medium"
                        )
                    }
                    .padding(16)

                    SkyPrimaryButton("Refresh", systemImage: "arrow.clockwise") {
                        env.obd.readLiveData()
                    }
                    .padding(.horizontal, 20)
                } else {
                    VStack(spacing: 16) {
                        Spacer(minLength: 60)
                        Image(systemName: "cable.connector.horizontal")
                            .font(.system(size: 56))
                            .foregroundStyle(Color.textTertiary)
                        Text("Connect your OBD-II adapter to see live engine data")
                            .font(.callout)
                            .foregroundStyle(Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
            }
            .padding(.top, 16)
        }
    }
}

private struct LiveDataCard: View {
    let title: String
    let value: String
    let unit: String
    let symbol: String

    var body: some View {
        SkyCard(elevated: true) {
            VStack(spacing: 10) {
                Image(systemName: symbol)
                    .font(.system(size: 28))
                    .foregroundStyle(Color.skyBlue)
                Text(value)
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.textPrimary)
                Text(unit)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.textSecondary)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }
}

// MARK: - Part Finder Tab

private struct PartFinderTab: View {
    @Environment(AppEnvironment.self) private var env
    @State private var searchQuery = ""
    @State private var results: [MKMapItem] = []
    @State private var isSearching = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.textSecondary)
                TextField("Part or store name…", text: $searchQuery)
                    .foregroundStyle(Color.textPrimary)
                    .tint(Color.skyBlue)
                    .submitLabel(.search)
                    .onSubmit { Task { await search() } }
                if isSearching {
                    ProgressView()
                }
            }
            .padding(12)
            .background(Color.skyCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            HStack(spacing: 8) {
                ForEach(["Auto Parts", "Tire Shop", "Mechanic"], id: \.self) { chip in
                    Button {
                        searchQuery = chip
                        Task { await search() }
                    } label: {
                        Text(chip)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Color.skyCard)
                            .foregroundStyle(Color.textSecondary)
                            .clipShape(Capsule())
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            if results.isEmpty && !isSearching {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(Color.textTertiary)
                    Text("Find auto parts stores near you")
                        .font(.callout)
                        .foregroundStyle(Color.textSecondary)
                    Spacer()
                }
            } else {
                List(results, id: \.self) { item in
                    PartStoreRow(item: item)
                        .listRowBackground(Color.skyCard)
                }
                #if os(iOS)
                .listStyle(.insetGrouped)
                #else
                .listStyle(.plain)
                #endif
                .scrollContentBackground(.hidden)
            }
        }
    }

    private func search() async {
        guard !searchQuery.isEmpty else { return }
        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery + " auto parts"
        if let loc = env.location.currentLocation {
            request.region = MKCoordinateRegion(
                center: loc.coordinate,
                latitudinalMeters: 16000, longitudinalMeters: 16000
            )
        }
        let search = MKLocalSearch(request: request)
        if let response = try? await search.start() {
            results = response.mapItems.prefix(10).map { $0 }
        }
        isSearching = false
    }
}

private struct PartStoreRow: View {
    let item: MKMapItem

    var body: some View {
        Button {
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "building.2.fill")
                    .foregroundStyle(Color.skyBlue)
                    .frame(width: 36, height: 36)
                    .background(Color.skyBlue.opacity(0.15))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.name ?? "Unknown")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(Color.textPrimary)
                    if let addr = item.placemark.title {
                        Text(addr)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                    }
                }
                Spacer()
                Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                    .foregroundStyle(Color.skyBlue)
            }
            .padding(.vertical, 4)
        }
    }
}
