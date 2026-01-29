//
//  SaveCellUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/22/26.
//

import Foundation

@MainActor
struct SaveCellUseCase {
    private let repository: MandalaRepository
    
    init(repository: MandalaRepository) {
        self.repository = repository
    }
    
    func execute(_ cell: MandalaCell) {
        repository.saveCell(cell)
    }
}
