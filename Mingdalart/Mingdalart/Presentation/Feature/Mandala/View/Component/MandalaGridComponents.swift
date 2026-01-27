//
//  MandalaGridComponents.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftUI

struct MandalaCellView: View {
    let cell: MandalaCell
    let size: CGFloat
    
    private let baseShadow = MandalaPalette.cellShadow.opacity(0.18)
    private let doneHighlight = MandalaPalette.doneHighlight
    private let doneAccent = MandalaPalette.doneAccent

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.1, style: .continuous)
                .fill(cell.role.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.1, style: .continuous)
                        .fill(cell.isDone ? doneHighlight.opacity(0.1) : .clear)
                )
                .shadow(color: baseShadow, radius: 3, x: 0, y: 1)

            if cell.isDone {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(doneAccent)
                    .font(.caption2)
                    .padding(4)
                    .position(x: size - 12, y: 12)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Text(displayText)
                .font(cell.role.font)
                .foregroundStyle(cell.role.textColor)
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .padding(4)
                .minimumScaleFactor(0.5)
                .allowsTightening(true)
        }
        .frame(width: size, height: size)
        .animation(.easeInOut(duration: 0.2), value: cell.isDone)
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

func maxAllowedOffset(side: CGFloat, scale: CGFloat) -> CGSize {
    let extra = max((side * scale - side) / 2, 0)
    return CGSize(width: extra, height: extra)
}

func clamped(_ value: CGSize, limit: CGSize) -> CGSize {
    let clampedX = min(max(value.width, -limit.width), limit.width)
    let clampedY = min(max(value.height, -limit.height), limit.height)
    return CGSize(width: clampedX, height: clampedY)
}
