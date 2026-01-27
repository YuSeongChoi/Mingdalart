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
    
    init(viewModel: MandalaViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            ProgressView(value: viewModel.completionRate)
            Text("\(Int(viewModel.completionRate * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            MandalaGridView(cells: viewModel.orderedCells, onTap: { cell in
                editingCell = cell
            }, onLongPressGesture: { cell in
                viewModel.toggleCompletion(index: cell.index)
            })
            .padding(.top, 20)
            .padding(.horizontal, 4)
        }
        .task {
            viewModel.load()
        }
        .background(Color(.systemBackground))
        .sheet(item: $editingCell) { cell in
            MandalaEditorSheet(cell: cell) { text in
                viewModel.updateCellText(index: cell.index, text: text)
            }
        }
    }
}
