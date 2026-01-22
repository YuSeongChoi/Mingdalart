//
//  MandalaRole+Style.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import SwiftUI

@MainActor
extension MandalaRole {
    var font: Font {
        switch self {
        case .main:
            return .headline.bold()
        case .subGoal:
            return .subheadline
        case .task:
            return .footnote
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
