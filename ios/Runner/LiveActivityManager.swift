import Foundation
import ActivityKit

@available(iOS 16.1, *)
class LiveActivityManager {

    // Keep a reference so we can update / end the same activity
    private var currentActivity: Activity<OrderTrackingAttributes>?

    // MARK: - Start

    func startLiveActivity(orderId: String, status: String, eta: Int) -> Bool {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("LiveActivities not enabled on this device/account")
            return false
        }

        // End any previous activity first
        endLiveActivity()

        let attributes = OrderTrackingAttributes(orderId: orderId)
        let contentState = OrderTrackingAttributes.ContentState(status: status, eta: eta)

        do {
            let activity = try Activity<OrderTrackingAttributes>.request(
                attributes: attributes,
                content: ActivityContent(
                    state: contentState,
                    staleDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())
                ),
                pushType: nil   // nil = local updates only (no push token needed)
            )
            currentActivity = activity
            print("LiveActivity started: \(activity.id)")
            return true
        } catch {
            print("Failed to start LiveActivity: \(error)")
            return false
        }
    }

    // MARK: - Update

    func updateLiveActivity(status: String, eta: Int) -> Bool {
        guard let activity = currentActivity else {
            print("No active LiveActivity to update")
            return false
        }

        let newState = OrderTrackingAttributes.ContentState(status: status, eta: eta)

        Task {
            await activity.update(
                ActivityContent(
                    state: newState,
                    staleDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date())
                )
            )
        }
        return true
    }

    // MARK: - End

    @discardableResult
    func endLiveActivity() -> Bool {
        guard let activity = currentActivity else { return true }

        Task {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        currentActivity = nil
        return true
    }
}
