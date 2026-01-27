//
//  MandalaCell.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

struct MandalaCell: Identifiable {
    let index: Int
    var text: String
    var role: MandalaRole
    var isDone: Bool
    var doneAt: Date?
    var board: MandalaBoard?

    var id: Int { index }
    
    init(index: Int, text: String, role: MandalaRole, isDone: Bool = false, doneAt: Date? = nil, board: MandalaBoard? = nil) {
        self.index = index
        self.text = text
        self.role = role
        self.isDone = isDone
        self.doneAt = doneAt
        self.board = board
    }
}
