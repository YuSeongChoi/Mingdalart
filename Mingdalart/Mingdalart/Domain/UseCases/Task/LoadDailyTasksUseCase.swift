//
//  LoadDailyTasksUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/29/26.
//

import Foundation

@MainActor
struct LoadDailyTasksUseCase {
    private let repository: DailyTaskRepository
    
    init(repository: DailyTaskRepository) {
        self.repository = repository
    }
    
    func execute() -> [DailyTask] {
        repository.fetchTasks()
    }
}
