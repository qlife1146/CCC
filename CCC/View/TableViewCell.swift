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
  private let leftStack = UIStackView()
  private let currencyRateLabel = UILabel()
  private let favoriteButton = UIButton()
  private let rightStack = UIStackView()
  private let containerStack = UIStackView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    countryCodeLabel.textColor = UIColor(named: "TextColor")
    countryCodeLabel.font = Default.mainTextFont

    countryNameLabel.textColor = UIColor(named: "SecondaryTextColor")
    countryNameLabel.font = Default.subTextFont

    currencyRateLabel.textColor = UIColor(named: "TextColor")
    currencyRateLabel.font = Default.subTextFont

    favoriteButton.tintColor = UIColor(named: "FavoriteColor")
    favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    favoriteButton.addAction(
      UIAction { [weak self] _ in
        guard let self = self else { return }

        self.favorite?()
        // add action
        // cell 구성할 때 이벤트를 받을 수 있는 delegate or closure 필요.
        // 여기선 closure 호출만 하면 됨
      },
      for: .touchUpInside
    )

    leftStack.axis = .vertical
    leftStack.distribution = .fillProportionally

    rightStack.axis = .horizontal
    rightStack.distribution = .equalSpacing
    rightStack.alignment = .center
    rightStack.spacing = 8

    containerStack.axis = .horizontal
    containerStack.distribution = .equalSpacing
    containerStack.alignment = .center

    for item in [leftStack, containerStack] {
      contentView.addSubview(item)
    }

    for label in [countryCodeLabel, countryNameLabel] {
      leftStack.addArrangedSubview(label)
    }

    for label in [currencyRateLabel, favoriteButton] {
      rightStack.addArrangedSubview(label)
    }

    for label in [leftStack, rightStack] {
      containerStack.addArrangedSubview(label)
    }

    leftStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }

    rightStack.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
    }

    containerStack.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().inset(20)
    }
  }

  func configureCell(country: String, rate: Double, isFavorite: Bool, change: ChangeType) {
    countryCodeLabel.text = country
    countryNameLabel.text = CurrencyStruct.name(for: country)
    // 환율 차이 넣기
    let changeText: String
    switch change {
    case .up: changeText = "U"
    case .down: changeText = "D"
    default: changeText = ""
    }
    currencyRateLabel.text = "\(changeText)\(String (format: "%.4f", rate))"

    let imageName = isFavorite ? "star.fill" : "star"
    favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
  }

  // closure
  var favorite: (() -> Void)?
}
