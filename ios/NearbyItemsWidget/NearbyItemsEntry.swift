import WidgetKit

struct NearbyRentalItem {
    let name: String
    let distance: String
    let icon: String
}

struct NearbyItemsEntry: TimelineEntry {
    let date: Date
    let items: [NearbyRentalItem]
    let lastUpdated: String?
}
