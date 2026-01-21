//
//  MandalaBoard.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

public struct MandalaBoard {
    public var title: String
    public var cells: [MandalaCell]
    
    init(title: String, cells: [MandalaCell]) {
        self.title = title
        self.cells = cells
    }
}
