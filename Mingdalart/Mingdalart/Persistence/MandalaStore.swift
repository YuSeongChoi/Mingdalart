//
//  MandalaStore.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftData

enum MandalaStore {
    static let gridCount = 9
    static let cellCount = 81
    static let mainIndex = 40

    // 중앙 3x3의 subGoal을 바깥 3x3 중심으로 복사할 때의 매핑.
    static let subGoalMirrorMap: [Int: Int] = [
        30: 10, 31: 13, 32: 16,
        39: 37, 41: 43,
        48: 64, 49: 67, 50: 70
    ]
    static let subGoalReverseMap: [Int: Int] = [
        10: 30, 13: 31, 16: 32,
        37: 39, 43: 41,
        64: 48, 67: 49, 70: 50
    ]
    static let coreSubGoalIndices = Set(subGoalMirrorMap.keys)
    static let mirroredSubGoalIndices = Set(subGoalMirrorMap.values)

    @MainActor
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

    static func roleForIndex(_ index: Int) -> MandalaRole {
        guard index >= 0 && index < cellCount else { return .task }
        // 중앙 한 칸은 Main Goal.
        if index == mainIndex { return .main }
        // 중앙 3x3 주변 8칸과 바깥 3x3 중심 8칸은 Sub Goal.
        if coreSubGoalIndices.contains(index) { return .subGoal }
        if mirroredSubGoalIndices.contains(index) { return .subGoal }
        return .task
    }

    @MainActor
    static func syncSubGoalIfNeeded(
        for cell: MandalaCellEntity,
        in context: ModelContext
    ) {
        // 중앙/바깥 subGoal 어느 쪽을 편집해도 대응되는 셀로 텍스트를 복사한다.
        let targetIndex = subGoalMirrorMap[cell.index] ?? subGoalReverseMap[cell.index]
        guard let targetIndex,
              let board = cell.board,
              let targetCell = board.cells.first(where: { $0.index == targetIndex })
        else { return }

        if targetCell.text != cell.text {
            targetCell.text = cell.text
            try? context.save()
        }
    }

    @MainActor
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
