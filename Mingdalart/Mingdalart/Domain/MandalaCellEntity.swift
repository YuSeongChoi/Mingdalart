//
//  MandalaCell.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import Foundation
import SwiftData

@Model
class MandalaCellEntity {
    var index: Int
    var text: String
    var role: MandalaRole
    
    @Relationship(inverse: \MandalaBoardEntity.cells)
    var board: MandalaBoardEntity?

    init(
        index: Int,
        text: String = "",
        role: MandalaRole = .task,
        board: MandalaBoardEntity? = nil
    ) {
        self.index = index
        self.text = text
        self.role = role
        self.board = board
    }
}
