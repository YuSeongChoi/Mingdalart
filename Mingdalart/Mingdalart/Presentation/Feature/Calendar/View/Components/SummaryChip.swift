//
//  SummaryChip.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 2/2/26.
//

import SwiftUI

struct SummaryChip: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text(value)
                .pretendSemiBold(size: 12)
                .contentTransition(.numericText())
        }
        .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: MandalaPalette.cellShadow.opacity(0.12), radius: 2, x: 0, y: 1)
    }
}
