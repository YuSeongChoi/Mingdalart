//
//  MandalaViewModel.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
final class MandalaViewModel {
    private let context: ModelContext
    var board: MandalaBoardEntity

    init(board: MandalaBoardEntity, context: ModelContext) {
        self.board = board
        self.context = context
    }

    var orderedCells: [MandalaCellEntity] {
        board.cells.sorted { $0.index < $1.index }
    }

    func cell(atRow row: Int, col: Int) -> MandalaCellEntity? {
        let idx = row * MandalaStore.gridCount + col
        return orderedCells.first { $0.index == idx }
    }

    func updateText(_ text: String, for cell: MandalaCellEntity) {
        cell.text = text
        try? context.save()
    }
}
