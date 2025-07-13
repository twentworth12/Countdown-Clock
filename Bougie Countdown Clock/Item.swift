//
//  Item.swift
//  Bougie Countdown Clock
//
//  Created by Tom Wentworth on 7/13/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
