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
    private let container: ModelContainer
    private let environment: AppEnvironment
    
    init() {
        do {
            container = try ModelContainer(for: MandalaBoardEntity.self, MandalaCellEntity.self)
        } catch {
            fatalError("ModelContainer init failed : \(error)")
        }
        let context = ModelContext(container)
        environment = AppEnvironment.live(modelContext: context)
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MandalaViewModel(useCase: environment.mandalUseCase))
        }
        .modelContainer(container)
    }
}
