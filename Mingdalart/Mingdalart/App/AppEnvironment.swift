//
//  AppEnvironment.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/22/26.
//

import Foundation
import SwiftData

final class AppEnvironment {
    let mandalRepository: MandalaRepository
    let mandalUseCase: MandalaUseCase
    let dailyTaskRepository: DailyTaskRepository
    let dailyTaskUseCase: DailyTaskUseCase
    
    init(
        mandalRepository: MandalaRepository,
        mandalUseCase: MandalaUseCase,
        dailyTaskRepository: DailyTaskRepository,
        dailyTaskUseCase: DailyTaskUseCase
    ) {
        self.mandalRepository = mandalRepository
        self.mandalUseCase = mandalUseCase
        self.dailyTaskRepository = dailyTaskRepository
        self.dailyTaskUseCase = dailyTaskUseCase
    }
    
    static func live(modelContext: ModelContext) -> AppEnvironment {
        // Repository
        let mandalRepository = SwiftDataMandalaRepository(context: modelContext)
        let dailyTaskRepository = SwiftDataDailyTaskRepository(context: modelContext)
        
        // UseCase
        let mandalUseCase = MandalaUseCase(repository: mandalRepository)
        let dailyTaskUseCase = DailyTaskUseCase(repository: dailyTaskRepository)
        
        return AppEnvironment(
            mandalRepository: mandalRepository,
            mandalUseCase: mandalUseCase,
            dailyTaskRepository: dailyTaskRepository,
            dailyTaskUseCase: dailyTaskUseCase
        )
    }
}
