//
//  MandalaEditorSheet.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/12/26.
//

import SwiftUI

struct MandalaEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    let cell: MandalaCell
    let onSave: (String) -> Void
    @State private var text: String
    private let maxTextLength = 20

    init(cell: MandalaCell, onSave: @escaping (String) -> Void) {
        self.cell = cell
        self.onSave = onSave
        _text = State(initialValue: cell.text)
    }

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

                // 엔터 없이 한 줄만 입력되도록 하고, 20자 제한을 둔다.
                TextField("내용을 입력하세요", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > maxTextLength {
                            text = String(newValue.prefix(maxTextLength))
                        }
                    }
                HStack {
                    Spacer()
                    Text("\(text.count)/\(maxTextLength)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }

                Spacer()
            }
            .padding(20)
            .navigationTitle("셀 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onSave(text)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let cell = MandalaCell(index: 40, text: "Main Goal", role: .main)
    return MandalaEditorSheet(cell: cell) { _ in }
}
