//
//  UpdateCellTextUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/22/26.
//

import Foundation

@MainActor
struct UpdateCellTextUseCase {
    private let repository: MandalaRepository
    
    init(repository: MandalaRepository) {
        self.repository = repository
    }
    
    func execute(board: MandalaBoard, index: Int, text: String) -> MandalaBoard {
        var updatedBoard = board
        guard let cellIndex = updatedBoard.cells.firstIndex(where: { $0.index == index }) else {
            return updatedBoard
        }
        updatedBoard.cells[cellIndex].text = text
        syncSubGoalText(in: &updatedBoard, sourceIndex: index)
        repository.saveBoard(updatedBoard)
        return updatedBoard
    }
    
    private func syncSubGoalText(in board: inout MandalaBoard, sourceIndex: Int) {
        let targetIndex = MandalaRule.subGoalMirrorMap[sourceIndex]
            ?? MandalaRule.subGoalReverseMap[sourceIndex]
        guard let targetIndex,
              let sourceCellIndex = board.cells.firstIndex(where: { $0.index == sourceIndex }),
              let targetCellIndex = board.cells.firstIndex(where: { $0.index == targetIndex })
        else { return }
        board.cells[targetCellIndex].text = board.cells[sourceCellIndex].text
    }
}
