//
//  ContentView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/7/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: MandalaViewModel?
    @State private var editingCell: MandalaCell?

    var body: some View {
        VStack(spacing: 0) {
            if let viewModel, viewModel.board != nil {
                MandalaGridView(
                    cells: viewModel.orderedCells,
                    onSelect: { cell in
                        // 셀 탭 시 편집 시트를 띄운다.
                        editingCell = cell
                    }
                )
                .padding(.top, 20)
                .padding(.horizontal, 4)
            } else {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Spacer(minLength: 0)
        }
        .background(Color(.systemBackground))
        .task {
            if viewModel == nil {
                let repository = SwiftDataMandalaRepository(context: modelContext)
                viewModel = MandalaViewModel(useCase: MandalaUseCase(repository: repository))
                viewModel?.load()
            }
        }
        .sheet(item: $editingCell) { cell in
            MandalaEditorSheet(cell: cell) { text in
                viewModel?.updateCellText(index: cell.index, text: text)
            }
        }
    }
}
