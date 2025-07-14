//
//  ViewController.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import CoreData
import SnapKit
import UIKit

// Compact Currency Calculator
// [↓↓환율 스택↓↓↓]
// [--환율 정보---]
// [-통화 검색 바-]
// [↓↓↓테이블뷰↓↓↓]
// [국명|환율|즐찾]

class CCCViewController: UIViewController {
  var container: NSPersistentContainer!

  private let viewModel = CCCViewModel()

  private let titleLabel = UILabel()
  private let searchBar = UISearchBar()
  private let mainStackView = UIStackView()
  private lazy var tableView = UITableView()

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    CoreDataManager.shared.saveLastScreen(screen: "Main", param: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel() // 클로저 바인딩(갱신)
    setupUI() // UI설정
    viewModel.loadLastRatesOrMock()

    // MARK: 클로저 바인딩 - 2. ViewController에서 ViewModel에게 action 전송

    viewModel.action?(.fetchCurrency)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.viewModel.setTestLastRates([
        "AED": 2000,
        "KRW": 1000
      ])
      self.tableView.reloadData()
    } // 잘 갖고와지는지 테스트
    //    let service = CurrencyAPI()
    //    service.apiTest()
  }

  // MARK: 클로저 바인딩 - 1. ViewController에서 ViewModel 생성 후 바인딩 설정

  private func bindViewModel() {
    // (state 바뀔 때 UI 갱신되도록 클로저 바인딩)
    // viewModel.didUpdate = { [weak self] _ in
    viewModel.didUpdate = { [weak self] state in
      guard let self else { return }

      DispatchQueue.main.async {
        if let last = CoreDataManager.shared.fetchLastScreen(),
           last.screen == "CalculatorController",
           let country = last.param,
           let rate = state.ratesList[country]
        {
          let calcVC = CalculatorController()
          calcVC.currency = (country: country, rate: rate)

          if !(self.navigationController?.topViewController is CalculatorController) {
            self.navigationController?.pushViewController(calcVC, animated: false)
          }
        }
        print("last: \(state.lastUpdateTime)")
        print("time: \(state.timeLastUpdate)")
        self.tableView.reloadData()
      }
    }
    viewModel.didFail = { [weak self] _ in
      DispatchQueue.main.async {
        // 데이터 로드 실패 처리
        let alert = UIAlertController(title: "오류", message: "데이터를 불러올 수 없습니다.", preferredStyle: .alert)
        // 확인을 누르면 앱 종료
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
          exit(0)
        })
        self?.present(alert, animated: true)
      }
    }
  }

  private func setupUI() {
    view.backgroundColor = UIColor(named: "BackgroundColor")

    titleLabel.text = "환율 정보"
    titleLabel.textColor = UIColor(named: "TextColor")
    titleLabel.font = Default.mainTitleFont

    searchBar.searchBarStyle = .minimal
    searchBar.placeholder = "통화 검색"
    searchBar.delegate = self

    tableView.backgroundColor = UIColor(named: "BackgroundColor")
    tableView.showsVerticalScrollIndicator = false

    // MARK: tableView 기본 요소

    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)

    for item in [titleLabel, searchBar, tableView] {
      view.addSubview(item)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
    }

    searchBar.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension CCCViewController: UITableViewDataSource {
  // 섹션 1개에 나타낼 Row(줄) 개수, count 등
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    let count = viewModel.numberOfRates()

    if count == 0 {
      tableView.setEmptyLabel("검색 결과가 없습니다.")
    } else {
      tableView.restore()
    }
    return count
//    return viewModel.numberOfRates()
  }

  // 재사용할 셀이 넣을 것
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
      return UITableViewCell()
    }

    if let currency = viewModel.currency(at: indexPath.row) {
      let isFavorite = CoreDataManager.shared.isFavorite(code: currency.country)
      let change = viewModel.rateChange(for: currency.country)
      cell.configureCell(country: currency.country, rate: currency.rate, isFavorite: isFavorite, change: change)
      // closure 넘기기
      cell.favorite = { [weak self] in
        let code = currency.country

        if isFavorite {
          CoreDataManager.shared.removeFavorite(code: code)
        } else {
          CoreDataManager.shared.addFavorite(code: code)
        }
        self?.viewModel.updateFavoriteState()
      }
    } else {
      print("xxxx")
    }
    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedCurrency = viewModel.currency(at: indexPath.row) else { return }

    let calculatorVC = CalculatorController()
    let backNavBarButton = UIBarButtonItem(title: "환율 정보", style: .plain, target: self, action: nil)
    navigationItem.backBarButtonItem = backNavBarButton
    calculatorVC.currency = selectedCurrency

    // coredata 저장(현재 페이지 클래스, 국가 코드)
    CoreDataManager.shared.saveLastScreen(screen: "CalculatorController", param: selectedCurrency.country)

    navigationController?.pushViewController(calculatorVC, animated: true)
  }
}

// 스와이프 즐찾: 써보고 싶어서 AI 도움 받아서 추가함
extension CCCViewController: UITableViewDelegate {
  // 해당 셀(indexPath)에 대한 스와이프 액션들을 리턴
  func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    // ViewModel에서 현재 row의 환율 데이터를 가져옴, 데이터 없으면 액션을 표시하지 않음(return nil)
    guard let currency = viewModel.currency(at: indexPath.row) else { return nil }

    let code = currency.country // 현재 통화 코드
    let isFavorite = CoreDataManager.shared.isFavorite(code: code) // CoreData에서 해당 통화 코드가 즐찾 상태인지 확인

    // 즐찾 상태에 따라 달리 표기, 근데 아이콘과 글자 동시에 작동 안 함
    // let title = isFavorite ? "고정 해제" : "고정"
    let starImage = isFavorite ? UIImage(systemName: "star.slash") : UIImage(systemName: "star.fill")
    let favoriteAction = UIContextualAction(style: .normal, title: title) { [weak self] _, _, completion in
      // 파라미터 두 개는 거의 안 씀.
      if isFavorite {
        CoreDataManager.shared.removeFavorite(code: code)
      } else {
        CoreDataManager.shared.addFavorite(code: code)
      }
      self?.viewModel.updateFavoriteState() // 즐겨찾기 상태 업데이트
      completion(true) // 필수 호출: 액션 끝났음을 의미. true: 버튼 닫힘, false: 버튼 유지
    }
    favoriteAction.image = starImage
    favoriteAction.backgroundColor = UIColor(named: "FavoriteColor")

    // 위 기능들을 꼭꼭 눌러 담아 cell로 리턴
    return UISwipeActionsConfiguration(actions: [favoriteAction])
  }
}

extension CCCViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
    guard let text = searchBar.text else { return }

    viewModel.search(searchText: text)
    tableView.reloadData()
  }
}

extension UITableView {
  func setEmptyLabel(_ message: String) {
    let messageLabel = UILabel()
    messageLabel.text = message
    messageLabel.textColor = UIColor(named: "SecondaryTextColor")
    messageLabel.textAlignment = .center
    messageLabel.font = Default.subTextFont
    messageLabel.numberOfLines = 0
    messageLabel.translatesAutoresizingMaskIntoConstraints = false

    backgroundView = messageLabel
    separatorStyle = .none
  }

  func restore() {
    backgroundView = nil
    separatorStyle = .singleLine
  }
}
