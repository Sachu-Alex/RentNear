import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Helpers

private extension String {
    var statusIcon: String {
        switch self {
        case _ where contains("Confirmed"):  return "✅"
        case _ where contains("Preparing"):  return "🍳"
        case _ where contains("Out for"):    return "🚴"
        case _ where contains("Arriving"):   return "📍"
        case _ where contains("Delivered"):  return "🎉"
        default:                             return "📦"
        }
    }
}

// MARK: - Live Activity Widget

struct OrderTrackingLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderTrackingAttributes.self) { context in

            // ── Lock Screen / Notification Banner ────────────────────────────
            LockScreenView(
                orderId: context.attributes.orderId,
                state: context.state
            )

        } dynamicIsland: { context in
            DynamicIsland {

                // ── Expanded ─────────────────────────────────────────────────
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 6) {
                        Text(context.state.status.statusIcon)
                            .font(.system(size: 28))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(context.state.status)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            Text("Order #\(context.attributes.orderId)")
                                .font(.system(size: 11))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.leading, 4)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        if context.state.eta > 0 {
                            Text("\(context.state.eta)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Color(hex: "#00C896"))
                            Text("min")
                                .font(.system(size: 11))
                                .foregroundStyle(.gray)
                        } else {
                            Text("🎉")
                                .font(.system(size: 26))
                        }
                    }
                    .padding(.trailing, 4)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    ProgressDotsView(status: context.state.status)
                        .padding(.bottom, 6)
                }

            } compactLeading: {

                // ── Compact Leading ───────────────────────────────────────────
                Text(context.state.status.statusIcon)
                    .font(.system(size: 16))

            } compactTrailing: {

                // ── Compact Trailing ──────────────────────────────────────────
                if context.state.eta > 0 {
                    Text("\(context.state.eta)m")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(hex: "#00C896"))
                } else {
                    Text("✓")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(hex: "#00C896"))
                }

            } minimal: {

                // ── Minimal ───────────────────────────────────────────────────
                Text(context.state.status.statusIcon)
                    .font(.system(size: 14))
            }
            .keylineTint(Color(hex: "#00C896"))
        }
    }
}

// MARK: - Lock Screen View

private struct LockScreenView: View {
    let orderId: String
    let state: OrderTrackingAttributes.ContentState

    var body: some View {
        HStack(spacing: 14) {
            // Status icon badge
            ZStack {
                Circle()
                    .fill(Color(hex: "#00C896").opacity(0.15))
                    .frame(width: 52, height: 52)
                Text(state.status.statusIcon)
                    .font(.system(size: 26))
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(state.status)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)

                HStack(spacing: 6) {
                    Text("Order #\(orderId)")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                    Text("•")
                        .foregroundStyle(.gray)
                    if state.eta > 0 {
                        Text("ETA \(state.eta) min")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color(hex: "#00C896"))
                    } else {
                        Text("Delivered!")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color(hex: "#00C896"))
                    }
                }
            }

            Spacer()

            // ETA badge
            if state.eta > 0 {
                VStack(spacing: 0) {
                    Text("\(state.eta)")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(Color(hex: "#00C896"))
                    Text("MIN")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 4)
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Progress Dots

private struct ProgressDotsView: View {
    let status: String

    private let steps = ["Confirmed", "Preparing", "Out for Delivery", "Arriving", "Delivered"]

    private var currentIndex: Int {
        switch status {
        case _ where status.contains("Confirmed"):  return 0
        case _ where status.contains("Preparing"):  return 1
        case _ where status.contains("Out for"):    return 2
        case _ where status.contains("Arriving"):   return 3
        case _ where status.contains("Delivered"):  return 4
        default:                                     return 0
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<steps.count, id: \.self) { i in
                Capsule()
                    .fill(i <= currentIndex
                          ? Color(hex: "#00C896")
                          : Color.white.opacity(0.2))
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, 8)
    }
}

// MARK: - Color Hex Helper

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
