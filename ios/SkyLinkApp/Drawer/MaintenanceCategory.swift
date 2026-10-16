import Foundation

/// The ten top-level categories from docs/04-category-tree.md.
///
/// Hard-coded for M0. In M1 these come from `categories.seed.json` so the
/// drawer and the content pipeline share one source.
struct MaintenanceCategory: Identifiable, Hashable, Sendable {
    let slug: String
    let title: String
    let symbolName: String
    let jobCount: Int

    var id: String { slug }

    static let all: [MaintenanceCategory] = [
        .init(slug: "fluids-filters", title: "Fluids & Filters", symbolName: "drop.fill", jobCount: 11),
        .init(slug: "tires-wheels", title: "Tires & Wheels", symbolName: "circle.circle", jobCount: 9),
        .init(slug: "battery-electrical", title: "Battery & Electrical", symbolName: "bolt.fill", jobCount: 9),
        .init(slug: "brakes", title: "Brakes", symbolName: "octagon", jobCount: 7),
        .init(slug: "engine-performance", title: "Engine & Performance", symbolName: "engine.combustion.fill", jobCount: 9),
        .init(slug: "warning-lights", title: "Warning Lights", symbolName: "exclamationmark.triangle.fill", jobCount: 8),
        .init(slug: "hvac", title: "Heating & Cooling", symbolName: "fan.fill", jobCount: 6),
        .init(slug: "exterior-glass", title: "Exterior & Glass", symbolName: "windshield.front.and.wiper", jobCount: 6),
        .init(slug: "seasonal-preventive", title: "Seasonal & Preventive", symbolName: "calendar", jobCount: 6),
        .init(slug: "roadside-emergencies", title: "Roadside Emergencies", symbolName: "light.beacon.max.fill", jobCount: 9),
    ]
}
