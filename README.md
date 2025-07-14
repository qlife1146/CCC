# Comapact Currency Calculator

- 필수 과제
- [x] 1: 메인 UI 기초 작업 + 데이터 불러오기
- [x] 2: 메인 화면 구성
- [x] 3: 필터링 기능 구현
- [x] 4: 환율 계산기로 이동
- [x] 5: 입력한 금액 실시간 반영
- [ ] 6: MVVM 패턴 도입(View와 로직 분리)
- [x] 7: 즐겨찾기 기능 상단 고정
- [ ] 8: 상승/하락 표시(미확인)
- [x] 9: 다크모드 지원
- [x] 10: 앱 상태 저장 및 복원
- 도전 과제
- [ ] 11: 메모리 분석
- [ ] 12: Clean Architecture 적용
----
- 메인 화면: UISearchBar, 환율을 담은 UITableView(국가명 회색은 코드 상으로 픽스함)
<img src="https://github.com/user-attachments/assets/11413e89-6f22-47e4-b3da-9183f2a2fbb7" height="500"/>

- 검색 기능 시연(국가 코드 및 국가명 검색)
<img height="500" alt="simulator_screenshot_7F9F7B8D-C4DD-4E1E-8CBA-AE7E2D4E731C" src="https://github.com/user-attachments/assets/c911fb0e-7295-4e79-93a3-b64ad657454e" />
<img height="500" alt="simulator_screenshot_869CD793-D46B-4554-B59D-59CA45E4B4A6" src="https://github.com/user-attachments/assets/fa210eba-c72a-481b-a0e8-a6b9870c1aa2" />

- 환율 계산기 화면: 숫자를 적을 수 있는 UITextFiled, 누르면 계산을 하는 UIButton, 결과를 보여주는 UILabel
<img height="500" alt="simulator_screenshot_D7B28098-8F68-4BB9-98FB-02021B55873E" src="https://github.com/user-attachments/assets/f786982a-b1b0-4455-9389-cf4965d1c716" />

- 숫자를 넣고 버튼을 누른 결과 화면(추가로 searchBar처럼 작성 중일 때 텍스트를 지울 수 있는 버튼 활성화)
<img height="500" alt="simulator_screenshot_36875530-0889-48A5-9C40-230935BC8A04" src="https://github.com/user-attachments/assets/460ee2d5-93d6-4e58-904d-b452e84939bc" />

- 이상한 숫자 혹은 빈 상태일 때 예외 처리
<img height="500" alt="simulator_screenshot_E86DF8E1-0AAD-4933-8796-CBD8EB32CAA0" src="https://github.com/user-attachments/assets/722d1569-274a-40e3-b0a0-1a3fd987c6cf" />
<img height="500" alt="simulator_screenshot_9513E54B-84A2-4B81-934D-39A93AB76368" src="https://github.com/user-attachments/assets/efbbe45d-cb60-47a9-9225-a87b60861bb2" />

- 즐겨찾기(상단 고정): 검색 때도 적용
<img height="500" alt="simulator_screenshot_5EA74BF5-D6A2-4886-BE6A-D17AF224579F" src="https://github.com/user-attachments/assets/3bff96f6-b61b-4a85-ab8e-2c17371d158f" />
<img height="500" alt="simulator_screenshot_C84E2490-BA7C-43DD-8C9F-5C6F7CE0C2DE" src="https://github.com/user-attachments/assets/61414a58-bb71-4e28-b7fd-f2084133dbe9" />
<img height="500" alt="simulator_screenshot_578F3EB4-17F8-4BD6-B6C2-8F1449A54751" src="https://github.com/user-attachments/assets/5737aadc-b924-40b1-bb8e-5257169edf9f" />

- 다크모드
<img height="500" alt="simulator_screenshot_7E233576-99FF-4A09-A7DD-487E8AAC4321" src="https://github.com/user-attachments/assets/e9b1842f-7aa2-43bd-bf0a-46dce60a4c62" />
<img height="500" alt="simulator_screenshot_8C91A0AC-1F0B-4F9B-BD05-0723851E4A01" src="https://github.com/user-attachments/assets/b8eeb24a-9809-4ae3-a643-97946af987f5" />

- 앱 상태 저장/복원
<img height="500" src="https://github-production-user-asset-6210df.s3.amazonaws.com/32091837/465820012-e631278e-62be-433e-ab29-018278a0b004.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20250714%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250714T025043Z&X-Amz-Expires=300&X-Amz-Signature=3e62ed3c991f13ba0d3d2abfb589259e74e9a9588327f7fa1c9419ef364396c6&X-Amz-SignedHeaders=host" />
