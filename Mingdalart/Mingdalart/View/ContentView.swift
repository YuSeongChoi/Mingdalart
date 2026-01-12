//
//  ContentView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/7/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MandalaBoardEntity.createdAt) private var boards: [MandalaBoardEntity]
    @State private var editingCell: MandalaCellEntity?

    var body: some View {
        Group {
            if let board = boards.first {
                let viewModel = MandalaViewModel(board: board, context: modelContext)
                MandalaGridView(
                    cells: viewModel.orderedCells,
                    onSelect: { cell in
                        editingCell = cell
                    }
                )
                .padding(16)
                .background(Color.white)
            } else {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            MandalaStore.ensureDefaultBoard(in: modelContext)
        }
        .sheet(item: $editingCell) { cell in
            MandalaEditorSheet(cell: cell)
        }
    }
}
