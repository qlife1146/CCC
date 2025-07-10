//
//  CCCViewModel.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import UIKit

// class CCCViewModel {
class CCCViewModel: ViewModelProtocol {
  // MARK: 클로저 바인딩 - 3. View 모델이 API 요청

  enum Action {
    case fetchCurrency
  }

  // ViewModel이 들고 있는 현 상태
  struct State {
    var result: String? = ""
    var timeLastUpdate: String = ""
    var timeNextUpdate: String = ""
    var isFavorite: Bool = false
    var ratesList: [String: Double] = [:] // [country:rate]
    var ratesKeyList: [String] = [] // key 순서 확정을 위한 배열: 현재는 전체 배열
//    var bookmarkList: [String] = [] // 즐찾을 위한 필터링 배열: 전체 배열-즐찾
    var filteredList: [String] = [] // 검색을 위한 필터링 배열: 현재는 전제 배열의 일부(필터링)
  }

  // 클로저로 바인딩
  private(set) var state = State()
  var didUpdate: ((State) -> Void)?
  // alert 및 오류 확인을 위한 에러 접수
  var didFail: ((Error) -> Void)?

  private let service = CurrencyAPI()

  var action: ((Action) -> Void)? {
    return { [weak self] action in
      switch action {
      case .fetchCurrency:
        self?.fetchCurrencyData()
      }
    }
  }

  var onCurrencyUpdated: (() -> Void)?

  func fetchCurrencyData() {
//    let digit: Double = pow(10, 3)
    service.fetchCurrencies { [weak self] result in
      guard let self = self else {
        return
      }

      switch result {
      case let .success(data):
        // MARK: 클로저 바인딩 - 4. ViewModel이 API 응답을 받고 state를 업데이트

        self.state.result = data.result
        self.state.ratesList = data.rates
        self.state.ratesKeyList = self.state.ratesList.keys.sorted()

        self.state.filteredList = self.state.ratesKeyList

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
    if !searchText.isEmpty {
      // 검색 결과는 searchText에 해당되는 것만 출력
      state.filteredList = state.ratesKeyList.filter {
//        $0.contains(searchText)
        let matchesCode = $0.lowercased().contains(searchText.lowercased())
        let matchesName = CurrencyStruct.countryName[$0]?.contains(searchText) ?? false
        return matchesCode || matchesName
      }
    } else {
      state.filteredList = state.ratesKeyList
    }
  }
}
