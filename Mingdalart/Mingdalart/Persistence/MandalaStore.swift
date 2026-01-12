//
//  MandalaStore.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import Foundation
import SwiftData

enum MandalaStore {
    static let gridCount = 9
    static let cellCount = 81

    @MainActor
    static func ensureDefaultBoard(in context: ModelContext) {
        let descriptor = FetchDescriptor<MandalaBoardEntity>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        let board = makeDefaultBoard(title: "만다라트 #1")
        context.insert(board)
        try? context.save()
    }

    static func makeDefaultBoard(title: String) -> MandalaBoardEntity {
        let board = MandalaBoardEntity(title: title)
        let cells = (0..<cellCount).map { index -> MandalaCellEntity in
            let role = roleForIndex(index)
            return MandalaCellEntity(index: index, role: role, board: board)
        }
        board.cells = cells
        return board
    }

    static func roleForIndex(_ index: Int) -> MandalaRole {
        guard index >= 0 && index < cellCount else { return .task }
        // Main goal sits in the exact center of the 9x9 board.
        if index == 40 { return .main }

        let row = index / gridCount
        let col = index % gridCount
        let centers = [1, 4, 7]
        // 3x3 block centers become sub-goals.
        if centers.contains(row) && centers.contains(col) {
            return .subGoal
        }
        return .task
    }
}
