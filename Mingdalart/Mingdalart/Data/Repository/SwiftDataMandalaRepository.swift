//
//  MandalaDataSource.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

public actor MandalaDataSource {
    
    static func ensureDefaultBoard(in context: ModelContext) {
        let descriptor = FetchDescriptor<MandalaBoardEntity>()
        let existing = (try? context.fetch(descriptor)) ?? []
        if existing.isEmpty {
            // 최초 실행 시 기본 보드를 하나 만든다.
            let board = makeDefaultBoard(title: "만다라트 #1")
            context.insert(board)
            try? context.save()
            return
        }

        if let board = existing.first {
            // 기존 보드가 있어도 역할 규칙을 최신 상태로 맞춘다.
            normalizeRoles(for: board, in: context)
        }
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
    
    
    static func normalizeRoles(for board: MandalaBoardEntity, in context: ModelContext) {
        var changed = false
        // 인덱스 규칙을 기준으로 역할이 맞는지 재정렬한다.
        for cell in board.cells {
            let desired = roleForIndex(cell.index)
            if cell.role != desired {
                cell.role = desired
                changed = true
            }
        }
        if changed {
            try? context.save()
        }
    }
}
