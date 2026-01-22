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
    
    init(repository: MandalaRepository) {
        self.ensureDefaultBoard = EnsureDefaultBoardUseCase(repository: repository)
        self.updateCellText = UpdateCellTextUseCase(repository: repository)
        self.saveCell = SaveCellUseCase(repository: repository)
    }
    
    func loadBoard() -> MandalaBoard {
        ensureDefaultBoard.execute()
    }
    
    func updateCellText(board: MandalaBoard, index: Int, text: String) -> MandalaBoard {
        updateCellText.execute(board: board, index: index, text: text)
    }
    
    func saveCell(_ cell: MandalaCell) {
        saveCell.execute(cell)
    }
}
