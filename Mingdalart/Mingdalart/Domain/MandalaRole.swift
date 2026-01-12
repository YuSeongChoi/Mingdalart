//
//  MandalaRole.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftUI

enum MandalaRole: Codable, Hashable {
    case main
    case subGoal
    case task
    
    // 그리드에서 기본 표시 텍스트로 사용한다.
    var description: String {
        switch self {
        case .main:
            return "Main Goal"
        case .subGoal:
            return "Sub Goal"
        case .task:
            return "Task"
        }
    }
    
    var font: Font {
        switch self {
        case .main:
            return .title2.bold()
        case .subGoal:
            return .headline
        case .task:
            return .body
        }
    }

    var backgroundColor: Color {
        switch self {
        case .main:
            // 다크모드에서도 대비가 유지되는 시스템 색상 사용.
            return Color(.systemYellow).opacity(0.85)
        case .subGoal:
            return Color(.systemTeal).opacity(0.25)
        case .task:
            return Color(.secondarySystemBackground)
        }
    }

    var textColor: Color {
        switch self {
        case .main:
            return Color(.label)
        case .subGoal:
            return Color(.label)
        case .task:
            return Color(.label)
        }
    }
}
