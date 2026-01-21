//
//  MandalaUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

@MainActor
struct MandalaUseCase {
    private let repository: MandalaRepository

    init(repository: MandalaRepository) {
        self.repository = repository
    }

    func loadBoard() -> MandalaBoard {
        if let board = repository.fetchBoard() {
            let normalized = normalizeRoles(in: board)
            repository.saveBoard(normalized)
            return normalized
        }

        let board = makeDefaultBoard(title: "만다라트 #1")
        repository.saveBoard(board)
        return board
    }

    func updateCellText(board: MandalaBoard, index: Int, text: String) -> MandalaBoard {
        var updatedBoard = board
        guard let cellIndex = updatedBoard.cells.firstIndex(where: { $0.index == index }) else {
            return updatedBoard
        }
        updatedBoard.cells[cellIndex].text = text
        syncSubGoalText(in: &updatedBoard, sourceIndex: index)
        repository.saveBoard(updatedBoard)
        return updatedBoard
    }

    func saveCell(_ cell: MandalaCell) {
        repository.saveCell(cell)
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
