//
//  SettingsView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 설정 화면
struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @AppStorage("themeMode") private var themeModeString: String = ThemeMode.system.rawValue
    
    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var themeMode: ThemeMode {
        ThemeMode(rawValue: themeModeString) ?? .system
    }
    
    var body: some View {
        Form {
            // 테마 설정
            Section {
                Picker("테마", selection: Binding(
                    get: { themeMode },
                    set: { newMode in
                        themeModeString = newMode.rawValue
                        viewModel.updateThemeMode(newMode)
                    }
                )) {
                    ForEach(ThemeMode.allCases, id: \.self) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
            } header: {
                Text("화면")
            } footer: {
                Text("앱의 색상 테마를 선택하세요")
            }
            
            // 위치 정보 설정
            Section {
                Toggle(
                    "위치 정보 저장",
                    isOn: Binding(
                        get: { viewModel.settings?.enableLocation ?? false },
                        set: { enabled in
                            viewModel.updateLocationEnabled(enabled)
                        }
                    )
                )
            } header: {
                Text("기록")
            } footer: {
                Text("기록에 위치 정보를 함께 저장합니다")
            }
            
            // 앱 정보
            Section {
                HStack {
                    Text("버전")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("총 기록 수")
                    Spacer()
                    Text("\(viewModel.settings?.totalRecords ?? 0)개")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("정보")
            }
            
            // 에러 메시지
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.loadSettings()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            viewModel: SettingsViewModel(
                getSettingsUseCase: GetSettingsUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                ),
                updateLocationSettingUseCase: UpdateLocationSettingUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                ),
                updateThemeUseCase: UpdateThemeUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                )
            )
        )
    }
}

