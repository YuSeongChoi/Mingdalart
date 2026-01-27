//
//  MandalaRole.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import Foundation

enum MandalaRole: Int, Codable, Hashable, Sendable {
    case main
    case subGoal
    case task
    
    // 그리드에서 기본 표시 텍스트로 사용한다.
    var description: String {
        switch self {
        case .main:
            return "메인 목표"
        case .subGoal:
            return "서브 목표"
        case .task:
            return "과제"
        }
    }
}
