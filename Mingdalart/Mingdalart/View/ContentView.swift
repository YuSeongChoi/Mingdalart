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
    @Query private var boards: [MandalaBoardEntity]
    @State private var editingCell: MandalaCellEntity?

    var body: some View {
        VStack(spacing: 0) {
            if let board = boards.first {
                let viewModel = MandalaViewModel(board: board)
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
            // 최초 실행 시 기본 보드 생성.
            MandalaStore.ensureDefaultBoard(in: modelContext)
        }
        .sheet(item: $editingCell) { cell in
            MandalaEditorSheet(cell: cell)
        }
    }
}
