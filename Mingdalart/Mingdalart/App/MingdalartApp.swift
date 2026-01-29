//
//  MingdalartApp.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/7/26.
//

import SwiftUI
import SwiftData

@main
struct MingdalartApp: App {
    private let container: ModelContainer?
    private let environment: AppEnvironment?
    private let initializationErrorMessage: String?
    
    init() {
        // 폰트 등록
        do {
            try MingdalartFont.register()
        } catch {
            print("폰트 등록 실패: \(error.localizedDescription)")
        }
        
        // SwiftData 등록
        do {
            let container = try ModelContainer(for: MandalaBoardEntity.self, MandalaCellEntity.self, DailyTaskEntity.self)
            self.container = container
            let context = ModelContext(container)
            environment = AppEnvironment.live(modelContext: context)
            initializationErrorMessage = nil
        } catch {
            print("ModelContainer init failed: \(error)")
            self.container = nil
            environment = nil
            initializationErrorMessage = "데이터를 불러오는 데 실패했어요.\n앱을 다시 실행해 주세요."
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if let container, let environment {
                MainTabView(
                    mandalaViewModel: MandalaViewModel(useCase: environment.mandalUseCase),
                    calendarViewModel: CalendarViewModel(useCase: environment.dailyTaskUseCase)
                )
                .modelContainer(container)
            } else {
                ErrorView(message: initializationErrorMessage)
            }
        }
    }
}

private struct ErrorView: View {
    let message: String?

    var body: some View {
        ZStack {
            MandalaPalette.backgroundCream
                .ignoresSafeArea()

            VStack {
                VStack(spacing: 8) {
                    Text("앗, 문제가 생겼어요")
                        .font(.headline)
                        .foregroundStyle(MandalaPalette.cocoaText)

                    Text(message ?? "데이터를 불러오는 데 실패했어요.\n앱을 다시 실행해 주세요.")
                        .font(.subheadline)
                        .foregroundStyle(MandalaPalette.cocoaText.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: MandalaPalette.cellShadow.opacity(0.18), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 24)
            }
        }
    }
}
