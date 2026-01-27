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
    private let backgroundCream = MandalaPalette.backgroundCream
    private let cardShadow = MandalaPalette.cellShadow.opacity(0.18)
    private let accent = MandalaPalette.warmBeige
    private let secondaryText = MandalaPalette.cocoaText

    init(cell: MandalaCell, onSave: @escaping (String) -> Void) {
        self.cell = cell
        self.onSave = onSave
        _text = State(initialValue: cell.text)
    }

    var body: some View {
        ZStack {
            backgroundCream
                .ignoresSafeArea()

            VStack {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("이 칸에 무엇을 적어볼까요?")
                            .font(.headline)
                            .foregroundStyle(secondaryText)

                        Text(cell.role.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // 엔터 없이 한 줄만 입력되도록 하고, 20자 제한을 둔다.
                    TextField("조금만 적어봐도 좋아요", text: $text)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(MandalaPalette.taskCream)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .onChange(of: text) { _, newValue in
                            if newValue.count > maxTextLength {
                                text = String(newValue.prefix(maxTextLength))
                            }
                        }

                    Text("완벽하지 않아도 괜찮아요.")
                        .font(.caption2)
                        .foregroundStyle(secondaryText.opacity(0.8))

                    HStack {
                        Text("\(text.count)/\(maxTextLength)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                        Spacer()
                    }

                    Button {
                        onSave(text)
                        dismiss()
                    } label: {
                        Text("적어두기")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(accent)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .padding(.top, 2)
                }
                .padding(18)
                .padding(.vertical, 12)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: cardShadow, radius: 8, x: 0, y: 4)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    let cell = MandalaCell(index: 40, text: "Main Goal", role: .main)
    return MandalaEditorSheet(cell: cell) { _ in }
}
