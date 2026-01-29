//
//  SaveDailyTaskUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/29/26.
//

import Foundation

@MainActor
struct SaveDailyTaskUseCase {
    private let repository: DailyTaskRepository
    
    init(repository: DailyTaskRepository) {
        self.repository = repository
    }
    
    func execute(_ task: DailyTask) {
        repository.saveTask(task)
    }
}
