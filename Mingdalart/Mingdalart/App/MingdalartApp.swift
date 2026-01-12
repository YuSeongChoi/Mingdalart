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
            ContentView()
                .modelContainer(
                    for: [MandalaBoardEntity.self, MandalaCellEntity.self]
                )
        }
    }
}
