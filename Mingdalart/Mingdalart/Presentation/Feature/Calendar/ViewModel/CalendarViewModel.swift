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
    private let useCase: DailyTaskUseCase
    var selectedLinkedMandalaIndex: Int? = nil
    
    var todayDoneCount: Int {
        tasksForSelectedDate.filter { $0.isDone }.count
    }
    
    var currentStreak: Int {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: tasks) { calendar.startOfDay(for: $0.date) }
        
        var streak = 0
        var cursor = calendar.startOfDay(for: Date())
        while true {
            guard let dayTasks = grouped[cursor] else { break }
            if dayTasks.contains(where: { $0.isDone }) {
                streak += 1
                guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
                cursor = prev
            } else {
                break
            }
        }
        return streak
    }
    
    var weeklyCompletionRate: Double {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate)) ?? selectedDate

        var successDays = 0
        for offset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else { continue }
            let dayTasks = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
            if dayTasks.contains(where: { $0.isDone }) {
                successDays += 1
            }
        }
        return Double(successDays) / 7.0
    }

    init(
        useCase: DailyTaskUseCase,
        selectedDate: Date = Date()
    ) {
        self.useCase = useCase
        self.selectedDate = Calendar.current.startOfDay(for: selectedDate)
        self.tasks = useCase.fetchDailyTask()
    }

    var tasksForSelectedDate: [DailyTask] {
        tasks
            .filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.createdAt < $1.createdAt }
    }

    func selectDate(_ date: Date) {
        selectedDate = Calendar.current.startOfDay(for: date)
    }
    
    func reload() {
        tasks = useCase.fetchDailyTask()
    }

    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let newTask = DailyTask(title: trimmed, date: selectedDate, linkedMandalaCellIndex: selectedLinkedMandalaIndex)
        tasks.append(newTask)
        useCase.saveDailyTask(newTask)
    }

    func toggleTask(_ task: DailyTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
        tasks[index].doneAt = tasks[index].isDone ? Date() : nil
        useCase.saveDailyTask(tasks[index])
    }

    func updateTaskTitle(_ task: DailyTask, title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let index = tasks.firstIndex(where: { $0.id == task.id })
        else { return }
        tasks[index].title = trimmed
        useCase.saveDailyTask(tasks[index])
    }

    func updateTaskLink(_ task: DailyTask, linkedIndex: Int?) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].linkedMandalaCellIndex = linkedIndex
        useCase.saveDailyTask(tasks[index])
    }
}
