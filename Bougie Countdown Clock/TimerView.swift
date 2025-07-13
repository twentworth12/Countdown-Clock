//
//  TimerView.swift
//  Bougie Countdown Clock
//
//  Created by Tom Wentworth on 7/13/25.
//

import SwiftUI
import SwiftData

struct TimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allSessions: [ConversationSession]
    @State private var currentSession: ConversationSession?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showingNewRecord = false
    @State private var newRecordMessage = ""
    
    var body: some View {
        VStack(spacing: 40) {
            
            // Timer Display
            VStack(spacing: 20) {
                Text("Bougie Countdown Clock")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(formatTime(elapsedTime))
                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
            }
            
            // Records Display
            if currentSession == nil {
                VStack(spacing: 10) {
                    Text("🏆 All-Time Records")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            RecordView(emoji: "💎", label: "Necklace", time: fastestNecklaceTime)
                            RecordView(emoji: "🏠", label: "Vacation House", time: fastestHouseTime)
                            RecordView(emoji: "💰", label: "Money", time: fastestMoneyTime)
                        }
                        
                        HStack(spacing: 20) {
                            RecordView(emoji: "🛥️", label: "Boat", time: fastestBoatTime)
                            RecordView(emoji: "🧘‍♀️", label: "Wellness", time: fastestWellnessInfluencerTime)
                            RecordView(emoji: "✈️", label: "First Class", time: fastestFirstClassTime)
                        }
                    }
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(15)
            }
            
            // Start/Stop Button
            Button(action: toggleTimer) {
                ZStack {
                    Circle()
                        .fill(buttonColor)
                        .frame(width: 200, height: 200)
                    
                    Text(buttonText)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Phrase Buttons
            if currentSession != nil {
                VStack(spacing: 20) {
                    Text("Tap when phrase is mentioned:")
                        .font(.headline)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            PhraseButton(
                                emoji: "💎",
                                label: "Necklace",
                                isPressed: currentSession?.necklaceTime != nil,
                                timeStamp: currentSession?.necklaceDuration != nil ? formatTime(currentSession!.necklaceDuration!) : nil,
                                isRecord: isNecklaceRecord(),
                                action: { recordNecklace() }
                            )
                            
                            PhraseButton(
                                emoji: "🏠",
                                label: "Vacation House",
                                isPressed: currentSession?.houseTime != nil,
                                timeStamp: currentSession?.houseDuration != nil ? formatTime(currentSession!.houseDuration!) : nil,
                                isRecord: isHouseRecord(),
                                action: { recordHouse() }
                            )
                            
                            PhraseButton(
                                emoji: "💰",
                                label: "Money",
                                isPressed: currentSession?.moneyTime != nil,
                                timeStamp: currentSession?.moneyDuration != nil ? formatTime(currentSession!.moneyDuration!) : nil,
                                isRecord: isMoneyRecord(),
                                action: { recordMoney() }
                            )
                        }
                        
                        HStack(spacing: 20) {
                            PhraseButton(
                                emoji: "🛥️",
                                label: "Boat",
                                isPressed: currentSession?.boatTime != nil,
                                timeStamp: currentSession?.boatDuration != nil ? formatTime(currentSession!.boatDuration!) : nil,
                                isRecord: isBoatRecord(),
                                action: { recordBoat() }
                            )
                            
                            PhraseButton(
                                emoji: "🧘‍♀️",
                                label: "Wellness",
                                isPressed: currentSession?.wellnessInfluencerTime != nil,
                                timeStamp: currentSession?.wellnessInfluencerDuration != nil ? formatTime(currentSession!.wellnessInfluencerDuration!) : nil,
                                isRecord: isWellnessInfluencerRecord(),
                                action: { recordWellnessInfluencer() }
                            )
                            
                            PhraseButton(
                                emoji: "✈️",
                                label: "First Class",
                                isPressed: currentSession?.firstClassTime != nil,
                                timeStamp: currentSession?.firstClassDuration != nil ? formatTime(currentSession!.firstClassDuration!) : nil,
                                isRecord: isFirstClassRecord(),
                                action: { recordFirstClass() }
                            )
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            
            // Completion Status
            if let session = currentSession, session.isComplete {
                VStack(spacing: 10) {
                    Text("🎉 All 6 phrases mentioned!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Total time: \(formatTime(session.totalDuration ?? 0))")
                        .font(.headline)
                    
                    Text("Press START to begin new session")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(15)
            }
            
            Spacer()
        }
        .padding()
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            if currentSession != nil && !currentSession!.isComplete {
                elapsedTime = Date().timeIntervalSince(currentSession!.startTime)
            }
        }
        .alert("🎉 NEW RECORD!", isPresented: $showingNewRecord) {
            Button("Awesome!") { }
        } message: {
            Text(newRecordMessage)
        }
    }
    
    // Computed properties for fastest times
    private var fastestNecklaceTime: TimeInterval? {
        return allSessions.compactMap { $0.necklaceDuration }.min()
    }
    
    private var fastestHouseTime: TimeInterval? {
        return allSessions.compactMap { $0.houseDuration }.min()
    }
    
    private var fastestMoneyTime: TimeInterval? {
        return allSessions.compactMap { $0.moneyDuration }.min()
    }
    
    private var fastestBoatTime: TimeInterval? {
        return allSessions.compactMap { $0.boatDuration }.min()
    }
    
    private var fastestWellnessInfluencerTime: TimeInterval? {
        return allSessions.compactMap { $0.wellnessInfluencerDuration }.min()
    }
    
    private var fastestFirstClassTime: TimeInterval? {
        return allSessions.compactMap { $0.firstClassDuration }.min()
    }
    
    private func isNewRecord(currentTime: TimeInterval, previousBest: TimeInterval?) -> Bool {
        guard let previousBest = previousBest else { return true }
        return currentTime < previousBest
    }
    
    // Helper functions to check if current session times are records
    private func isNecklaceRecord() -> Bool {
        guard let currentTime = currentSession?.necklaceDuration else { return false }
        let previousBest = allSessions.filter { $0 != currentSession }.compactMap { $0.necklaceDuration }.min()
        return isNewRecord(currentTime: currentTime, previousBest: previousBest)
    }
    
    private func isHouseRecord() -> Bool {
        guard let currentTime = currentSession?.houseDuration else { return false }
        let previousBest = allSessions.filter { $0 != currentSession }.compactMap { $0.houseDuration }.min()
        return isNewRecord(currentTime: currentTime, previousBest: previousBest)
    }
    
    private func isMoneyRecord() -> Bool {
        guard let currentTime = currentSession?.moneyDuration else { return false }
        let previousBest = allSessions.filter { $0 != currentSession }.compactMap { $0.moneyDuration }.min()
        return isNewRecord(currentTime: currentTime, previousBest: previousBest)
    }
    
    private func isBoatRecord() -> Bool {
        guard let currentTime = currentSession?.boatDuration else { return false }
        let previousBest = allSessions.filter { $0 != currentSession }.compactMap { $0.boatDuration }.min()
        return isNewRecord(currentTime: currentTime, previousBest: previousBest)
    }
    
    private func isWellnessInfluencerRecord() -> Bool {
        guard let currentTime = currentSession?.wellnessInfluencerDuration else { return false }
        let previousBest = allSessions.filter { $0 != currentSession }.compactMap { $0.wellnessInfluencerDuration }.min()
        return isNewRecord(currentTime: currentTime, previousBest: previousBest)
    }
    
    private func isFirstClassRecord() -> Bool {
        guard let currentTime = currentSession?.firstClassDuration else { return false }
        let previousBest = allSessions.filter { $0 != currentSession }.compactMap { $0.firstClassDuration }.min()
        return isNewRecord(currentTime: currentTime, previousBest: previousBest)
    }
    
    // Button appearance computed properties
    private var buttonColor: Color {
        if currentSession == nil || currentSession?.isComplete == true {
            return .green
        } else {
            return .red
        }
    }
    
    private var buttonText: String {
        if currentSession == nil || currentSession?.isComplete == true {
            return "START"
        } else {
            return "STOP"
        }
    }
    
    private func toggleTimer() {
        if currentSession == nil || currentSession?.isComplete == true {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        // If there's a completed session, clear it for a fresh start
        if currentSession?.isComplete == true {
            currentSession = nil
        }
        
        let session = ConversationSession(startTime: Date())
        modelContext.insert(session)
        currentSession = session
        elapsedTime = 0
    }
    
    private func stopTimer() {
        currentSession?.endTime = Date()
        try? modelContext.save()
        currentSession = nil
        elapsedTime = 0
    }
    
    private func recordNecklace() {
        guard let session = currentSession, session.necklaceTime == nil else { return }
        session.necklaceTime = Date()
        try? modelContext.save()
        
        // Check for new record
        if let duration = session.necklaceDuration {
            if isNewRecord(currentTime: duration, previousBest: fastestNecklaceTime) {
                showNewRecordAlert(phrase: "Necklace", time: duration)
            }
        }
        
        checkCompletion()
    }
    
    private func recordHouse() {
        guard let session = currentSession, session.houseTime == nil else { return }
        session.houseTime = Date()
        try? modelContext.save()
        
        // Check for new record
        if let duration = session.houseDuration {
            if isNewRecord(currentTime: duration, previousBest: fastestHouseTime) {
                showNewRecordAlert(phrase: "Vacation House", time: duration)
            }
        }
        
        checkCompletion()
    }
    
    private func recordMoney() {
        guard let session = currentSession, session.moneyTime == nil else { return }
        session.moneyTime = Date()
        try? modelContext.save()
        
        // Check for new record
        if let duration = session.moneyDuration {
            if isNewRecord(currentTime: duration, previousBest: fastestMoneyTime) {
                showNewRecordAlert(phrase: "Money", time: duration)
            }
        }
        
        checkCompletion()
    }
    
    private func recordBoat() {
        guard let session = currentSession, session.boatTime == nil else { return }
        session.boatTime = Date()
        try? modelContext.save()
        
        // Check for new record
        if let duration = session.boatDuration {
            if isNewRecord(currentTime: duration, previousBest: fastestBoatTime) {
                showNewRecordAlert(phrase: "Boat", time: duration)
            }
        }
        
        checkCompletion()
    }
    
    private func recordWellnessInfluencer() {
        guard let session = currentSession, session.wellnessInfluencerTime == nil else { return }
        session.wellnessInfluencerTime = Date()
        try? modelContext.save()
        
        // Check for new record
        if let duration = session.wellnessInfluencerDuration {
            if isNewRecord(currentTime: duration, previousBest: fastestWellnessInfluencerTime) {
                showNewRecordAlert(phrase: "Wellness Influencer", time: duration)
            }
        }
        
        checkCompletion()
    }
    
    private func recordFirstClass() {
        guard let session = currentSession, session.firstClassTime == nil else { return }
        session.firstClassTime = Date()
        try? modelContext.save()
        
        // Check for new record
        if let duration = session.firstClassDuration {
            if isNewRecord(currentTime: duration, previousBest: fastestFirstClassTime) {
                showNewRecordAlert(phrase: "First Class", time: duration)
            }
        }
        
        checkCompletion()
    }
    
    private func showNewRecordAlert(phrase: String, time: TimeInterval) {
        newRecordMessage = "New \(phrase) record: \(formatTime(time))!"
        showingNewRecord = true
    }
    
    private func checkCompletion() {
        if currentSession?.isComplete == true {
            currentSession?.endTime = Date()
            try? modelContext.save()
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

struct PhraseButton: View {
    let emoji: String
    let label: String
    let isPressed: Bool
    let timeStamp: String?
    let isRecord: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    Text(emoji)
                        .font(.system(size: 40))
                    
                    if isRecord && isPressed {
                        VStack {
                            HStack {
                                Text("🏆")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(width: 60, height: 50)
                    }
                }
                
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                
                if let timeStamp = timeStamp {
                    HStack(spacing: 2) {
                        Text(timeStamp)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(isRecord ? .orange : .green)
                        
                        if isRecord {
                            Text("🏆")
                                .font(.caption2)
                        }
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(isRecord ? Color.orange.opacity(0.1) : Color.green.opacity(0.1))
                    .cornerRadius(4)
                }
            }
            .frame(width: 80, height: isPressed ? 110 : 80)
            .background(isPressed ? (isRecord ? Color.orange.opacity(0.3) : Color.green.opacity(0.3)) : Color.gray.opacity(0.1))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isPressed ? (isRecord ? Color.orange : Color.green) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isPressed)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
    }
}

struct RecordView: View {
    let emoji: String
    let label: String
    let time: TimeInterval?
    
    var body: some View {
        VStack(spacing: 4) {
            Text(emoji)
                .font(.title2)
            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
            
            if let time = time {
                Text(formatTime(time))
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
            } else {
                Text("--:--")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(minWidth: 60)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        let milliseconds = Int((timeInterval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

#Preview {
    TimerView()
        .modelContainer(for: ConversationSession.self, inMemory: true)
}