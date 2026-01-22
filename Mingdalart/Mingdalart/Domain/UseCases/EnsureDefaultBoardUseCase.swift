//
//  EnsureDefaultBoardUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/22/26.
//

import Foundation

@MainActor
struct EnsureDefaultBoardUseCase {
    private let repository: MandalaRepository
    
    init(repository: MandalaRepository) {
        self.repository = repository
    }
    
    func execute() -> MandalaBoard {
        if let board = repository.fetchBoard() {
            let normalized = normalizeRoles(in: board)
            repository.saveBoard(normalized)
            return normalized
        }

        let board = makeDefaultBoard(title: "만다라트 #1")
        repository.saveBoard(board)
        return board
    }
    
    private func makeDefaultBoard(title: String) -> MandalaBoard {
        let cells = (0..<MandalaRule.cellCount).map { index in
            MandalaCell(index: index, text: "", role: MandalaRule.roleForIndex(index))
        }
        return MandalaBoard(title: title, cells: cells)
    }

    private func normalizeRoles(in board: MandalaBoard) -> MandalaBoard {
        var normalized = board
        for index in normalized.cells.indices {
            let role = MandalaRule.roleForIndex(normalized.cells[index].index)
            normalized.cells[index].role = role
        }
        return normalized
    }
}
