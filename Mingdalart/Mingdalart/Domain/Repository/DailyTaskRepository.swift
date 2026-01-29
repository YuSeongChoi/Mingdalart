//
//  DailyTaskRepository.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/29/26.
//

import Foundation

@MainActor
protocol DailyTaskRepository {
    func fetchTasks() -> [DailyTask]
    func saveTask(_ task: DailyTask)
    func deleteTask(_ task: DailyTask)
}
