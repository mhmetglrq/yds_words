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
        .supportedFamilies([.systemSmall,.systemMedium,.systemLarge])
    }
}

struct WordProvider: TimelineProvider {
    func placeholder(in context: Context) -> WordEntry {
        WordEntry(date: Date(), word: "Kelime", meaning: "Anlam",wordType: "Fiil")
    }

    func getSnapshot(in context: Context, completion: @escaping (WordEntry) -> Void) {
        // Gerçek veriyi kullan
        let userDefaults = UserDefaults(suiteName: "group.com.example.yds-words")
        let word = userDefaults?.string(forKey: "word_text") ?? "Kelime"
        let meaning = userDefaults?.string(forKey: "meaning_text") ?? "Anlam"
        let wordType = userDefaults?.string(forKey: "word_type") ?? "Verb"
        
        let entry = WordEntry(date: Date(), word: word, meaning: meaning, wordType: wordType)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WordEntry>) -> Void) {
        // Veriyi oku
        let userDefaults = UserDefaults(suiteName: "group.com.example.yds-words")
        let word = userDefaults?.string(forKey: "word_text") ?? "Kelime"
        let meaning = userDefaults?.string(forKey: "meaning_text") ?? "Anlam"
        let wordType = userDefaults?.string(forKey: "word_type") ?? "Verb"

        print("Widget güncellendi: \(Date()) - Kelime: \(word)")  // Log ekle

        let currentDate = Date()
        let entry = WordEntry(date: currentDate, word: word, meaning: meaning, wordType: wordType)
        
        // 15 dakikada bir güncelle
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct WordEntry: TimelineEntry {
    let date: Date
    let word: String
    let meaning: String
    let wordType:String
}

struct WordWidgetEntryView: View {
    var entry: WordEntry

    var body: some View {
        ZStack {
            Color.purple
            HStack() {
                VStack {
                    VStack(spacing: 4) {
                        Text(entry.word)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)

                        Text(entry.wordType)
                            .font(.system(size: 14))
                            .italic()
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(height: 1)
                        .padding(.horizontal, 24)

                    Text(entry.meaning)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                }

                Spacer()
            }
        }
        .cornerRadius(12)
        .containerBackground(for: .widget) {
            Color.purple
        }
    }
}

struct WordWidget_Previews: PreviewProvider {
    static var previews: some View {
        WordWidgetEntryView(entry: WordEntry(date: Date(), word: "Snapshot", meaning: "Snapshot Meaning",wordType: "Noun"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
