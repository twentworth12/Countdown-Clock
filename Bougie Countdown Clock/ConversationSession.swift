//
//  ConversationSession.swift
//  Bougie Countdown Clock
//
//  Created by Tom Wentworth on 7/13/25.
//

import Foundation
import SwiftData

@Model
final class ConversationSession {
    var startTime: Date
    var endTime: Date?
    var necklaceTime: Date?
    var houseTime: Date?
    var moneyTime: Date?
    var boatTime: Date?
    var wellnessInfluencerTime: Date?
    var firstClassTime: Date?
    
    init(startTime: Date) {
        self.startTime = startTime
    }
    
    var isComplete: Bool {
        return necklaceTime != nil && houseTime != nil && moneyTime != nil && 
               boatTime != nil && wellnessInfluencerTime != nil && firstClassTime != nil
    }
    
    var totalDuration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
    
    var necklaceDuration: TimeInterval? {
        guard let necklaceTime = necklaceTime else { return nil }
        return necklaceTime.timeIntervalSince(startTime)
    }
    
    var houseDuration: TimeInterval? {
        guard let houseTime = houseTime else { return nil }
        return houseTime.timeIntervalSince(startTime)
    }
    
    var moneyDuration: TimeInterval? {
        guard let moneyTime = moneyTime else { return nil }
        return moneyTime.timeIntervalSince(startTime)
    }
    
    var boatDuration: TimeInterval? {
        guard let boatTime = boatTime else { return nil }
        return boatTime.timeIntervalSince(startTime)
    }
    
    var wellnessInfluencerDuration: TimeInterval? {
        guard let wellnessInfluencerTime = wellnessInfluencerTime else { return nil }
        return wellnessInfluencerTime.timeIntervalSince(startTime)
    }
    
    var firstClassDuration: TimeInterval? {
        guard let firstClassTime = firstClassTime else { return nil }
        return firstClassTime.timeIntervalSince(startTime)
    }
}