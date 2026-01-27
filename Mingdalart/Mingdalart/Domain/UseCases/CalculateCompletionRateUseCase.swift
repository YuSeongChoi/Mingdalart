//
//  CalculateCompletionRateUseCase.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/27/26.
//

import Foundation

struct CalculateCompletionRateUseCase {
    func execute(board: MandalaBoard) -> Double {
        let total = board.cells.filter { $0.role == .task }.count
        guard total > 0 else { return 0 }
        let done = board.cells.filter { $0.role == .task && $0.isDone }.count
        return Double(done) / Double(total)
    }
}
