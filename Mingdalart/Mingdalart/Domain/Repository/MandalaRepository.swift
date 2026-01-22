//
//  MandalaRepository.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

@MainActor
protocol MandalaRepository { // SwiftData/ModelContext를 메인 쓰레드에서 쓰는게 '안전'하기 떄문
    func fetchBoard() -> MandalaBoard?
    func saveBoard(_ board: MandalaBoard)
    // TODO: task progress feature 예정
    func saveCell(_ cell: MandalaCell)
}
