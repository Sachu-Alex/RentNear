import Foundation
import ActivityKit

// Shared between the main app and the Widget Extension.
// Must be in both targets (duplicate the file or use a shared framework).

@available(iOS 16.2, *)
struct OrderTrackingAttributes: ActivityAttributes {

    // Static data set once when the activity starts
    public let orderId: String

    // Dynamic data that can be updated while the activity is running
    public struct ContentState: Codable, Hashable {
        var status: String
        var eta: Int          // minutes remaining; 0 means delivered
    }
}
