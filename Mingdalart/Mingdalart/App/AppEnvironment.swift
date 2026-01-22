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
    
    init(mandalRepository: MandalaRepository, mandalUseCase: MandalaUseCase) {
        self.mandalRepository = mandalRepository
        self.mandalUseCase = mandalUseCase
    }
    
    static func live(modelContext: ModelContext) -> AppEnvironment {
        // Repository
        let mandalRepository = SwiftDataMandalaRepository(context: modelContext)
        
        // UseCase
        let mandalUseCase = MandalaUseCase(repository: mandalRepository)
        
        return AppEnvironment(
            mandalRepository: mandalRepository,
            mandalUseCase: mandalUseCase
        )
    }
}
