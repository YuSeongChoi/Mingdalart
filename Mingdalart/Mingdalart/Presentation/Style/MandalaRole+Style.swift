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
            return MandalaPalette.mainPeach
        case .subGoal:
            return MandalaPalette.subGoalMint
        case .task:
            return MandalaPalette.taskCream
        }
    }

    var textColor: Color {
        switch self {
        case .main:
            return MandalaPalette.cellText
        case .subGoal:
            return MandalaPalette.cellText
        case .task:
            return MandalaPalette.cellText
        }
    }
}
