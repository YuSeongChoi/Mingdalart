//
//  CalendarViewModel.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/28/26.
//

import Foundation

@Observable
@MainActor
final class CalendarViewModel {
    var selectedDate: Date
    private(set) var tasks: [DailyTask]

    init(
        selectedDate: Date = Date(),
        tasks: [DailyTask] = []
    ) {
        self.selectedDate = Calendar.current.startOfDay(for: selectedDate)
        self.tasks = tasks
    }

    var tasksForSelectedDate: [DailyTask] {
        tasks
            .filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.createdAt < $1.createdAt }
    }

    func selectDate(_ date: Date) {
        selectedDate = Calendar.current.startOfDay(for: date)
    }

    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let newTask = DailyTask(title: trimmed, date: selectedDate)
        tasks.append(newTask)
    }

    func toggleTask(_ task: DailyTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
        tasks[index].doneAt = tasks[index].isDone ? Date() : nil
    }
}
