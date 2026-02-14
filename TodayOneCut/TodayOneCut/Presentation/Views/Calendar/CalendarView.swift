//
//  CalendarView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 달력 화면
struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel
    @State private var currentMonth: Date = Date()
    
    init(viewModel: CalendarViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 달력
            CalendarViewComponent(
                currentMonth: $currentMonth,
                selectedDate: $viewModel.selectedDate,
                recordDates: viewModel.recordDates,
                onDateSelected: { date in
                    viewModel.selectDate(date)
                }
            )
            .padding()
            
            Divider()
            
            // 선택된 날짜의 기록
            if let record = viewModel.selectedDateRecord {
                ScrollView {
                    RecordCard(record: record) {
                        // 상세 화면으로 이동
                    }
                    .padding()
                }
            } else {
                EmptyStateView(
                    message: "이 날짜에는 기록이 없어요",
                    actionText: nil,
                    action: nil
                )
            }
        }
        .navigationTitle("달력")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.loadRecordsForMonth(currentMonth)
        }
        .onChange(of: currentMonth) { newMonth in
            viewModel.loadRecordsForMonth(newMonth)
        }
    }
}

/// 달력 컴포넌트
struct CalendarViewComponent: View {
    @Binding var currentMonth: Date
    @Binding var selectedDate: Date
    let recordDates: Set<Date>
    let onDateSelected: (Date) -> Void
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 16) {
            // 월 네비게이션
            HStack {
                Button {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(dateFormatter.string(from: currentMonth))
                    .font(.headline)
                
                Spacer()
                
                Button {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            
            // 요일 헤더
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 날짜 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasRecord: recordDates.contains { calendar.isDate($0, inSameDayAs: date) },
                            isToday: calendar.isDateInToday(date),
                            isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                        ) {
                            onDateSelected(date)
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let firstDay = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                days.append(date)
            }
        }
        
        return days
    }
}

/// 날짜 뷰
struct DayView: View {
    let date: Date
    let isSelected: Bool
    let hasRecord: Bool
    let isToday: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: date))
                    .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday ? .blue :
                        isCurrentMonth ? .primary : .secondary
                    )
                
                if hasRecord {
                    Circle()
                        .fill(isSelected ? .white : .blue)
                        .frame(width: 6, height: 6)
                }
            }
            .frame(width: 40, height: 40)
            .background(
                isSelected ? Color.blue : Color.clear
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        CalendarView(
            viewModel: CalendarViewModel(
                getMonthRecordsUseCase: GetMonthRecordsUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                ),
                getRecordDatesUseCase: GetRecordDatesUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                ),
                getRecordByDateUseCase: GetTodayRecordUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    )
                ),
                recordRepository: RecordRepositoryImpl(
                    coreDataStack: CoreDataStack.shared,
                    recordMapper: RecordMapper()
                )
            )
        )
    }
}

