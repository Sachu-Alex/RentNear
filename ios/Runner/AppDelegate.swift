import Flutter
import UIKit
import ActivityKit

// MARK: - OrderTrackingAttributes
// Shared model — identical copy must exist in the Widget Extension target.

@available(iOS 16.2, *)
struct OrderTrackingAttributes: ActivityAttributes {
    public let orderId: String

    public struct ContentState: Codable, Hashable {
        var status: String
        var eta: Int        // minutes remaining; 0 = delivered
    }
}

// MARK: - LiveActivityManager

@available(iOS 16.2, *)
private final class LiveActivityManager {

    private var currentActivity: Activity<OrderTrackingAttributes>?

    // ── Simulation ────────────────────────────────────────────────────────
    private var simulationTimer:   Timer?
    private var simulationIndex:   Int = 0
    private var backgroundTaskID:  UIBackgroundTaskIdentifier = .invalid

    /// Full dummy journey used by auto-simulation.
    private let simulationSteps: [(status: String, eta: Int)] = [
        ("Order Confirmed",   28),
        ("Preparing Item",    20),
        ("Out for Delivery",  12),
        ("Arriving Soon",      3),
        ("Delivered",          0),
    ]

    // MARK: Start

    func startLiveActivity(orderId: String, status: String, eta: Int) -> Bool {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("[LiveActivity] Activities not enabled on this device/account")
            return false
        }
        endLiveActivity()

        let attributes  = OrderTrackingAttributes(orderId: orderId)
        let state       = OrderTrackingAttributes.ContentState(status: status, eta: eta)
        let staleDate   = Calendar.current.date(byAdding: .hour, value: 2, to: Date())

        do {
            currentActivity = try Activity<OrderTrackingAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: state, staleDate: staleDate),
                pushType: nil   // local updates only — no APNs required
            )
            print("[LiveActivity] Started: \(currentActivity!.id)")
            return true
        } catch {
            print("[LiveActivity] Start failed: \(error)")
            return false
        }
    }

    // MARK: Update

    func updateLiveActivity(status: String, eta: Int) -> Bool {
        guard let activity = currentActivity else {
            print("[LiveActivity] No active activity to update")
            return false
        }
        let newState  = OrderTrackingAttributes.ContentState(status: status, eta: eta)
        let staleDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
        Task {
            await activity.update(ActivityContent(state: newState, staleDate: staleDate))
            print("[LiveActivity] Updated → \(status), ETA \(eta) min")
        }
        return true
    }

    // MARK: End

    @discardableResult
    func endLiveActivity() -> Bool {
        stopSimulation()
        guard let activity = currentActivity else { return true }
        Task { await activity.end(nil, dismissalPolicy: .immediate) }
        currentActivity = nil
        return true
    }

    // MARK: Background simulation

    /// Starts an 8-second repeating timer that walks through `simulationSteps`.
    /// `UIApplication.beginBackgroundTask` extends execution for ~30 s after
    /// the app is backgrounded — long enough for several Live Activity updates
    /// to fire even with the screen locked.
    func startSimulation() -> Bool {
        guard currentActivity != nil else {
            print("[LiveActivity] Cannot simulate: no active activity")
            return false
        }
        stopSimulation()        // cancel any in-progress run
        simulationIndex = 0     // restart journey from step 0

        // Reserve background execution time so the timer keeps firing
        // for approximately 30 seconds after the user backgrounds the app.
        backgroundTaskID = UIApplication.shared.beginBackgroundTask(
            withName: "OrderTrackingSimulation"
        ) { [weak self] in
            // Expiration handler — iOS is about to suspend; stop cleanly.
            self?.stopSimulation()
        }

        simulationTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }

            self.simulationIndex += 1

            guard self.simulationIndex < self.simulationSteps.count else {
                self.stopSimulation()
                return
            }

            let step = self.simulationSteps[self.simulationIndex]
            _ = self.updateLiveActivity(status: step.status, eta: step.eta)

            if step.eta == 0 { self.stopSimulation() }
        }

        print("[LiveActivity] Background simulation started (8 s interval)")
        return true
    }

    func stopSimulation() {
        simulationTimer?.invalidate()
        simulationTimer  = nil
        simulationIndex  = 0
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
        print("[LiveActivity] Simulation stopped")
    }
}

// MARK: - AppDelegate

@main
@objc class AppDelegate: FlutterAppDelegate {

    // AnyObject? backing store avoids "@available on stored property" error.
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

    // MARK: Method channel

    private func setupChannel() {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }

        let channel = FlutterMethodChannel(
            name: "com.example.rentProducts/liveActivity",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] call, result in
            guard let self else { return }

            guard #available(iOS 16.2, *) else {
                result(false)   // gracefully unsupported on older OS
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

            case "simulateBackgroundUpdates":
                result(self.manager.startSimulation())

            case "stopSimulation":
                self.manager.stopSimulation()
                result(true)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
