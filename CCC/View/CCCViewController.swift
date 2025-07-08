//
//  ViewController.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import SnapKit
import UIKit

// Compact Currency Calculator
// [↓↓환율 스택↓↓↓]
// [--환율 정보---]
// [-통화 검색 바-]
// [↓↓↓테이블뷰↓↓↓]
// [국명|환율|즐찾]

class CCCViewController: UIViewController {
  private let viewModel = CCCViewModel()
  
  private let titleLabel = UILabel()
  private let searchBar = UISearchBar()
  private let mainStackView = UIStackView()
  private lazy var tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 잘 갖고와지는지 테스트
//    let service = CurrencyAPI()
//    service.apiTest()

    bindViewModel()
    setupUI()

    // MARK: 클로저 바인딩 - 2. ViewController에서 ViewModel에게 action 전송

    viewModel.action?(.fetchCurrency)
  }
  
  // MARK: 클로저 바인딩 - 1. ViewController에서 ViewModel 생성 후 바인딩 설정

  // (state 바뀔 때 UI 갱신되도록 클로저 바인딩)
  private func bindViewModel() {
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
    view.backgroundColor = .mainBg
    
    titleLabel.text = "환율 정보"
    titleLabel.textColor = .mainText
    titleLabel.font = .boldSystemFont(ofSize: 30)
    
    searchBar.barStyle = .default
    
    mainStackView.axis = .vertical
    mainStackView.distribution = .fillEqually
    
    tableView.backgroundColor = .mainBg
    
    // MARK: tableView 기본 요소

    // 데이터 제공자 설정
    tableView.delegate = self
    // 인터랙션 처리자 설정
    tableView.dataSource = self
    // cell 재사용을 위한 등록
    tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
    
    for item in [mainStackView, tableView] {
      view.addSubview(item)
    }
    
    for label in [titleLabel, searchBar] {
      mainStackView.addArrangedSubview(label)
    }
    
    mainStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(mainStackView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
//  @objc
//  private func segueExWithButton() {
//    self.navigationController?.pushViewController(CCCExViewController(), animated: true)
//  }
}

extension CCCViewController: UITableViewDataSource {
  // 섹션 1개에 나타낼 Row(줄) 개수, count 등
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRates()
  }

  // 재사용할 셀이 넣을 것
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
      return UITableViewCell()
    }

    if let currency = viewModel.currency(at: indexPath.row) {
      cell.configureCell(country: currency.country, rate: currency.rate)
    } else {
      print("xxxx")
    }
    return cell
  }
}

extension CCCViewController: UITableViewDelegate {
//  func tableVie
}
