//
//  MainTabView.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/28/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var mandalaViewModel: MandalaViewModel
    @State private var calendarViewModel: CalendarViewModel

    init(mandalaViewModel: MandalaViewModel, calendarViewModel: CalendarViewModel) {
        _mandalaViewModel = .init(initialValue: mandalaViewModel)
        _calendarViewModel = .init(initialValue: calendarViewModel)
    }

    var body: some View {
        TabView {
            MandalaView(viewModel: mandalaViewModel)
                .tabItem {
                    Label("만다라트", systemImage: "square.grid.3x3.fill")
                }

            CalendarView(viewModel: calendarViewModel)
                .tabItem {
                    Label("캘린더", systemImage: "calendar")
                }
        }
        .tint(MandalaPalette.warmBeige)
    }
}
