//
//  ContentView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/7/26.
//

import SwiftUI

struct MainView: View {
    @State private var viewModel: MandalaViewModel
    @State private var editingCell: MandalaCell?
    private let backgroundColor = MandalaPalette.backgroundCream
    private let accentColor = MandalaPalette.warmBeige
    private let secondaryTextColor = MandalaPalette.cocoaText
    
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
            
            
            MandalaGridView(cells: viewModel.orderedCells) { cell in
                editingCell = cell
            }
            .padding(.top, 20)
            .padding(.horizontal, 4)
            
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
}
