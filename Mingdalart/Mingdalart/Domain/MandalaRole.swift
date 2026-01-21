//
//  MandalaRole.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import Foundation

public enum MandalaRole: Codable, Hashable {
    case main
    case subGoal
    case task
    
    // 그리드에서 기본 표시 텍스트로 사용한다.
    public var description: String {
        switch self {
        case .main:
            return "Main Goal"
        case .subGoal:
            return "Sub Goal"
        case .task:
            return "Task"
        }
    }
}
