//
//  SwiftDataMandalaRepository.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataMandalaRepository: MandalaRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - MandalaRepository

    func fetchBoard() -> MandalaBoard? {
        let descriptor = FetchDescriptor<MandalaBoardEntity>()
        guard let entity = (try? context.fetch(descriptor))?.first else { return nil }
        return toDomain(entity)
    }

    func saveBoard(_ board: MandalaBoard) {
        let entity = fetchOrCreateBoardEntity()
        update(entity, with: board)
        try? context.save()
    }

    func saveCell(_ cell: MandalaCell) {
        let boardEntity = fetchOrCreateBoardEntity()
        if let existing = boardEntity.cells.first(where: { $0.index == cell.index }) {
            existing.text = cell.text
            existing.role = cell.role
        } else {
            let newCell = MandalaCellEntity(
                index: cell.index,
                text: cell.text,
                role: cell.role,
                board: boardEntity
            )
            boardEntity.cells.append(newCell)
        }
        try? context.save()
    }

    private func fetchOrCreateBoardEntity() -> MandalaBoardEntity {
        let descriptor = FetchDescriptor<MandalaBoardEntity>()
        if let entity = (try? context.fetch(descriptor))?.first {
            return entity
        }
        let entity = MandalaBoardEntity(title: "만다라트 #1")
        context.insert(entity)
        return entity
    }

    private func update(_ entity: MandalaBoardEntity, with board: MandalaBoard) {
        entity.title = board.title

        var existingByIndex: [Int: MandalaCellEntity] = [:]
        for cell in entity.cells {
            existingByIndex[cell.index] = cell
        }

        var updatedCells: [MandalaCellEntity] = []
        updatedCells.reserveCapacity(board.cells.count)

        for cell in board.cells {
            if let existing = existingByIndex[cell.index] {
                existing.text = cell.text
                existing.role = cell.role
                updatedCells.append(existing)
            } else {
                let newCell = MandalaCellEntity(
                    index: cell.index,
                    text: cell.text,
                    role: cell.role,
                    board: entity
                )
                updatedCells.append(newCell)
            }
        }

        entity.cells = updatedCells
    }
}

// MARK: - Mapping

extension SwiftDataMandalaRepository {
    private func toDomain(_ entity: MandalaBoardEntity) -> MandalaBoard {
        let cells = entity.cells.map { cell in
            MandalaCell(index: cell.index, text: cell.text, role: cell.role)
        }
        return MandalaBoard(title: entity.title, cells: cells)
    }
}
