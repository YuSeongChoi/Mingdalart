//
//  ContentView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/7/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MandalaGridView()
            .padding(16)
            .background(Color.white)
    }
}



struct MandalaGridView: View {
    // 9x9 grid
    private let gridCount: Int = 9

    // Reference-like highlight: only the center cell of each 3x3 block (i.e., (1,1) within each block)
    private let highlightOpacity: CGFloat = 0.35

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let cell = side / CGFloat(gridCount)

            ZStack(alignment: .topLeading) {
                // 1) Highlight cells (drawn once, no borders here)
                ForEach(highlightCells(), id: \.index) { item in
                    Rectangle()
                        .fill(item.color.opacity(highlightOpacity))
                        .frame(width: cell, height: cell)
                        .offset(x: CGFloat(item.col) * cell, y: CGFloat(item.row) * cell)
                }

                // 2) Grid lines (drawn once)
                MandalaGridLines(gridCount: gridCount, cellSize: cell)
                    .stroke(Color.black, lineWidth: 1)

                // 3) Thicker 3x3 separators (drawn once)
                MandalaSeparatorLines(gridCount: gridCount, cellSize: cell)
                    .stroke(Color.black, lineWidth: 2)

                // 4) Center focus (optional)
                let inset: CGFloat = 1.0   // half of thin grid line (1pt)

                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black, lineWidth: 0.5)
                    .frame(width: cell - inset * 2, height: cell - inset * 2)
                    .offset(
                        x: 4 * cell + inset,
                        y: 4 * cell + inset
                    )
            }
            .frame(width: side, height: side, alignment: .topLeading)
            .position(x: proxy.size.width / 2, y: side / 2)
        }
        // Make sure the grid keeps a square aspect and doesn't stretch vertically
        .aspectRatio(1, contentMode: .fit)
    }

    private struct HighlightCell {
        let index: Int
        let row: Int
        let col: Int
        let color: Color
    }

    private func highlightCells() -> [HighlightCell] {
        // Centers of each 3x3 block: rows/cols = 1,4,7 (within 0...8)
        let centers = [1, 4, 7]

        // Order corresponds to 3x3 blocks (top-left -> bottom-right)
        let colors: [Color] = [
            .red, .yellow, .mint,
            .purple, .gray, .cyan,
            .indigo, .blue, .teal
        ]

        var result: [HighlightCell] = []
        var i = 0
        for br in 0..<3 {
            for bc in 0..<3 {
                let row = centers[br]
                let col = centers[bc]
                let index = row * 9 + col
                result.append(.init(index: index, row: row, col: col, color: colors[i]))
                i += 1
            }
        }
        return result
    }
}

struct MandalaGridLines: Shape {
    let gridCount: Int
    let cellSize: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()

        let side = cellSize * CGFloat(gridCount)

        // Vertical lines (0...gridCount)
        for i in 0...gridCount {
            let x = CGFloat(i) * cellSize
            p.move(to: CGPoint(x: x, y: 0))
            p.addLine(to: CGPoint(x: x, y: side))
        }

        // Horizontal lines (0...gridCount)
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

        // 3x3 block separators at 0,3,6,9
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
