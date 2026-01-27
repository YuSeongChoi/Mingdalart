//
//  MandalaCell.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftData
import Foundation

@Model
class MandalaCellEntity {
    // 0~80의 인덱스가 9x9 그리드 좌표를 결정한다.
    var index: Int
    var text: String
    var role: MandalaRole
    var isDone: Bool
    var doneAt: Date?

    // 셀이 어느 보드에 속해있는지 양방향 관계로 유지한다.
    @Relationship(inverse: \MandalaBoardEntity.cells)
    var board: MandalaBoardEntity?

    init(
        index: Int,
        text: String = "",
        role: MandalaRole = .task,
        isDone: Bool = false,
        doneAt: Date? = nil,
        board: MandalaBoardEntity? = nil
    ) {
        self.index = index
        self.text = text
        self.role = role
        self.isDone = isDone
        self.doneAt = doneAt
        self.board = board
    }
}
