//
//  DeleteDailyTaskUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/29/26.
//

import Foundation

@MainActor
struct DeleteDailyTaskUseCase {
    private let repository: DailyTaskRepository
    
    init(repository: DailyTaskRepository) {
        self.repository = repository
    }
    
    func execute(_ task: DailyTask) {
        repository.deleteTask(task)
    }
}
