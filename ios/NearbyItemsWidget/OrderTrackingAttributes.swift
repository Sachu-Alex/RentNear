import Foundation
import ActivityKit

// Shared model — identical copy must exist in the Runner (app) target.

struct OrderTrackingAttributes: ActivityAttributes {
    public let orderId: String

    public struct ContentState: Codable, Hashable {
        var status: String
        var eta: Int        // minutes remaining; 0 = delivered
    }
}
