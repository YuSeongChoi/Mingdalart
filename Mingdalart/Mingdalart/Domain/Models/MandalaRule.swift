//
//  MandalaRule.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

public struct MandalaRule {
    public static let gridCount = 9
    public static let cellCount = 81
    public static let mainIndex = 40

    // 중앙 3x3의 subGoal을 바깥 3x3 중심으로 복사할 때의 매핑.
    public static let subGoalMirrorMap: [Int: Int] = [
        30: 10, 31: 13, 32: 16,
        39: 37, 41: 43,
        48: 64, 49: 67, 50: 70
    ]
    public static let subGoalReverseMap: [Int: Int] = [
        10: 30, 13: 31, 16: 32,
        37: 39, 43: 41,
        64: 48, 67: 49, 70: 50
    ]
    
    public static let coreSubGoalIndices = Set(subGoalMirrorMap.keys)
    public static let mirroredSubGoalIndices = Set(subGoalMirrorMap.values)
    
    public static func roleForIndex(_ index: Int) -> MandalaRole {
        guard index >= 0 && index < cellCount else { return .task }
        // 중앙 한 칸은 Main Goal.
        if index == mainIndex { return .main }
        // 중앙 3x3 주변 8칸과 바깥 3x3 중심 8칸은 Sub Goal.
        if coreSubGoalIndices.contains(index) { return .subGoal }
        if mirroredSubGoalIndices.contains(index) { return .subGoal }
        return .task
    }
}
