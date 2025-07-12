//
//  CCCViewModel.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import UIKit

// class CCCViewModel {
enum ChangeType {
  case up, down, same, none
}

class CCCViewModel: ViewModelProtocol {
  // MARK: 클로저 바인딩 - 3. View 모델이 API 요청

  enum Action {
    case fetchCurrency
  }


  // ViewModel이 들고 있는 현 상태
  struct State {
    // var result: String? = ""
    // var timeNextUpdate: String = ""
    var isFavorite: Bool = false
    var ratesList: [String: Double] = [:] // [country:rate]
    var ratesKeyList: [String] = [] // key 순서 확정을 위한 배열(sorted): 현재는 전체 배열
    var filteredList: [String] = [] // 검색을 위한 필터링 배열: 현재는 전제 배열의 일부(필터링)
    var timeLastUpdate: String = "" // 저장 업데이트 날짜
    var lastUpdateTime: String = "" // 최근 업데이트 날짜
  }

  // 클로저로 바인딩
  private(set) var state = State()
  private var lastRatesList: [String: Double] = [:]

  var didUpdate: ((State) -> Void)?
  // alert 및 오류 확인을 위한 에러 접수
  var didFail: ((Error) -> Void)?
  var currentSearchText: String? = nil

  private let service = CurrencyAPI()

  var action: ((Action) -> Void)? {
    return { [weak self] action in
      switch action {
      case .fetchCurrency:
        self?.fetchCurrencyData()
      }
    }
  }

  func fetchCurrencyData() {
    service.fetchCurrencies { [weak self] result in
      guard let self = self else { return }

      switch result {
      case let .success(data):
        // MARK: 클로저 바인딩 - 4. ViewModel이 API 응답을 받고 state를 업데이트

        self.state.ratesList = data.rates
        self.state.ratesKeyList = self.state.ratesList.keys.sorted()
        self.updateFavoriteState()

        if self.state.timeLastUpdate != data.timeLastUpdate { // 업데이트 날짜를 비교하고 변화가 있으면 이전 값 저장
          self.lastRatesList = self.state.ratesList // 이전 데이터 저장
          self.state.lastUpdateTime = self.state.timeLastUpdate
          self.state.timeLastUpdate = data.timeLastUpdate // 이건 가져온 것을 그대로 써서 data.--
        }

        // MARK: 클로저 바인딩 - 5. ViewModel 클로저 호출(상태 변함 알림)
        self.didUpdate?(self.state)
      case let .failure(error):
        print("error: \(error.localizedDescription)")
        self.didFail?(error)
      }
    }
  }

  func currency(at index: Int) -> (country: String, rate: Double)? {
    guard index < state.filteredList.count else {
      return nil
    }

    let key = state.filteredList[index]
    let rate = state.ratesList[key] ?? 0

    return (key, rate)
  }

  func numberOfRates() -> Int {
//    return state.ratesKeyList.count
    return state.filteredList.count
  }

  func search(searchText: String) {
    // searchText가 비어있지 않으면
    currentSearchText = searchText
    updateFavoriteState()
  }

  func sortedRatesKeys() -> [String] {
    let favCodes = CoreDataManager.shared.fetchAllFavorites()
    return state.ratesKeyList.sorted { lhs, rhs in
      let lhsIsFav = favCodes.contains(lhs)
      let rhsIsFav = favCodes.contains(rhs)
      if lhsIsFav && !rhsIsFav { return true }
      if !lhsIsFav && rhsIsFav { return false }
      return lhs < rhs
    }
  }

  func updateFavoriteState() {
    // 모든 즐찾 불러와 favCodes에 담기
    let favCodes = CoreDataManager.shared.fetchAllFavorites()

    if let searchText = currentSearchText, !searchText.isEmpty {
      // 검색어 필터링
      let filteredCodes = state.ratesKeyList.filter {
        let matchesCode = $0.lowercased().contains(searchText.lowercased())
        let matchesName = CurrencyStruct.countryName[$0]?.contains(searchText) ?? false
        return matchesCode || matchesName
      }

      // 즐겨찾기 우선 검색 결과
      state.filteredList = filteredCodes.sorted { lhs, rhs in
        let lhsIsFav = favCodes.contains(lhs)
        let rhsIsFav = favCodes.contains(rhs)
        if lhsIsFav && !rhsIsFav { return true }
        if !lhsIsFav && rhsIsFav { return false }
        return lhs < rhs
      }
    } else {
      // 검색 키워드 없으면 즐겨찾기 우선 정렬
      state.filteredList = state.ratesKeyList.sorted { lhs, rhs in
        let lhsIsFav = favCodes.contains(lhs)
        let rhsIsFav = favCodes.contains(rhs)
        if lhsIsFav && !rhsIsFav { return true }
        if !lhsIsFav && rhsIsFav { return false }
        return lhs < rhs
      }
    }
    didUpdate?(state)
  }

  func rateChange(for code: String) -> ChangeType {
    guard let last = lastRatesList[code], let now = state.ratesList[code] else { return .none }
    if now > last { return .up}
    if now < last { return .down}
    return .same
  }
}
