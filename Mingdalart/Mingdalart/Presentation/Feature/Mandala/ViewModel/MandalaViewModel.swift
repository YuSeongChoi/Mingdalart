//
//  MandalaViewModel.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftUI

@Observable
@MainActor
final class MandalaViewModel {
    private let useCase: MandalaUseCase
    var board: MandalaBoard?
    
    var completionRate: Double {
        guard let board else { return 0 }
        return useCase.completionRate(board: board)
    }

    init(useCase: MandalaUseCase) {
        self.useCase = useCase
    }

    func load() {
        board = useCase.loadBoard()
    }

    func updateCellText(index: Int, text: String) {
        guard let board else { return }
        self.board = useCase.updateCellText(board: board, index: index, text: text)
    }

    // 9x9 셀을 인덱스 순서대로 정렬해 그리드와 매칭한다.
    var orderedCells: [MandalaCell] {
        board?.cells.sorted { $0.index < $1.index } ?? []
    }
    
    func toggleCompletion(index: Int) {
        guard let board else { return }
        self.board = useCase.toggleCompletion(board: board, index: index)
    }
}
