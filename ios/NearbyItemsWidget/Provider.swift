import WidgetKit
import SwiftUI

struct NearbyItemsProvider: TimelineProvider {
    private let appGroupId = "group.com.example.rentProducts"

    func placeholder(in context: Context) -> NearbyItemsEntry {
        NearbyItemsEntry(
            date: Date(),
            items: [
                NearbyRentalItem(name: "Weight Machine", distance: "2 km", icon: "fitness"),
                NearbyRentalItem(name: "DSLR Camera", distance: "1.5 km", icon: "camera"),
                NearbyRentalItem(name: "Ladder", distance: "800 m", icon: "construction"),
                NearbyRentalItem(name: "Drill Machine", distance: "1.2 km", icon: "build"),
            ],
            lastUpdated: nil
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (NearbyItemsEntry) -> Void) {
        let entry = readData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NearbyItemsEntry>) -> Void) {
        let entry = readData()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func readData() -> NearbyItemsEntry {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        let itemCount = userDefaults?.integer(forKey: "item_count") ?? 0

        var items: [NearbyRentalItem] = []

        if itemCount > 0 {
            for i in 0..<min(itemCount, 4) {
                let name = userDefaults?.string(forKey: "item_\(i)_name") ?? ""
                let distance = userDefaults?.string(forKey: "item_\(i)_distance") ?? ""
                let icon = userDefaults?.string(forKey: "item_\(i)_icon") ?? "build"
                items.append(NearbyRentalItem(name: name, distance: distance, icon: icon))
            }
        }

        let lastUpdated = userDefaults?.string(forKey: "last_updated")

        return NearbyItemsEntry(date: Date(), items: items, lastUpdated: lastUpdated)
    }
}
