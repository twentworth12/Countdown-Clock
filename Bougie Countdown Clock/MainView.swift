//
//  MainView.swift
//  Bougie Countdown Clock
//
//  Created by Tom Wentworth on 7/13/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var sessions: [ConversationSession]
    
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: ConversationSession.self, inMemory: true)
}