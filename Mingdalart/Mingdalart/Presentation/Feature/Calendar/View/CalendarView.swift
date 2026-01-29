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

    private let backgroundColor = MandalaPalette.backgroundCream
    private let accentColor = MandalaPalette.warmBeige
    private let secondaryTextColor = MandalaPalette.cocoaText

    init(viewModel: CalendarViewModel) {
        _viewModel = .init(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text("오늘의 작은 실행 ✅")
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)

                dateScroller
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            taskInput
                .padding(.horizontal, 16)

            taskList

            Spacer()
        }
        .background(backgroundColor)
    }

    private var dateScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(visibleDates, id: \.self) { date in
                    let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                    Button {
                        viewModel.selectDate(date)
                    } label: {
                        VStack(spacing: 4) {
                            Text(date, format: .dateTime.weekday(.short))
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
        }
    }

    private var taskInput: some View {
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

    private var taskList: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.selectedDate, format: .dateTime.month().day())
                    .font(.caption)
                    .foregroundStyle(secondaryTextColor)
                Spacer()
                Text("\(viewModel.tasksForSelectedDate.count)개")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)

            if viewModel.tasksForSelectedDate.isEmpty {
                Text("오늘의 할 일을 적어볼까요?")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.tasksForSelectedDate) { task in
                        Button {
                            viewModel.toggleTask(task)
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(task.isDone ? accentColor : secondaryTextColor.opacity(0.6))
                                Text(task.title)
                                    .font(.subheadline)
                                    .foregroundStyle(secondaryTextColor)
                                    .strikethrough(task.isDone, color: secondaryTextColor.opacity(0.5))
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: MandalaPalette.cellShadow.opacity(0.14), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var visibleDates: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (-7...7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: today)
        }
    }
}
