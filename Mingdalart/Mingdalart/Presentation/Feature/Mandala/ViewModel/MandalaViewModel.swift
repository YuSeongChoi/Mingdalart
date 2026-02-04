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
    var mingMingQuote: String = ""
    
    var completionRate: Double {
        guard let board else { return 0 }
        return useCase.completionRate(board: board)
    }

    init(useCase: MandalaUseCase) {
        self.useCase = useCase
    }

    func load() {
        board = useCase.loadBoard()
        mingMingQuote = MingMingQuoteLoader.loadRandomQuote() ?? ""
    }

    func updateCellText(index: Int, text: String, isDone: Bool? = nil) {
        guard let board else { return }
        self.board = useCase.updateCellText(board: board, index: index, text: text, isDone: isDone)
    }

    // 9x9 셀을 인덱스 순서대로 정렬해 그리드와 매칭한다.
    var orderedCells: [MandalaCell] {
        board?.cells.sorted { $0.index < $1.index } ?? []
    }
}

private enum MingMingQuoteLoader {
    static func loadRandomQuote() -> String? {
        guard let url = Bundle.main.url(forResource: "MingMingQuotes", withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let quotes = try JSONDecoder().decode([String].self, from: data)
            return quotes.randomElement()
        } catch {
            return nil
        }
    }
}
