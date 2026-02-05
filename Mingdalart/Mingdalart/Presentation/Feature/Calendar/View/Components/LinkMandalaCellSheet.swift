//
//  LinkMandalaCellSheet.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 2/2/26.
//

import SwiftUI

struct LinkMandalaCellSheet: View {
    let cells: [MandalaCell]
    let selectedTaskIndex: Int?
    let onSelect: (MandalaCell?) -> Void

    @State private var expandedSubGoalIndex: Int?
    @State private var selectedIndex: Int?
    private let accentColor = MandalaPalette.warmBeige
    private let secondaryTextColor = MandalaPalette.cocoaText

    var body: some View {
        VStack(spacing: 12) {
            Text("연결할 목표 선택")
                .font(.headline)

            ScrollView { contentList }

            Button {
                onSelect(nil)
            } label: {
                Text("연결 해제")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(MandalaPalette.warmBeige)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button {
                if let selectedIndex,
                   let selectedCell = cells.first(where: { $0.index == selectedIndex }) {
                    onSelect(selectedCell)
                }
            } label: {
                Text("확인")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedIndex == nil ? MandalaPalette.warmBeige.opacity(0.4) : MandalaPalette.warmBeige)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(selectedIndex == nil)
        }
        .padding(16)
        .onAppear {
            selectedIndex = selectedTaskIndex
            if let selectedIndex,
               let subGoal = parentSubGoal(for: selectedIndex) {
                expandedSubGoalIndex = subGoal.index
            }
        }
    }
}

private extension LinkMandalaCellSheet {
    var contentList: some View {
        VStack(spacing: 12) {
            ForEach(coreSubGoals.filter { !tasksForSubGoal($0).isEmpty }, id: \.index) { subGoal in
                subGoalSection(subGoal)
            }
        }
        .padding(.horizontal, 12)
    }

    func subGoalSection(_ subGoal: MandalaCell) -> some View {
        VStack(spacing: 8) {
            subGoalHeader(subGoal)

            if expandedSubGoalIndex == subGoal.index {
                taskPickerList(for: subGoal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    func subGoalHeader(_ subGoal: MandalaCell) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                expandedSubGoalIndex = expandedSubGoalIndex == subGoal.index ? nil : subGoal.index
            }
        } label: {
            HStack {
                Text(subGoalTitle(for: subGoal))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(secondaryTextColor)
                Spacer()
                Image(systemName: expandedSubGoalIndex == subGoal.index ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: MandalaPalette.cellShadow.opacity(0.12), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func taskPickerList(for subGoal: MandalaCell) -> some View {
        let tasks = tasksForSubGoal(subGoal)
        if !tasks.isEmpty {
            VStack(spacing: 8) {
                ForEach(tasks, id: \.index) { task in
                    taskRow(task)
                }
            }
        }
    }

    func taskRow(_ task: MandalaCell) -> some View {
        Button {
            selectedIndex = task.index
        } label: {
            HStack {
                Image(systemName: selectedIndex == task.index ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selectedIndex == task.index ? accentColor : secondaryTextColor.opacity(0.6))
                Text(task.text)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: MandalaPalette.cellShadow.opacity(0.12), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

private extension LinkMandalaCellSheet {
    var coreSubGoals: [MandalaCell] {
        cells
            .filter { $0.role == .subGoal && MandalaRule.coreSubGoalIndices.contains($0.index) }
            .sorted { $0.index < $1.index }
    }

    func subGoalTitle(for cell: MandalaCell) -> String {
        let trimmed = cell.text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "서브 목표" : trimmed
    }

    func tasksForSubGoal(_ subGoal: MandalaCell) -> [MandalaCell] {
        guard let mirroredIndex = MandalaRule.subGoalMirrorMap[subGoal.index] else { return [] }
        let centerRow = mirroredIndex / 9
        let centerCol = mirroredIndex % 9
        let startRow = (centerRow / 3) * 3
        let startCol = (centerCol / 3) * 3
        let indices = (startRow..<(startRow + 3)).flatMap { rowIndex in
            (startCol..<(startCol + 3)).map { columnIndex in rowIndex * 9 + columnIndex }
        }
        return indices
            .filter { $0 != mirroredIndex }
            .compactMap { idx in cells.first(where: { $0.index == idx }) }
            .filter { $0.role == .task }
            .filter { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    func parentSubGoal(for taskIndex: Int) -> MandalaCell? {
        let row = taskIndex / 9
        let col = taskIndex % 9
        let centerRow = (row / 3) * 3 + 1
        let centerCol = (col / 3) * 3 + 1
        let centerIndex = centerRow * 9 + centerCol
        let coreIndex = MandalaRule.subGoalReverseMap[centerIndex] ?? centerIndex
        return cells.first { $0.index == coreIndex && $0.role == .subGoal }
    }
}
