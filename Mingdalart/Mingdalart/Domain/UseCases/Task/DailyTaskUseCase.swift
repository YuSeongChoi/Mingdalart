//
//  DailyTaskUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/29/26.
//

import Foundation

@MainActor
struct DailyTaskUseCase {
    private let loadDailyTask: LoadDailyTasksUseCase
    private let saveDailyTask: SaveDailyTaskUseCase
    private let deleteDailyTask: DeleteDailyTaskUseCase
    
    init(repository: DailyTaskRepository) {
        self.loadDailyTask = LoadDailyTasksUseCase(repository: repository)
        self.saveDailyTask = SaveDailyTaskUseCase(repository: repository)
        self.deleteDailyTask = DeleteDailyTaskUseCase(repository: repository)
    }
    
    func fetchDailyTask() -> [DailyTask] {
        loadDailyTask.execute()
    }
    
    func saveDailyTask(_ task: DailyTask) {
        saveDailyTask.execute(task)
    }
    
    func updateTaskLink(taskId: UUID, linkedIndex: Int?) {
        // TODO: 현재는 saveDailyTask를 통해 갱신해도 되지만, 추후 따로 업데이트할때를 대비해 둔다.
    }
    
    func deleteDailyTask(_ task: DailyTask) {
        deleteDailyTask.execute(task)
    }
}
