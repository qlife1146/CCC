//
//  ViewController.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import SnapKit
import UIKit
import CoreData

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

  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel() // 클로저 바인딩(갱신)
    setupUI() // UI설정

    // MARK: 클로저 바인딩 - 2. ViewController에서 ViewModel에게 action 전송
    viewModel.action?(.fetchCurrency)

    // 잘 갖고와지는지 테스트
    //    let service = CurrencyAPI()
    //    service.apiTest()
  }

  // MARK: 클로저 바인딩 - 1. ViewController에서 ViewModel 생성 후 바인딩 설정
  private func bindViewModel() {
    // (state 바뀔 때 UI 갱신되도록 클로저 바인딩)
    viewModel.didUpdate = { [weak self] _ in
      guard let self else { return }
      DispatchQueue.main.async {
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
      cell.configureCell(country: currency.country, rate: currency.rate, isFavorite: isFavorite)
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
    print("selectedCurrency: \(selectedCurrency)")
//    title = "환율 정보"
    let calculatorVC = CalculatorConroller()
    let backNavBarButton = UIBarButtonItem(title: "환율 정보", style: .plain, target: self, action: nil)
    navigationItem.backBarButtonItem = backNavBarButton
    calculatorVC.currency = selectedCurrency
    navigationController?.pushViewController(calculatorVC, animated: true)
  }
  
}

extension CCCViewController: UITableViewDelegate {}

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
