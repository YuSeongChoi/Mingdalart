//
//  MandalaBoard.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import Foundation
import SwiftData

@Model
class MandalaBoardEntity {
    var title: String
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    var cells: [MandalaCellEntity]

    init(title: String, createdAt: Date = Date(), cells: [MandalaCellEntity] = []) {
        self.title = title
        self.createdAt = createdAt
        self.cells = cells
    }
}
