//
//  MandalaBoard.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

struct MandalaBoard {
    var title: String
    var cells: [MandalaCell]
    
    init(title: String, cells: [MandalaCell]) {
        self.title = title
        self.cells = cells
    }
}
