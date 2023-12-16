import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emojis: ["😀"])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emojis: ["😀"])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let entry = SimpleEntry(date: Date(), emojis: [Date().formatted()])
        entries.append(entry)

        // Accede a los valores almacenados en UserDefaults
        let userDefaults = UserDefaults(suiteName: "group.hiram.test23") // Reemplaza con tu suiteName
        if let storedEmojis = userDefaults?.array(forKey: "storedEmojis") as? [String] {
            // Genera una entrada para cada valor almacenado
            for emoji in storedEmojis {
                let entry = SimpleEntry(date: Date(), emojis: [emoji])
                entries.append(entry)
            }
        }

        // Configura la actualización del widget cada 5 minutos
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .second, value: 20, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emojis: [String]
}

struct HiramOmeTestEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Emojis:")
            ForEach(entry.emojis, id: \.self) { emoji in
                Text(emoji)
            }
        }
    }
}

struct HiramOmeTest: Widget {
    let kind: String = "HiramOmeTest"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HiramOmeTestEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                HiramOmeTestEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    HiramOmeTest()
} timeline: {
    SimpleEntry(date: .now, emojis: ["😀"])
    SimpleEntry(date: .now, emojis: ["🤩"])
}
