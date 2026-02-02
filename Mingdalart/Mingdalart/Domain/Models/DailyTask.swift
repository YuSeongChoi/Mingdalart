//
//  DailyTask.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/28/26.
//

import Foundation

struct DailyTask: Identifiable, Hashable {
    let id: UUID
    var title: String
    var date: Date
    var isDone: Bool
    var doneAt: Date?
    let createdAt: Date
    var linkedMandalaCellIndex: Int?

    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        isDone: Bool = false,
        doneAt: Date? = nil,
        createdAt: Date = Date(),
        linkedMandalaCellIndex: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.isDone = isDone
        self.doneAt = doneAt
        self.createdAt = createdAt
        self.linkedMandalaCellIndex = linkedMandalaCellIndex
    }
}
