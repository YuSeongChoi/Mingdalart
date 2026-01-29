//
//  DailyTaskEntity.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/29/26.
//

import Foundation
import SwiftData

@Model
final class DailyTaskEntity {
    var id: UUID
    var title: String
    var date: Date
    var isDone: Bool
    var doneAt: Date?
    var createdAt: Date
    
    init(
        id: UUID,
        title: String,
        date: Date,
        isDone: Bool,
        doneAt: Date? = nil,
        createdAt: Date
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.isDone = isDone
        self.doneAt = doneAt
        self.createdAt = createdAt
    }
}
