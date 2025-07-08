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
    var ratesList: [String: Double] = [:]
    var ratesKeyList: [String] = [] // key 순서 확정을 위한 배열
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
      case .success(let data):
        // MARK: 클로저 바인딩 - 4. ViewModel이 API 응답을 받고 state를 업데이트

        self.state.result = data.result
        self.state.ratesList = data.rates
        self.state.ratesKeyList = self.state.ratesList.keys.sorted()
        

        // MARK: 클로저 바인딩 - 5. ViewModel 클로저 호출(상태 변함 알림)
        
        self.didUpdate?(self.state)
      case .failure(let error):
        print("error: \(error.localizedDescription)")
        self.didFail?(error)
      }
    }
  }
  
  func currency(at index: Int) -> (country: String, rate: Double)? {
    guard index < state.ratesKeyList.count else {
      return nil
    }
    let key = state.ratesKeyList[index]
    let rate = state.ratesList[key] ?? 0
    
    return (key, rate)
  }
  
  func numberOfRates() -> Int {
    return state.ratesKeyList.count
  }
}
