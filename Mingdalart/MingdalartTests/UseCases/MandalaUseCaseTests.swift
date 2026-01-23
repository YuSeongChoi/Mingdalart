//
//  MandalaUseCaseTests.swift
//  MingdalartTests
//
//  Created by YuSeongChoi on 1/23/26.
//

import Testing
@testable import Mingdalart

@MainActor
struct MandalaUseCaseTests {
    @Test("비어있는_보드_만들기")
    func ensureDefaultBoard_createBoardWhenEmpty() async throws {
        let repo = MockMandalaRepository()
        let useCase = EnsureDefaultBoardUseCase(repository: repo)
        
        let board = useCase.execute()
        
        #expect(board.cells.count == MandalaRule.cellCount)
        #expect(repo.savedBoard != nil)
    }
    
    @Test("서브목표_텍스트_동기화")
    func updateCellText_syncsSubGoal() async throws {
        let repo = MockMandalaRepository()
        let useCase = UpdateCellTextUseCase(repository: repo)
        
        let board = MandalaBoard(title: "test", cells: (0..<MandalaRule.cellCount).map {
            MandalaCell(index: $0, text: "", role: MandalaRule.roleForIndex($0))
        })
        
        let updated = useCase.execute(board: board, index: 30, text: "SubGoal")
        
        let mirror = updated.cells.first { $0.index == 10 }
        #expect(mirror?.text == "SubGoal")
    }
}

final class MockMandalaRepository: MandalaRepository {
    var storedBoard: MandalaBoard?
    var savedBoard: MandalaBoard?
    var savedCell: MandalaCell?
    
    func fetchBoard() -> MandalaBoard? {
        storedBoard
    }
    
    func saveBoard(_ board: MandalaBoard) {
        savedBoard = board
        storedBoard = board
    }
    
    func saveCell(_ cell: MandalaCell) {
        savedCell = cell
    }
}
