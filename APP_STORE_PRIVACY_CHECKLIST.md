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

## 2. App Privacy – 수집 데이터 선언

**위치**: App Store Connect → My Apps → TodayOneCut → **App Privacy**

"앱이 수집하는 데이터"에서 **다음 데이터 유형을 추가**하고, 아래와 같이 설정:

| 데이터 유형 | 목적 | 사용자 연결 | 추적 |
|------------|------|-------------|------|
| **사진 또는 비디오** (Photos or Videos) | 앱 기능 (기록 저장) | 연결 안 함 | 아니오 |
| **위치** (Location) | 앱 기능 (기록에 위치 표시, 선택 사항) | 연결 안 함 | 아니오 |
| **사용자 콘텐츠** (User Content) | 앱 기능 (텍스트 메모) | 연결 안 함 | 아니오 |

- **데이터를 수집하는지**: "예, 수집합니다" 선택 후 위 항목 추가
- 각 항목: **"이 데이터를 사용하여 사용자를 추적하나요?"** → **아니오**
- **데이터 연결**: "사용자에게 연결되지 않음" (기기 내 저장만 하므로)

---

## 3. 저작권 (Copyright)

- **위치**: App Store Connect → My Apps → TodayOneCut → **App Information**
- **Copyright** 필드 예시:
  ```
  © 2026 Junwoo Shin. All rights reserved.
  ```

---

## 4. 재제출 시 확인

1. 새 빌드(1.5.1 (6)) Archive 후 Upload
2. App Privacy 에서 위 URL + 데이터 유형 설정 저장
3. Copyright 저장
4. **Submit for Review** 시 "심사 노트"에 아래 한 줄 추가 (선택):
   ```
   Privacy: All data is stored only on device. No server transmission or third-party sharing. See PRIVACY_POLICY.md.
   ```
