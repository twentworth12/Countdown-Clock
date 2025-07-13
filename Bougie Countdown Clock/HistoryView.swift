//
//  HistoryView.swift
//  Bougie Countdown Clock
//
//  Created by Tom Wentworth on 7/13/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ConversationSession.startTime, order: .reverse) private var sessions: [ConversationSession]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sessions) { session in
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        SessionRowView(session: session)
                    }
                }
                .onDelete(perform: deleteSessions)
            }
            .navigationTitle("Conversation History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func deleteSessions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(sessions[index])
            }
        }
    }
}

struct SessionRowView: View {
    let session: ConversationSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.startTime, format: .dateTime.month().day().hour().minute())
                    .font(.headline)
                
                Spacer()
                
                if session.isComplete {
                    Text("✅ Complete")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("⏸️ Incomplete")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            if let totalDuration = session.totalDuration {
                Text("Total: \(formatTime(totalDuration))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 8) {
                HStack(spacing: 15) {
                    PhraseStatusView(emoji: "💎", time: session.necklaceDuration)
                    PhraseStatusView(emoji: "🏠", time: session.houseDuration)
                    PhraseStatusView(emoji: "💰", time: session.moneyDuration)
                }
                
                HStack(spacing: 15) {
                    PhraseStatusView(emoji: "🛥️", time: session.boatDuration)
                    PhraseStatusView(emoji: "🧘‍♀️", time: session.wellnessInfluencerDuration)
                    PhraseStatusView(emoji: "✈️", time: session.firstClassDuration)
                }
            }
        }
        .padding(.vertical, 2)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct PhraseStatusView: View {
    let emoji: String
    let time: TimeInterval?
    
    var body: some View {
        HStack(spacing: 2) {
            Text(emoji)
                .font(.caption)
            if let time = time {
                Text(formatTime(time))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                Text("--:--")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct SessionDetailView: View {
    let session: ConversationSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Session Details")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Started: \(session.startTime, format: .dateTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let endTime = session.endTime {
                    Text("Ended: \(endTime, format: .dateTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            if let totalDuration = session.totalDuration {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Duration")
                        .font(.headline)
                    
                    Text(formatDetailedTime(totalDuration))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Phrase Timing")
                    .font(.headline)
                
                PhraseDetailView(emoji: "💎", label: "Necklace", time: session.necklaceDuration)
                PhraseDetailView(emoji: "🏠", label: "Vacation House", time: session.houseDuration)
                PhraseDetailView(emoji: "💰", label: "Money", time: session.moneyDuration)
                PhraseDetailView(emoji: "🛥️", label: "Boat", time: session.boatDuration)
                PhraseDetailView(emoji: "🧘‍♀️", label: "Wellness Influencer", time: session.wellnessInfluencerDuration)
                PhraseDetailView(emoji: "✈️", label: "First Class", time: session.firstClassDuration)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Session Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDetailedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

struct PhraseDetailView: View {
    let emoji: String
    let label: String
    let time: TimeInterval?
    
    var body: some View {
        HStack {
            Text(emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let time = time {
                    Text(formatDetailedTime(time))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Not mentioned")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func formatDetailedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: ConversationSession.self, inMemory: true)
}