//
//  TableViewCell.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import SnapKit
import UIKit

// [코드|----|----]
// [----|환율|즐찾]
// [국명|----|----]

class TableViewCell: UITableViewCell {
  static let id = "TableViewCell"
  
  private let countryCodeLabel = UILabel()
  private let countryNameLabel = UILabel()
  private let countryStack = UIStackView()
  private let containerStack = UIStackView()
  private let currencyRateLabel = UILabel()
//  private let favoriteButton: UIButton!
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    countryCodeLabel.textColor = UIColor(named: "mainTextColor")
    countryCodeLabel.font = Default.mainTextFont
        
    countryNameLabel.textColor = UIColor(named: "mainTextColor")
    countryNameLabel.font = Default.subTextFont
    
    currencyRateLabel.textColor = UIColor(named: "mainTextColor")
    currencyRateLabel.font = Default.subTextFont

    countryStack.axis = .vertical
    countryStack.distribution = .fillProportionally
    
    containerStack.axis = .horizontal
    containerStack.distribution = .equalSpacing
    containerStack.alignment = .center
    
    for item in [countryStack, containerStack] {
      contentView.addSubview(item)
    }
    
    for label in [countryCodeLabel, countryNameLabel] {
      countryStack.addArrangedSubview(label)
    }
    
    for label in [countryStack, currencyRateLabel] {
      containerStack.addArrangedSubview(label)
    }
    
    countryStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    containerStack.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }

  func configureCell(country: String, rate: Double) {
    countryCodeLabel.text = country
    countryNameLabel.text = CurrencyStruct.name(for: country)
    currencyRateLabel.text = String(format: "%.4f", rate)
  }
}
