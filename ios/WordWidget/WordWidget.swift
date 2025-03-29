//
//  WordWidget.swift
//  WordWidget
//
//  Created by Mehmet Güler on 29.03.2025.
//

import WidgetKit
import SwiftUI

struct WordWidget: Widget {
    let kind: String = "WordWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WordProvider()) { entry in
            WordWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Word Widget")
        .description("Shows a random word and meaning.")
    }
}

struct WordProvider: TimelineProvider {
    func placeholder(in context: Context) -> WordEntry {
        WordEntry(date: Date(), word: "Kelime", meaning: "Anlam")
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> Void) {
        let entry = WordEntry(date: Date(), word: "Snapshot", meaning: "Snapshot Meaning")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> Void) {
        // 1) Burada shared veriyi oku
        let userDefaults = UserDefaults(suiteName: "group.com.example.yds-words")
        let word = userDefaults?.string(forKey: "word_text") ?? "Kelime"
        let meaning = userDefaults?.string(forKey: "meaning_text") ?? "Anlam"

        // 2) Timeline Entry oluştur
        let entry = WordEntry(date: Date(), word: word, meaning: meaning)
        // 3) Yeni bir timeline ayarla (ör. 30 dk. sonra tekrar)
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct WordEntry: TimelineEntry {
    let date: Date
    let word: String
    let meaning: String
}

struct WordWidgetEntryView: View {
    var entry: WordEntry

    var body: some View {
        VStack {
            Text(entry.word)
                .font(.headline)
            Divider()
            Text(entry.meaning)
                .font(.subheadline)
        }
        .padding()
    }
}

#Preview(as: .systemSmall) {
    WordWidget()
} timeline: {
    WordEntry(date: Date(), word: "Kelime", meaning: "Anlam")
    WordEntry(date: Date(), word: "Kelime", meaning: "Anlam")
}
