//
//  CalendarView 2.swift
//  DayZero
//
//  Created by ufian on 12/16/24.
//


import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        DatePicker(
            "",
            selection: $selectedDate,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .focusable(false)
        .background(Color.clear)
    }
}
