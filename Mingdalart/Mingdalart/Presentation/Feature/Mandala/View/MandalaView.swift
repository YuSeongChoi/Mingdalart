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
    private let backgroundColor = MandalaPalette.backgroundCream
    private let accentColor = MandalaPalette.warmBeige
    private let secondaryTextColor = MandalaPalette.cocoaText
    private let mascotImageSizeRatio: CGFloat = 0.3
    
    init(viewModel: MandalaViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("오늘도 한 칸씩, 천천히 🐹")
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(progressHeadline)
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor)
                        .contentTransition(.opacity)
                    
                    ProgressView(value: viewModel.completionRate)
                        .tint(accentColor)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.completionRate)
                    
                    Text("지금까지 \(Int(viewModel.completionRate * 100))% 채웠어요")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .contentTransition(.numericText())
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.completionRate)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            gridWithMascot
            
            Spacer()
        }
        .task {
            viewModel.load()
        }
        .background(backgroundColor)
        .sheet(item: $editingCell) { cell in
            MandalaEditorSheet(cell: cell) { text, isDone in
                viewModel.updateCellText(index: cell.index, text: text, isDone: isDone)
            }
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
        }
    }

    

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

    private var gridWithMascot: some View {
        GeometryReader { proxy in
            let side = max(proxy.size.width - 8, 0)
            VStack(spacing: 8) {
                MandalaGridView(cells: viewModel.orderedCells) { cell in
                    editingCell = cell
                }
                .frame(width: side, height: side)
                
                HStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 0) {
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
                        
                        R.image.hamster.swiftImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: side * mascotImageSizeRatio, height: side * mascotImageSizeRatio)
                            .clipped()
                            .offset(y: -20)
                            .zIndex(-1)
                    }
                }
            }
            .frame(width: proxy.size.width, alignment: .top)
        }
        .frame(minHeight: 0)
        .padding(.top, 20)
        .padding(.horizontal, 4)
    }
}
