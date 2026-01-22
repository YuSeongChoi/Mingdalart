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
        VStack(spacing: 0) {
            MandalaGridView(
                cells: viewModel.orderedCells,
                onSelect: { cell in
                    // 셀 탭 시 편집 시트를 띄운다.
                    editingCell = cell
                }
            )
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
