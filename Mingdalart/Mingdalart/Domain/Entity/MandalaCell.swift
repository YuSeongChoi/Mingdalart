//
//  MandalaCell.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

public struct MandalaCell {
    public let index: Int
    public var text: String
    public var role: MandalaRole
    public var board: MandalaBoard?
    
    public init(index: Int, text: String, role: MandalaRole, board: MandalaBoard? = nil) {
        self.index = index
        self.text = text
        self.role = role
        self.board = board
    }
}
