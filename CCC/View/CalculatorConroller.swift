//
//  CalculatorConroller.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import SnapKit
import UIKit

class CalculatorConroller: UIViewController {
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
  private let textField = UITextField()
  private let calcButton = UIButton()
  private let resultLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
//    print(currency.map(\.country) ?? "no currency")
//    print(currency.map(\.rate) ?? "no currency")
  }

  private func setupUI() {
    // [-------환율 계산기--------]
    // [---------계산버튼---------]
    // [↓↓↓↓↓↓↓계산결과스택↓↓↓↓↓↓↓]
    // [--달러--]|[전환]|[-통화명-] <-
    // [달러숫자]|[버튼]|[계산결과]

    // 내비게이션 타이틀을 선택한 통화로
//    self.navigationItem.title = "\(currency.map(\.country) ?? "no currency")"
    view.backgroundColor = UIColor(named: "MainBgColor")

    titleLabel.text = "환율 계산기"
    titleLabel.font = Default.mainTitleFont

    // codeLabel.text = currency?.country ?? "no code"
    codeLabel.text = currency.map(\.country) ?? "no code"
    codeLabel.font = Default.mainTextFont
    codeLabel.textAlignment = .center

    nameLabel.text = CurrencyStruct.name(for: currency.map(\.country) ?? "no country")
    nameLabel.font = Default.subTextFont
    nameLabel.textAlignment = .center

    textField.placeholder = "1000"
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center

    calcButton.setTitle("환율 계산", for: .normal)
    calcButton.backgroundColor = .systemBlue
    calcButton.addAction(
      UIAction { [weak self] _ in
        guard let self = self else { return }

        guard let text = textField.text,
              let amount = Double(text)
        else {
          resultLabel.text = "1.00 USD → \(String(format: "%.2f", currency!.rate)) \(currency!.country)"
          return
        }

        guard let rate = currency?.rate else {
          resultLabel.text = "No rate"
          return
        }

        let result = amount * rate
        resultLabel.text = String(format: "%.2f", result)
      },
      for: .touchUpInside
    )


    resultLabel.text = "1.00 USD → \(String(format: "%.2f", currency!.rate)) \(currency!.country)"
    resultLabel.textAlignment = .center

    for item in [titleLabel, codeLabel, nameLabel, textField, calcButton, resultLabel] {
      view.addSubview(item)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    codeLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }

    nameLabel.snp.makeConstraints {
      $0.top.equalTo(codeLabel.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    calcButton.snp.makeConstraints {
      $0.top.equalTo(textField.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    resultLabel.snp.makeConstraints {
      $0.top.equalTo(calcButton.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
  }
}
