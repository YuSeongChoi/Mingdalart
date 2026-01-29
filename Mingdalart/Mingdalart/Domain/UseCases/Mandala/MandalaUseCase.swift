//
//  MandalaUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

@MainActor
struct MandalaUseCase {
    private let ensureDefaultBoard: EnsureDefaultBoardUseCase
    private let updateCellText: UpdateCellTextUseCase
    private let saveCell: SaveCellUseCase
    private let calculateCompletionRate: CalculateCompletionRateUseCase
    
    init(repository: MandalaRepository) {
        self.ensureDefaultBoard = EnsureDefaultBoardUseCase(repository: repository)
        self.updateCellText = UpdateCellTextUseCase(repository: repository)
        self.saveCell = SaveCellUseCase(repository: repository)
        self.calculateCompletionRate = CalculateCompletionRateUseCase()
    }
    
    func loadBoard() -> MandalaBoard {
        ensureDefaultBoard.execute()
    }
    
    func updateCellText(board: MandalaBoard, index: Int, text: String, isDone: Bool? = nil) -> MandalaBoard {
        updateCellText.execute(board: board, index: index, text: text, isDone: isDone)
    }
    
    func saveCell(_ cell: MandalaCell) {
        saveCell.execute(cell)
    }
    
    func completionRate(board: MandalaBoard) -> Double {
        calculateCompletionRate.execute(board: board)
    }
}
