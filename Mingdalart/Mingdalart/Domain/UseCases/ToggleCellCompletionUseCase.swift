//
//  ToggleCellCompletionUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/26/26.
//

import Foundation

@MainActor
struct ToggleCellCompletionUseCase {
    private let repository: MandalaRepository
    
    init(repositry: MandalaRepository) {
        self.repository = repositry
    }
    
    func execute(board: MandalaBoard, index: Int) -> MandalaBoard {
        var updated = board
        guard let i = updated.cells.firstIndex(where: { $0.index == index }) else { return updated }
        
        updated.cells[i].isDone.toggle()
        updated.cells[i].doneAt = updated.cells[i].isDone ? Date() : nil
        
        repository.saveBoard(updated)
        return updated
    }
}
