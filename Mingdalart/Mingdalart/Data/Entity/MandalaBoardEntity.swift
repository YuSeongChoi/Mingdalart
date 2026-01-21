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
    // 보드가 삭제되면 하위 셀도 같이 지워지도록 cascade 규칙을 사용한다.
    @Relationship(deleteRule: .cascade)
    var cells: [MandalaCellEntity]

    init(title: String, cells: [MandalaCellEntity] = []) {
        self.title = title
        self.cells = cells
    }
}
