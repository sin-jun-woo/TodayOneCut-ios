//
//  OpenSourceLicenseView.swift
//  TodayOneCut
//
//  Created by 신준우 on 2/13/26.
//

import SwiftUI

/// 오픈소스 라이선스 화면
struct OpenSourceLicenseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("본 앱은 다음과 같은 오픈소스 라이브러리를 사용하고 있습니다.")
                    .font(.body)
                    .padding(.bottom, 8)
                
                ForEach(libraries, id: \.name) { library in
                    LibraryCard(library: library)
                }
                
                Text("\n각 라이브러리의 라이선스는 위 링크를 통해 확인할 수 있습니다.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle("오픈소스 라이선스")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 오픈소스 라이브러리 정보
struct OpenSourceLibrary: Identifiable {
    let id = UUID()
    let name: String
    let version: String
    let license: String
    let url: String
}

private let libraries: [OpenSourceLibrary] = [
    OpenSourceLibrary(
        name: "SwiftUI",
        version: "5.0+",
        license: "Apple License",
        url: "https://developer.apple.com/xcode/swiftui/"
    ),
    OpenSourceLibrary(
        name: "Core Data",
        version: "iOS 13.0+",
        license: "Apple License",
        url: "https://developer.apple.com/documentation/coredata"
    ),
    OpenSourceLibrary(
        name: "Combine",
        version: "iOS 13.0+",
        license: "Apple License",
        url: "https://developer.apple.com/documentation/combine"
    ),
    OpenSourceLibrary(
        name: "UserNotifications",
        version: "iOS 10.0+",
        license: "Apple License",
        url: "https://developer.apple.com/documentation/usernotifications"
    ),
    OpenSourceLibrary(
        name: "Core Location",
        version: "iOS 4.0+",
        license: "Apple License",
        url: "https://developer.apple.com/documentation/corelocation"
    )
]

/// 라이브러리 카드
struct LibraryCard: View {
    let library: OpenSourceLibrary
    @AppStorage("appTheme") private var appThemeString: String = AppTheme.warmCozy.rawValue
    
    private var themeSurface: Color {
        let appTheme = AppTheme(rawValue: appThemeString) ?? .warmCozy
        return getColorForAppTheme(appTheme).surface
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(library.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("버전: \(library.version)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("라이선스: \(library.license)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(library.url)
                .font(.caption)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(themeSurface)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        OpenSourceLicenseView()
    }
}

