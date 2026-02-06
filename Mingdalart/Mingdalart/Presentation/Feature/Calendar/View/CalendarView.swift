//
//  CalendarView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/28/26.
//

import SwiftUI

struct CalendarView: View {
    @State private var viewModel: CalendarViewModel
    @State private var newTaskTitle: String = ""
    @State private var dateAnchor: Date
    @State private var visibleDates: [Date]
    @State private var isDatePickerPresented: Bool = false
    @State private var isLinkSheetPresented: Bool = false
    @State private var editingTask: DailyTask?
    @State private var editingText: String = ""
    @State private var linkTargetTask: DailyTask?

    let mandalaCells: [MandalaCell]

    private let backgroundColor = MandalaPalette.backgroundCream
    private let accentColor = MandalaPalette.warmBeige
    private let secondaryTextColor = MandalaPalette.cocoaText

    init(viewModel: CalendarViewModel, mandalaCells: [MandalaCell]) {
        _viewModel = .init(initialValue: viewModel)
        let anchor = Calendar.current.startOfDay(for: viewModel.selectedDate)
        _dateAnchor = .init(initialValue: anchor)
        _visibleDates = .init(initialValue: Self.makeVisibleDates(anchor: anchor))
        self.mandalaCells = mandalaCells
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("오늘의 작은 실행 ✅")
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)

                datePickerRow

                dateScroller
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            summaryRow

            taskInput
                .padding(.horizontal, 16)

            taskList

            Spacer()
        }
        .background(backgroundColor)
        .sheet(isPresented: $isLinkSheetPresented) {
            LinkMandalaCellSheet(
                cells: mandalaCells,
                selectedTaskIndex: linkTargetTask?.linkedMandalaCellIndex ?? viewModel.selectedLinkedMandalaIndex
            ) { selected in
                if let linkTargetTask {
                    viewModel.updateTaskLink(linkTargetTask, linkedIndex: selected?.index)
                } else {
                    viewModel.selectedLinkedMandalaIndex = selected?.index
                }
                self.linkTargetTask = nil
                isLinkSheetPresented = false
            }
        }
        .sheet(item: $editingTask) { task in
            VStack(spacing: 16) {
                Text("할 일 수정")
                    .font(.headline)

                TextField("할 일을 입력하세요", text: $editingText)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Button("저장") {
                    viewModel.updateTaskTitle(task, title: editingText)
                    editingTask = nil
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(16)
            .presentationDetents([.fraction(0.25)])
        }
    }
}

private extension CalendarView {
    var dateScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(visibleDates, id: \.self) { date in
                    let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                    Button {
                        viewModel.selectDate(date)
                    } label: {
                        VStack(spacing: 4) {
                            Text(Self.koreanWeekdayFormatter.string(from: date))
                                .font(.caption2)
                                .foregroundStyle(isSelected ? .white : secondaryTextColor)
                            Text(date, format: .dateTime.day())
                                .font(.caption)
                                .foregroundStyle(isSelected ? .white : secondaryTextColor)
                                .monospacedDigit()
                        }
                        .frame(width: 52, height: 56)
                        .background(isSelected ? accentColor : .white)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .shadow(color: MandalaPalette.cellShadow.opacity(0.14), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
            .animation(.smooth(duration: 0.5), value: visibleDates)
        }
    }

    var datePickerRow: some View {
        HStack {
            Button {
                viewModel.selectDate(Date())
                updateDateAnchor(viewModel.selectedDate)
            } label: {
                Text("오늘")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(accentColor)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                isDatePickerPresented = true
            } label: {
                Text(Self.koreanMonthDateFormatter.string(from: viewModel.selectedDate))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(secondaryTextColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: MandalaPalette.cellShadow.opacity(0.14), radius: 3, x: 0, y: 1)
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $isDatePickerPresented) {
            VStack(spacing: 16) {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { viewModel.selectedDate },
                        set: {
                            viewModel.selectDate($0)
                            updateDateAnchor(viewModel.selectedDate)
                        }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .tint(accentColor)
                .labelsHidden()

                Button("완료") {
                    isDatePickerPresented = false
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .padding(16)
            .presentationDetents([.medium])
        }
    }

    var taskInput: some View {
        HStack(spacing: 8) {
            TextField("오늘의 태스크를 적어주세요", text: $newTaskTitle)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Button {
                viewModel.addTask(title: newTaskTitle)
                newTaskTitle = ""
            } label: {
                Image(systemName: "plus")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(accentColor)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    var taskList: some View {
        let tasks = viewModel.tasksForSelectedDate
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(Self.koreanMonthDayFormatter.string(from: viewModel.selectedDate))
                    .font(.caption)
                    .foregroundStyle(secondaryTextColor)
                Spacer()
                Text("\(tasks.count)개")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            if tasks.isEmpty {
                Text("오늘의 할 일을 적어볼까요?")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(tasks) { task in
                            HStack(spacing: 10) {
                                Button {
                                    viewModel.toggleTask(task)
                                } label: {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(task.isDone ? accentColor : secondaryTextColor.opacity(0.6))
                                }
                                .buttonStyle(.plain)

                                Button {
                                    editingText = task.title
                                    editingTask = task
                                } label: {
                                    Text(task.title)
                                        .font(.subheadline)
                                        .foregroundStyle(secondaryTextColor)
                                        .strikethrough(task.isDone, color: secondaryTextColor.opacity(0.5))
                                }
                                .buttonStyle(.plain)

                                Spacer()

                                if let subGoalTitle = linkedSubGoalTitle(for: task) {
                                    Text(subGoalTitle)
                                        .font(.caption2)
                                        .foregroundStyle(accentColor)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 8)
                                        .background(accentColor.opacity(0.12))
                                        .clipShape(Capsule())
                                }

                                Button {
                                    linkTargetTask = task
                                    isLinkSheetPresented = true
                                } label: {
                                    Image(systemName: "link")
                                        .font(.caption)
                                        .foregroundStyle(secondaryTextColor.opacity(0.8))
                                        .padding(6)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: MandalaPalette.cellShadow.opacity(0.14), radius: 4, x: 0, y: 2)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteTask(task)
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    viewModel.toggleTask(task)
                                } label: {
                                    Label("완료", systemImage: task.isDone ? "arrow.uturn.left.circle" : "checkmark.circle")
                                }
                                .tint(task.isDone ? .gray : accentColor)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                }
                .background(backgroundColor)
                .frame(minHeight: 0)
            }
        }
    }

    var summaryRow: some View {
        HStack(spacing: 8) {
            SummaryChip(title: "오늘 완료", value: "\(viewModel.todayDoneCount)개")
            SummaryChip(title: "연속", value: "\(viewModel.currentStreak)일")
            SummaryChip(title: "이번 주", value: "\(Int(viewModel.weeklyCompletionRate * 100))%")
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.todayDoneCount)
        .animation(.easeInOut(duration: 0.25), value: viewModel.currentStreak)
        .animation(.easeInOut(duration: 0.25), value: viewModel.weeklyCompletionRate)
    }
}

extension CalendarView {
    private static func makeVisibleDates(anchor: Date) -> [Date] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: anchor)
        return (0...14).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: start)
        }
    }

    private func updateDateAnchor(_ date: Date) {
        let anchor = Calendar.current.startOfDay(for: date)
        dateAnchor = anchor
        visibleDates = Self.makeVisibleDates(anchor: anchor)
    }

    private static let koreanMonthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }()

    private static let koreanMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter
    }()

    private static let koreanWeekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEE"
        return formatter
    }()

    private func linkedSubGoalTitle(for task: DailyTask) -> String? {
        guard let linkedIndex = task.linkedMandalaCellIndex else { return nil }
        let centerIndex = blockCenterIndex(for: linkedIndex)
        guard let cell = mandalaCells.first(where: { $0.index == centerIndex }) else { return nil }
        let trimmed = cell.text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "서브 목표" : trimmed
    }

    private func blockCenterIndex(for index: Int) -> Int {
        let row = index / 9
        let col = index % 9
        let centerRow = (row / 3) * 3 + 1
        let centerCol = (col / 3) * 3 + 1
        return centerRow * 9 + centerCol
    }
}
