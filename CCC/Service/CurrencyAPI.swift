//
//  CurrencyAPIService.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import Alamofire
import UIKit

class CurrencyAPI {
}
func fetchCurrencies(completion: @escaping (CurrencyStruct?) -> Void) {
  // 1. URLComponents로 URL과 쿼리 조합
  let urlComponents = URLComponents(string: "https://open.er-api.com/v6/latest/USD")
  //    urlComponents?.queryItems = [URLQueryItem(name: "base", value: "USD")]
  // 그런데 일단 쿼리 필요 없으니 이번에는 제외

  // 2. 완성된 URL 가져오기
  guard let url = urlComponents?.url else {
    print("URL creation failed")
    completion(nil)
    return
  }

  // 3. AF로 요청 보내기
  AF.request(url)
    .validate()
    .responseDecodable(of: CurrencyStruct.self) { res in
      switch res.result {
      case .success(let result):
        completion(result)
      case .failure(let error):
        print("\(error)")
      }
    }
}

func apiTest() {
    let service = CurrencyAPI()
    service.fetchCurrencies { result in
      if let result {
        print("USD → KRW: \(result.rates["KRW"] ?? 0)")
      } else {
        print("환율 정보를 가져오지 못했습니다.")
      }
    }
}
