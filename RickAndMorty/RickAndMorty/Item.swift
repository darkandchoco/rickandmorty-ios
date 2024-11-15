//
//  Item.swift
//  RickAndMorty
//
//  Created by Richmond Ko on 2024-11-15.
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
