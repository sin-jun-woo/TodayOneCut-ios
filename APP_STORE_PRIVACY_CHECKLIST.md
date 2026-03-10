# App Store Connect 개인정보 설정 체크리스트 (5.1.1 / 5.1.2)

심사 통과를 위해 **App Store Connect**에서 아래를 반드시 설정하세요.

---

## 1. 개인정보 처리방침 URL

- **위치**: App Store Connect → My Apps → TodayOneCut → **App Privacy** (또는 App Information)
- **Privacy Policy URL** 에 아래 주소 입력:
  ```
  https://github.com/sin-jun-woo/TodayOneCut-ios/blob/main/PRIVACY_POLICY.md
  ```
  또는 (raw):
  ```
  https://raw.githubusercontent.com/sin-jun-woo/TodayOneCut-ios/main/PRIVACY_POLICY.md
  ```

---

## 2. App Privacy – 수집 데이터 선언 (5.1.2(i) 필수)

**위치**: App Store Connect → My Apps → TodayOneCut → **App Privacy**

⚠️ **추적(Tracking) 반드시 "아니오"**: 사진·위치를 "추적에 사용"으로 설정하면 심사 거절됩니다. 본 앱은 ATT(App Tracking Transparency)를 사용하지 않으므로, **모든 데이터 유형에서 "이 데이터를 사용하여 사용자를 추적하나요?" = 아니오** 로 설정해야 합니다.

"앱이 수집하는 데이터"에서 **다음 데이터 유형을 추가**하고, 아래와 같이 설정:

| 데이터 유형 | 목적 | 사용자 연결 | **추적 (Used for Tracking)** |
|------------|------|-------------|-------------------------------|
| **사진 또는 비디오** (Photos or Videos) | 앱 기능 (기록 저장) | 연결 안 함 | **반드시 아니오** |
| **위치** (Location) – 정확한 위치 | 앱 기능 (기록에 장소 표시, 선택 사항) | 연결 안 함 | **반드시 아니오** |
| **사용자 콘텐츠** (User Content) | 앱 기능 (텍스트 메모) | 연결 안 함 | **반드시 아니오** |

- **데이터를 수집하는지**: "예, 수집합니다" 선택 후 위 항목 추가
- **각 항목에서 "이 데이터를 사용하여 사용자를 추적하나요?" (Used for Tracking)** → **반드시 "아니오" (No)** 선택. "예"로 되어 있으면 5.1.2(i) 위반으로 거절됩니다.
- **데이터 연결**: "사용자에게 연결되지 않음" (기기 내 저장만 하므로)

---

## 3. 저작권 (Copyright)

- **위치**: App Store Connect → My Apps → TodayOneCut → **App Information**
- **Copyright** 필드 예시:
  ```
  © 2026 Junwoo Shin. All rights reserved.
  ```

---

## 4. 재제출 시 확인 (5.1.2(i) 거절 시)

**"앱이 추적을 위해 데이터를 수집한다"고 표시되어 거절된 경우:**

1. App Store Connect → **App Privacy** 이동
2. **각 데이터 유형**(사진/비디오, 위치, 사용자 콘텐츠)을 열어서  
   **"이 데이터를 사용하여 사용자를 추적하나요?" (Used for Tracking)** 가 **"아니오"** 인지 확인. **"예"로 되어 있으면 반드시 "아니오"로 변경 후 저장**
3. 새 빌드(카메라/사진/위치 권한 문구 수정 반영) Archive → Upload
4. 새 빌드를 버전에 연결 후 **Submit for Review**
5. **심사 노트**에 아래 추가 (선택):
   ```
   Privacy: This app does not track users. All data is stored only on device. No ATT required. App Privacy labels: "Used for Tracking" = No for all data types.
   ```
