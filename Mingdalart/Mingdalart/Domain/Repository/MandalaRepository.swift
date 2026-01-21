//
//  MandalaRepository.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/21/26.
//

import Foundation

@MainActor
protocol MandalaRepository {
    func fetchBoard() -> MandalaBoard?
    func saveBoard(_ board: MandalaBoard)
    func saveCell(_ cell: MandalaCell)
}
