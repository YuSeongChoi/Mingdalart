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
    var board: MandalaBoard?

    var id: Int { index }
    
    init(index: Int, text: String, role: MandalaRole, board: MandalaBoard? = nil) {
        self.index = index
        self.text = text
        self.role = role
        self.board = board
    }
}
