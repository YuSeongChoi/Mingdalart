//
//  MandalaEditorSheet.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftUI
import SwiftData

struct MandalaEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var cell: MandalaCellEntity

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(cell.role.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Index \(cell.index)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                TextField("내용을 입력하세요", text: $cell.text, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3, reservesSpace: true)

                Spacer()
            }
            .padding(20)
            .navigationTitle("셀 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: MandalaBoardEntity.self,
        MandalaCellEntity.self,
        configurations: config
    )
    let cell = MandalaCellEntity(index: 40, text: "Main Goal", role: .main)
    return MandalaEditorSheet(cell: cell)
        .modelContainer(container)
}
