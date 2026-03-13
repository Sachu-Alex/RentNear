import Flutter
import UIKit
import ActivityKit

// MARK: - OrderTrackingAttributes
// Defines the static + dynamic data for the Live Activity.
// This struct must also exist in the Widget Extension target (OrderTrackingWidget).

@available(iOS 16.2, *)
struct OrderTrackingAttributes: ActivityAttributes {
    public let orderId: String

    public struct ContentState: Codable, Hashable {
        var status: String
        var eta: Int   // minutes remaining; 0 = delivered
    }
}

// MARK: - LiveActivityManager

@available(iOS 16.2, *)
private final class LiveActivityManager {

    private var currentActivity: Activity<OrderTrackingAttributes>?

    func startLiveActivity(orderId: String, status: String, eta: Int) -> Bool {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("[LiveActivity] Activities not enabled on this device")
            return false
        }
        endLiveActivity()   // clear any stale activity first

        let attributes  = OrderTrackingAttributes(orderId: orderId)
        let state       = OrderTrackingAttributes.ContentState(status: status, eta: eta)
        let staleDate   = Calendar.current.date(byAdding: .hour, value: 2, to: Date())

        do {
            currentActivity = try Activity<OrderTrackingAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: state, staleDate: staleDate),
                pushType: nil
            )
            print("[LiveActivity] Started: \(currentActivity!.id)")
            return true
        } catch {
            print("[LiveActivity] Start failed: \(error)")
            return false
        }
    }

    func updateLiveActivity(status: String, eta: Int) -> Bool {
        guard let activity = currentActivity else {
            print("[LiveActivity] No active activity to update")
            return false
        }
        let newState  = OrderTrackingAttributes.ContentState(status: status, eta: eta)
        let staleDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())

        Task {
            await activity.update(
                ActivityContent(state: newState, staleDate: staleDate)
            )
        }
        return true
    }

    @discardableResult
    func endLiveActivity() -> Bool {
        guard let activity = currentActivity else { return true }
        Task { await activity.end(nil, dismissalPolicy: .immediate) }
        currentActivity = nil
        return true
    }
}

// MARK: - AppDelegate

@main
@objc class AppDelegate: FlutterAppDelegate {

    // AnyObject? backing store avoids the "@available on stored property" error.
    private var _manager: AnyObject?

    @available(iOS 16.2, *)
    private var manager: LiveActivityManager {
        if let m = _manager as? LiveActivityManager { return m }
        let m = LiveActivityManager()
        _manager = m
        return m
    }

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        setupChannel()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func setupChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }

        let channel = FlutterMethodChannel(
            name: "com.example.rentProducts/liveActivity",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] call, result in
            guard let self else { return }

            guard #available(iOS 16.2, *) else {
                result(false)   // gracefully unsupported below 16.1
                return
            }

            switch call.method {

            case "startLiveActivity":
                guard
                    let args    = call.arguments as? [String: Any],
                    let orderId = args["orderId"] as? String,
                    let status  = args["status"]  as? String,
                    let eta     = args["eta"]     as? Int
                else {
                    result(FlutterError(code: "BAD_ARGS", message: "startLiveActivity: missing args", details: nil))
                    return
                }
                result(self.manager.startLiveActivity(orderId: orderId, status: status, eta: eta))

            case "updateLiveActivity":
                guard
                    let args   = call.arguments as? [String: Any],
                    let status = args["status"] as? String,
                    let eta    = args["eta"]    as? Int
                else {
                    result(FlutterError(code: "BAD_ARGS", message: "updateLiveActivity: missing args", details: nil))
                    return
                }
                result(self.manager.updateLiveActivity(status: status, eta: eta))

            case "endLiveActivity":
                result(self.manager.endLiveActivity())

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
