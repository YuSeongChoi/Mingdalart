//
//  SwiftDataDailyTaskRepository.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/29/26.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataDailyTaskRepository: DailyTaskRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchTasks() -> [DailyTask] {
        let descriptor = FetchDescriptor<DailyTaskEntity>()
        let entities = (try? context.fetch(descriptor)) ?? []
        return entities.map {
            DailyTask(
                id: $0.id, title: $0.title,
                date: $0.date, isDone: $0.isDone,
                doneAt: $0.doneAt, createdAt: $0.createdAt
            )
        }
    }

    func saveTask(_ task: DailyTask) {
        let descriptor = FetchDescriptor<DailyTaskEntity>()
        let entities = (try? context.fetch(descriptor)) ?? []
        if let existing = entities.first(where: { $0.id == task.id }) {
            existing.title = task.title
            existing.date = task.date
            existing.isDone = task.isDone
            existing.doneAt = task.doneAt
            existing.createdAt = task.createdAt
        } else {
            let entity = DailyTaskEntity(
                id: task.id,
                title: task.title,
                date: task.date,
                isDone: task.isDone,
                doneAt: task.doneAt,
                createdAt: task.createdAt
            )
            context.insert(entity)
        }
        try? context.save()
    }

    func deleteTask(_ task: DailyTask) {
        let descriptor = FetchDescriptor<DailyTaskEntity>()
        let entities = (try? context.fetch(descriptor)) ?? []
        if let existing = entities.first(where: { $0.id == task.id }) {
            context.delete(existing)
            try? context.save()
        }
    }
}
