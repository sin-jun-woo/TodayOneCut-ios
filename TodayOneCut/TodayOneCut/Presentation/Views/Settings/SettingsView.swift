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
    @AppStorage("appTheme") private var appThemeString: String = AppTheme.warmCozy.rawValue
    @AppStorage("fontFamily") private var fontFamilyString: String = AppFont.systemSerif.rawValue
    
    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private var themeMode: ThemeMode {
        ThemeMode(rawValue: themeModeString) ?? .system
    }
    
    private var appTheme: AppTheme {
        AppTheme(rawValue: appThemeString) ?? .warmCozy
    }
    
    private var fontFamily: AppFont {
        AppFont(rawValue: fontFamilyString) ?? .systemSerif
    }
    
    var body: some View {
        Form {
            // 기록 설정
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
                
                Toggle(
                    "부드러운 알림",
                    isOn: Binding(
                        get: { viewModel.settings?.enableNotification ?? false },
                        set: { enabled in
                            viewModel.updateNotificationEnabled(enabled)
                        }
                    )
                )
            } header: {
                Text("기록 설정")
            } footer: {
                Text("위치 정보 저장: 기록에 위치 정보를 함께 저장합니다\n부드러운 알림: 매일 오후 9시에 오늘 기록이 없을 때 알림을 받습니다")
            }
            
            // 화면 설정
            Section {
                Button {
                    viewModel.showThemeSelector = true
                } label: {
                    HStack {
                        Text("테마")
                        Spacer()
                        Text(themeMode.displayName)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button {
                    viewModel.showAppThemeSelector = true
                } label: {
                    HStack {
                        Text("앱 테마 설정")
                        Spacer()
                        Text(appTheme.displayName)
                            .foregroundColor(.secondary)
                    }
                }
                
                Button {
                    viewModel.showFontSelector = true
                } label: {
                    HStack {
                        Text("폰트 선택")
                        Spacer()
                        Text(fontFamily.displayName)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("화면 설정")
            }
            
            // 데이터
            Section {
                Button {
                    // TODO: 백업 화면으로 이동
                } label: {
                    HStack {
                        Text("백업 및 복원")
                        Spacer()
                        Text("(추후 지원 예정)")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                .disabled(true)
                
                Button {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    HStack {
                        Text("모든 데이터 삭제")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            } header: {
                Text("데이터")
            } footer: {
                Text("모든 기록과 설정이 삭제되며 되돌릴 수 없습니다")
            }
            
            // 정보
            Section {
                HStack {
                    Text("버전")
                    Spacer()
                    Text(Bundle.main.appVersion)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("총 기록 수")
                    Spacer()
                    Text("\(viewModel.settings?.totalRecords ?? 0)개")
                        .foregroundColor(.secondary)
                }
                
                NavigationLink(value: AppRoute.privacyPolicy) {
                    Text("개인정보 처리방침")
                }
                
                NavigationLink(value: AppRoute.openSourceLicense) {
                    Text("오픈소스 라이선스")
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
        .sheet(isPresented: $viewModel.showThemeSelector) {
            ThemeSelectorView(
                currentTheme: themeMode,
                onThemeSelected: { mode in
                    themeModeString = mode.rawValue
                    viewModel.updateThemeMode(mode)
                    viewModel.showThemeSelector = false
                },
                onDismiss: {
                    viewModel.showThemeSelector = false
                }
            )
        }
        .sheet(isPresented: $viewModel.showAppThemeSelector) {
            AppThemeSelectorView(
                currentTheme: appTheme,
                onThemeSelected: { theme in
                    appThemeString = theme.rawValue
                    viewModel.updateAppTheme(theme)
                    viewModel.showAppThemeSelector = false
                },
                onDismiss: {
                    viewModel.showAppThemeSelector = false
                }
            )
        }
        .sheet(isPresented: $viewModel.showFontSelector) {
            FontSelectorView(
                currentFont: fontFamily,
                onFontSelected: { font in
                    fontFamilyString = font.rawValue
                    viewModel.updateFontFamily(font)
                    viewModel.showFontSelector = false
                },
                onDismiss: {
                    viewModel.showFontSelector = false
                }
            )
        }
        .alert("모든 데이터 삭제", isPresented: $viewModel.showDeleteConfirmation) {
            Button("취소", role: .cancel) {
                viewModel.showDeleteConfirmation = false
            }
            Button("삭제", role: .destructive) {
                viewModel.deleteAllData()
                viewModel.showDeleteConfirmation = false
            }
        } message: {
            Text("정말로 모든 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.")
        }
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
                ),
                updateNotificationSettingUseCase: UpdateNotificationSettingUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                ),
                updateAppThemeUseCase: UpdateAppThemeUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                ),
                updateFontFamilyUseCase: UpdateFontFamilyUseCase(
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    )
                ),
                deleteAllDataUseCase: DeleteAllDataUseCase(
                    recordRepository: RecordRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        recordMapper: RecordMapper()
                    ),
                    settingsRepository: SettingsRepositoryImpl(
                        coreDataStack: CoreDataStack.shared,
                        settingsMapper: SettingsMapper()
                    ),
                    fileRepository: FileRepositoryImpl()
                )
            )
        )
    }
}

