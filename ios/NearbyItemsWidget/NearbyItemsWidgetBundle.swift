//
//  NearbyItemsWidgetBundle.swift
//  NearbyItemsWidget
//
//  Created by Sachu Alex on 13/03/26.
//

import WidgetKit
import SwiftUI

@main
struct NearbyItemsWidgetBundle: WidgetBundle {
    var body: some Widget {
        NearbyItemsWidget()
        NearbyItemsWidgetControl()
        OrderTrackingLiveActivity()
    }
}
