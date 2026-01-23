//
//  MandalaRuleTests.swift
//  MingdalartTests
//
//  Created by YuSeongChoi on 1/23/26.
//

import Testing
@testable import Mingdalart

struct MandalaRuleTests {
    @Test("메인_인덱스_확인")
    func roleForIndex_main() async throws {
        #expect(MandalaRule.roleForIndex(40) == .main)
    }

    @Test("보조_인덱스_확인")
    func roleForIndex_subGoal_coreAndMirror() async throws {
        #expect(MandalaRule.roleForIndex(30) == .subGoal)
        #expect(MandalaRule.roleForIndex(10) == .subGoal)
    }

    @Test("기본_태스크_확인")
    func roleForIndex_task() async throws {
        #expect(MandalaRule.roleForIndex(0) == .task)
    }
}
