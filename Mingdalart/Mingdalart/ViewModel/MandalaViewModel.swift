//
//  MandalaViewModel.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftData
import SwiftUI

@Observable
@MainActor
final class MandalaViewModel {
    var board: MandalaBoardEntity

    init(board: MandalaBoardEntity) {
        self.board = board
    }

    // 9x9 셀을 인덱스 순서대로 정렬해 그리드와 매칭한다.
    var orderedCells: [MandalaCellEntity] {
        board.cells.sorted { $0.index < $1.index }
    }
}
