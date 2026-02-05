//
//  MandalaView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/7/26.
//

import SwiftUI

struct MandalaView: View {
    @State private var viewModel: MandalaViewModel
    @State private var editingCell: MandalaCell?

    init(viewModel: MandalaViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: Layout.verticalSpacing) {
            HeaderSection(
                quote: viewModel.mingMingQuote,
                progressHeadline: progressHeadline,
                completionRate: viewModel.completionRate,
                accentColor: Layout.accentColor,
                secondaryTextColor: Layout.secondaryTextColor
            )
            .padding(.horizontal, Layout.horizontalPadding)

            GeometryReader { proxy in
                let gridSide = gridSide(for: proxy.size)

                GridWithMascot(
                    side: gridSide,
                    mascotImageSizeRatio: Layout.mascotImageSizeRatio,
                    secondaryTextColor: Layout.secondaryTextColor,
                    onTapCell: { cell in editingCell = cell },
                    cells: viewModel.orderedCells
                )
                .padding(.horizontal, Layout.gridHorizontalPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .task {
            viewModel.load()
        }
        .background(Layout.backgroundColor)
        .sheet(item: $editingCell) { cell in
            MandalaEditorSheet(cell: cell) { text, isDone in
                viewModel.updateCellText(index: cell.index, text: text, isDone: isDone)
            }
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Computed

    private var progressHeadline: String {
        let rate = viewModel.completionRate
        switch rate {
        case 0:
            return "첫 칸을 채울 준비가 됐어요"
        case 0..<0.3:
            return "천천히, 몽글몽글 채우는 중"
        case 0..<0.7:
            return "좋아요! 꾸준히 쌓이고 있어요"
        case 0..<1.0:
            return "거의 다 왔어요, 조금만 더"
        default:
            return "완성! 오늘도 정말 멋져요"
        }
    }

    // MARK: - Layout

    private func gridSide(for size: CGSize) -> CGFloat {
        let availableWidth = max(size.width - (Layout.gridHorizontalPadding * 2), 0)
        let availableHeight = max(
            size.height - Layout.gridAndMascotSpacing - Layout.mascotLabelHeight,
            0
        )
        let heightBasedSide = availableHeight / (1 + Layout.mascotImageSizeRatio)
        return max(min(availableWidth, heightBasedSide), 0)
    }
}

private extension MandalaView {
    enum Layout {
        static let backgroundColor = MandalaPalette.backgroundCream
        static let accentColor = MandalaPalette.warmBeige
        static let secondaryTextColor = MandalaPalette.cocoaText
        static let horizontalPadding: CGFloat = 8
        static let verticalSpacing: CGFloat = 8
        static let gridAndMascotSpacing: CGFloat = 8
        static let gridHorizontalPadding: CGFloat = 4
        static let mascotLabelHeight: CGFloat = 28
        static let mascotImageSizeRatio: CGFloat = 0.3
        static let mascotImageOffsetY: CGFloat = -20
    }
}

// MARK: - Subviews

private struct HeaderSection: View {
    let quote: String
    let progressHeadline: String
    let completionRate: Double
    let accentColor: Color
    let secondaryTextColor: Color

    var body: some View {
        VStack(spacing: 20) {
            Text(quote)
                .pretendSemiBold(size: 12)
                .foregroundStyle(MandalaPalette.cocoaText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(MandalaPalette.warmBeige.opacity(0.5))
                .cornerRadius(15)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(progressHeadline)
                    .pretendReg(size: 12)
                    .foregroundStyle(secondaryTextColor)
                    .contentTransition(.opacity)

                ProgressView(value: completionRate)
                    .tint(accentColor)
                    .animation(.easeInOut(duration: 0.25), value: completionRate)

                Text("지금까지 \(Int(completionRate * 100))% 채웠어요")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
            .animation(.easeInOut(duration: 0.2), value: completionRate)
        }
    }
}

private struct GridWithMascot: View {
    let side: CGFloat
    let mascotImageSizeRatio: CGFloat
    let secondaryTextColor: Color
    let onTapCell: (MandalaCell) -> Void
    let cells: [MandalaCell]

    var body: some View {
        VStack(spacing: 8) {
            MandalaGridView(cells: cells) { cell in
                onTapCell(cell)
            }
            .frame(width: side, height: side)

            MascotSection(
                side: side,
                mascotImageSizeRatio: mascotImageSizeRatio,
                secondaryTextColor: secondaryTextColor
            )
        }
    }
}

private struct MascotSection: View {
    let side: CGFloat
    let mascotImageSizeRatio: CGFloat
    let secondaryTextColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                MascotLabel(secondaryTextColor: secondaryTextColor)

                R.image.hamster.swiftImage
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: side * mascotImageSizeRatio,
                        height: side * mascotImageSizeRatio
                    )
                    .clipped()
                    .offset(y: MandalaView.Layout.mascotImageOffsetY)
                    .zIndex(-1)
            }
        }
    }
}

private struct MascotLabel: View {
    let secondaryTextColor: Color

    var body: some View {
        Text("밍🐹")
            .pretendSemiBold(size: 13)
            .foregroundStyle(secondaryTextColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(MandalaPalette.taskCream)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(MandalaPalette.warmBeige.opacity(0.4), lineWidth: 1)
                    )
            )
            .overlay(alignment: .bottomTrailing) {
                Circle()
                    .fill(MandalaPalette.taskCream)
                    .frame(width: 6, height: 6)
                    .offset(x: 2, y: 6)
            }
            .shadow(color: MandalaPalette.cellShadow.opacity(0.12), radius: 2, x: 0, y: 1)
    }
}
