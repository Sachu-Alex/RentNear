import WidgetKit
import SwiftUI

// MARK: - SF Symbol mapping

private func sfSymbol(for icon: String) -> String {
    switch icon {
    case "fitness":      return "dumbbell.fill"
    case "camera":       return "camera.fill"
    case "construction": return "hammer.fill"
    case "build":        return "wrench.and.screwdriver.fill"
    case "home":         return "house.fill"
    case "garden":       return "leaf.fill"
    case "sports":       return "figure.run"
    case "tools":        return "screwdriver.fill"
    case "audio":        return "speaker.wave.2.fill"
    case "vehicle":      return "car.fill"
    default:             return "archivebox.fill"
    }
}

// MARK: - Brand colours

private let teal      = Color(red: 45/255,  green: 212/255, blue: 191/255) // #2DD4BF
private let darkGreen = Color(red: 11/255,  green: 110/255, blue: 107/255) // #0B6E6B
private let deepDark  = Color(red:  7/255,  green:  58/255, blue:  57/255) // #073A39
private let mid       = Color(red:  9/255,  green:  77/255, blue:  75/255) // #094D4B

// MARK: - Entry view

struct NearbyItemsWidgetEntryView: View {
    var entry: NearbyItemsProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall: smallBody
        default:           mediumBody
        }
    }

    // ── Small ──────────────────────────────────────────────────────────────

    var smallBody: some View {
        VStack(alignment: .leading, spacing: 7) {
            // Header
            HStack(spacing: 7) {
                logoMark(size: 24, radius: 7)
                Text("RentNear")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: 1)

            if entry.items.isEmpty {
                Spacer()
                emptyState(iconSize: 16, fontSize: 10)
                Spacer()
            } else {
                ForEach(Array(entry.items.prefix(3).enumerated()), id: \.offset) { _, item in
                    HStack(spacing: 6) {
                        Image(systemName: sfSymbol(for: item.icon))
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(teal)
                            .frame(width: 14)
                        Text(item.name)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer(minLength: 2)
                        Text(item.distance)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(teal)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .padding(12)
    }

    // ── Medium ─────────────────────────────────────────────────────────────

    var mediumBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 10) {
                logoMark(size: 32, radius: 9)

                VStack(alignment: .leading, spacing: 1) {
                    Text("RentNear")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Text("Available near you")
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.white.opacity(0.50))
                }

                Spacer()

                // Live badge
                HStack(spacing: 4) {
                    Circle()
                        .fill(teal)
                        .frame(width: 5, height: 5)
                    Text("Live")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(teal)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(Capsule().fill(teal.opacity(0.14)))
            }
            .padding(.horizontal, 14)
            .padding(.top, 13)
            .padding(.bottom, 9)

            Rectangle()
                .fill(Color.white.opacity(0.10))
                .frame(height: 1)

            if entry.items.isEmpty {
                Spacer()
                emptyState(iconSize: 20, fontSize: 11)
                Spacer()
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(entry.items.prefix(4).enumerated()), id: \.offset) { idx, item in
                        mediumRow(
                            item: item,
                            isLast: idx == min(entry.items.count, 4) - 1
                        )
                    }
                }
                .padding(.top, 2)
            }

            Spacer(minLength: 0)
        }
    }

    // ── Row ────────────────────────────────────────────────────────────────

    func mediumRow(item: NearbyRentalItem, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(teal.opacity(0.14))
                        .frame(width: 30, height: 30)
                    Image(systemName: sfSymbol(for: item.icon))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(teal)
                }
                Text(item.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
                Text(item.distance)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(teal)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(teal.opacity(0.12)))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)

            if !isLast {
                Rectangle()
                    .fill(Color.white.opacity(0.07))
                    .frame(height: 1)
                    .padding(.leading, 54)
            }
        }
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    func logoMark(size: CGFloat, radius: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.white)
                .frame(width: size, height: size)
                .shadow(color: teal.opacity(0.30), radius: 4, x: 0, y: 2)
            Image(systemName: "house.fill")
                .font(.system(size: size * 0.46, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [darkGreen, teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }

    func emptyState(iconSize: CGFloat, fontSize: CGFloat) -> some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                Image(systemName: "location.slash.fill")
                    .font(.system(size: iconSize))
                    .foregroundColor(.white.opacity(0.25))
                Text("No rentals nearby")
                    .font(.system(size: fontSize))
                    .foregroundColor(.white.opacity(0.35))
            }
            Spacer()
        }
    }
}

// MARK: - Widget

struct NearbyItemsWidget: Widget {
    let kind: String = "NearbyItemsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NearbyItemsProvider()) { entry in
            NearbyItemsWidgetEntryView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        colors: [darkGreen, mid, deepDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    for: .widget
                )
        }
        .configurationDisplayName("Nearby Rentals")
        .description("See what's available to rent near you.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Previews

#Preview("Medium", as: .systemMedium) {
    NearbyItemsWidget()
} timeline: {
    NearbyItemsEntry(
        date: .now,
        items: [
            NearbyRentalItem(name: "Weight Machine", distance: "2 km",   icon: "fitness"),
            NearbyRentalItem(name: "DSLR Camera",    distance: "1.5 km", icon: "camera"),
            NearbyRentalItem(name: "Ladder",         distance: "800 m",  icon: "construction"),
            NearbyRentalItem(name: "Drill Machine",  distance: "1.2 km", icon: "build"),
        ],
        lastUpdated: "Just now"
    )
}

#Preview("Small", as: .systemSmall) {
    NearbyItemsWidget()
} timeline: {
    NearbyItemsEntry(
        date: .now,
        items: [
            NearbyRentalItem(name: "Weight Machine", distance: "2 km",   icon: "fitness"),
            NearbyRentalItem(name: "DSLR Camera",    distance: "1.5 km", icon: "camera"),
            NearbyRentalItem(name: "Ladder",         distance: "800 m",  icon: "construction"),
        ],
        lastUpdated: nil
    )
}
