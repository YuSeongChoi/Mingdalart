//
//  MandalaGridView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftUI

struct MandalaGridView: View {
    private let gridCount: Int = MandalaRule.gridCount
    let cells: [MandalaCell]
    let onSelect: (MandalaCell) -> Void
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 1.8

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let cell = side / CGFloat(gridCount)
            let maxOffset = maxAllowedOffset(side: side, scale: scale)

            ZStack(alignment: .topLeading) {
                // 9x9 셀을 정사각형 그리드로 배치한다.
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.fixed(cell), spacing: 0),
                        count: gridCount
                    ),
                    spacing: 0
                ) {
                    ForEach(cells, id: \.index) { cellItem in
                        MandalaCellView(cell: cellItem, size: cell)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onSelect(cellItem)
                            }
                    }
                }
                .frame(width: side, height: side, alignment: .topLeading)

                // 셀 위에 선을 그려 경계가 선명하게 보이도록 한다.
                MandalaGridLines(gridCount: gridCount, cellSize: cell)
                    .stroke(Color.black, lineWidth: 1)

                // 3x3 블록 경계선은 더 굵게 표시한다.
                MandalaSeparatorLines(gridCount: gridCount, cellSize: cell)
                    .stroke(Color.black, lineWidth: 2)
            }
            .frame(width: side, height: side, alignment: .topLeading)
            .position(x: proxy.size.width / 2, y: side / 2)
            .scaleEffect(scale)
            .offset(clamped(offset, limit: maxOffset))
            .gesture(magnificationGesture(side: side))
            .simultaneousGesture(dragGesture(maxOffset: maxOffset))
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func magnificationGesture(side: CGFloat) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let clamped = min(max(lastScale * value, minScale), maxScale)
                scale = clamped
            }
            .onEnded { _ in
                lastScale = scale
                if scale == minScale {
                    offset = .zero
                    lastOffset = .zero
                } else {
                    offset = clamped(offset, limit: maxAllowedOffset(side: side, scale: scale))
                    lastOffset = offset
                }
            }
    }

    private func dragGesture(maxOffset: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard scale > minScale else { return }
                let proposed = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
                offset = clamped(proposed, limit: maxOffset)
            }
            .onEnded { _ in
                guard scale > minScale else { return }
                lastOffset = clamped(offset, limit: maxOffset)
                offset = lastOffset
            }
    }
}
