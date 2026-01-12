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
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(
                    // SwiftData 컨테이너를 앱 전역에 주입한다.
                    for: [MandalaBoardEntity.self, MandalaCellEntity.self]
                )
        }
    }
}
