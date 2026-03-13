import Foundation
import ActivityKit

// This file is identical to ios/Runner/OrderTrackingAttributes.swift
// Both the app target and this Widget Extension target must include it.

@available(iOS 16.2, *)
struct OrderTrackingAttributes: ActivityAttributes {

    public let orderId: String

    public struct ContentState: Codable, Hashable {
        var status: String
        var eta: Int
    }
}
