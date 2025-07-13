//
//  CalculatorController.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import SnapKit
import UIKit

class CalculatorController: UIViewController {
  var currency: (country: String, rate: Double)?
  private let titleLabel = UILabel()
//  private let resultStackView = UIStackView()
//  private let leftStackView = UIStackView()
//  private let leftLabel = UILabel()
//  private let leftTextField = UITextField()
//  private let chagneButton = UIButton()
//  private let rightStackView = UIStackView()
//  private let rightLabel = UILabel()
//  private let rightTextField = UITextField()

  private let nameLabel = UILabel()
  private let codeLabel = UILabel()
  private let labelStack = UIStackView()
  private let textField = UITextField()
  private let calcButton = UIButton()
  private let resultLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  private func setupUI() {
    // [-------환율 계산기--------]
    // [---------계산버튼---------]
    // [↓↓↓↓↓↓↓계산결과스택↓↓↓↓↓↓↓]
    // [--달러--]|[전환]|[-통화명-] <-
    // [달러숫자]|[버튼]|[계산결과]

    // 내비게이션 타이틀
    navigationItem.title = "환율 계산기"
//    navigationItem.title = "\(currency.map(\.country) ?? "no currency")"
    view.backgroundColor = UIColor(named: "BackgroundColor")

    titleLabel.text = "환율 계산기"
    titleLabel.font = Default.mainTitleFont

    codeLabel.text = currency.map(\.country) ?? "no code"
    codeLabel.font = .systemFont(ofSize: 24, weight: .bold)

    nameLabel.text = CurrencyStruct.name(for: currency.map(\.country) ?? "no country")
    nameLabel.font = .systemFont(ofSize: 16)
    nameLabel.textColor = UIColor(named: "SecondayTextColor")

    labelStack.axis = .vertical
    labelStack.spacing = 4
    labelStack.alignment = .center

    textField.placeholder = "금액을 입력하세요"
    textField.borderStyle = .roundedRect
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    textField.backgroundColor = .lightGray.withAlphaComponent(0.2)
    // 텍스트 전체 삭제 버튼 활성화
    textField.clearButtonMode = .always

    calcButton.setTitle("환율 계산", for: .normal)
    calcButton.backgroundColor = .systemBlue
//    calcButton.backgroundColor = UIColor(named: "ButtonColor")
    calcButton.layer.cornerRadius = 8
    calcButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    calcButton.addAction(
      UIAction { [weak self] _ in
        guard let self = self else { return }
        let wrongNumberAlert = UIAlertController(title: "오류", message: "올바른 숫자를 입력해 주세요.", preferredStyle: .alert)
        let emptyAlert = UIAlertController(title: "오류", message: "금액을 입력해 주세요", preferredStyle: .alert)
        let okActionButton = UIAlertAction(title: "확인", style: .default)

        for item in [wrongNumberAlert, emptyAlert] {
          item.addAction(okActionButton)
        }

        guard let text = textField.text, !text.isEmpty else {
          present(emptyAlert, animated: true, completion: nil)
          return
        }

        guard let amount = Double(text) else {
          present(wrongNumberAlert, animated: true, completion: nil)
          return
        }

        guard let rate = currency?.rate else {
          resultLabel.text = "No rate"
          return
        }

        let result = amount * rate
        resultLabel.text = "\(String(format: "%.2f", amount)) USD → \(String(format: "%.2f", result)) \(currency!.country)"
      },
      for: .touchUpInside
    )

    resultLabel.text = "1.00 USD → \(String(format: "%.2f", currency!.rate)) \(currency!.country)"
    resultLabel.font = .systemFont(ofSize: 20, weight: .medium)
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = 0

    for item in [titleLabel, labelStack, textField, calcButton, resultLabel] {
      view.addSubview(item)
    }

    for item in [codeLabel, nameLabel] {
      labelStack.addArrangedSubview(item)
    }

//    titleLabel.snp.makeConstraints {
//
//    }

    labelStack.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.centerX.equalToSuperview()
    }

    textField.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(44)
    }

    calcButton.snp.makeConstraints {
      $0.top.equalTo(textField.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(44)
    }

    resultLabel.snp.makeConstraints {
      $0.top.equalTo(calcButton.snp.bottom).offset(32)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().inset(24)
    }
  }
}
