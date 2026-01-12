//
//  MandalaGridView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftUI

struct MandalaGridView: View {
    private let gridCount: Int = MandalaStore.gridCount
    let cells: [MandalaCellEntity]
    let onSelect: (MandalaCellEntity) -> Void

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let cell = side / CGFloat(gridCount)

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
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct MandalaCellView: View {
    let cell: MandalaCellEntity
    let size: CGFloat

    var body: some View {
        ZStack {
            Rectangle()
                .fill(cell.role.backgroundColor)

            Text(displayText)
                .font(cell.role.font)
                .foregroundStyle(cell.role.textColor)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(4)
                .minimumScaleFactor(0.6)
        }
        .frame(width: size, height: size)
    }

    private var displayText: String {
        // 입력된 텍스트가 있으면 그대로, 없으면 역할명(메인/서브)만 표시.
        if !cell.text.isEmpty { return cell.text }
        return cell.role == .task ? "" : cell.role.description
    }
}

struct MandalaGridLines: Shape {
    let gridCount: Int
    let cellSize: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()

        let side = cellSize * CGFloat(gridCount)

        // 세로 선
        for i in 0...gridCount {
            let x = CGFloat(i) * cellSize
            p.move(to: CGPoint(x: x, y: 0))
            p.addLine(to: CGPoint(x: x, y: side))
        }

        // 가로 선
        for i in 0...gridCount {
            let y = CGFloat(i) * cellSize
            p.move(to: CGPoint(x: 0, y: y))
            p.addLine(to: CGPoint(x: side, y: y))
        }

        return p
    }
}

struct MandalaSeparatorLines: Shape {
    let gridCount: Int
    let cellSize: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let side = cellSize * CGFloat(gridCount)

        // 3x3 블록 경계선(0,3,6,9)에만 굵은 선을 그린다.
        for i in stride(from: 0, through: gridCount, by: 3) {
            let x = CGFloat(i) * cellSize
            p.move(to: CGPoint(x: x, y: 0))
            p.addLine(to: CGPoint(x: x, y: side))

            let y = CGFloat(i) * cellSize
            p.move(to: CGPoint(x: 0, y: y))
            p.addLine(to: CGPoint(x: side, y: y))
        }

        return p
    }
}
