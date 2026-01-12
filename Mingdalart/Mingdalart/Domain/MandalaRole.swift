//
//  MandalaRole.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import Foundation
import SwiftUI

enum MandalaRole: Codable, Hashable {
    case main
    case subGoal
    case task
    
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
            return Color(red: 0.99, green: 0.93, blue: 0.75)
        case .subGoal:
            return Color(red: 0.88, green: 0.94, blue: 0.99)
        case .task:
            return Color(red: 0.97, green: 0.97, blue: 0.97)
        }
    }

    var textColor: Color {
        switch self {
        case .main:
            return Color(red: 0.35, green: 0.22, blue: 0.12)
        case .subGoal:
            return Color(red: 0.10, green: 0.24, blue: 0.40)
        case .task:
            return Color(red: 0.20, green: 0.20, blue: 0.20)
        }
    }
}
