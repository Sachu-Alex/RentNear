import SwiftUI
import WidgetKit

// Deployment target of this extension must be iOS 16.2+
// Set it in: Target → OrderTrackingWidget → Build Settings → iOS Deployment Target = 16.2

@main
struct OrderTrackingWidgetBundle: WidgetBundle {
    var body: some Widget {
        OrderTrackingLiveActivity()
    }
}
