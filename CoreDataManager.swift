//
//  CoreDataManager.swift
//  CCC
//
//  Created by luca on 7/10/25.
//

import Foundation
import UIKit

final class CoreDataManager {
  static let shared = CoreDataManager()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  // 즐찾 여부 확인
  func isFavorite(code: String) -> Bool {
    let fetch = FavoriteCurrency.fetchRequest()
    // code만 찾기
    fetch.predicate = NSPredicate(format: "code == %@", code)
    return (try? context.count(for: fetch)) ?? 0 > 0
  }

  // 즐찾 추가
  func addFavorite(code: String) {
    guard !isFavorite(code: code) else { return }
    let fav = FavoriteCurrency(context: context)
    fav.code = code
    try? context.save()
  }

  // 즐찾 삭제
  func removeFavorite(code: String) {
    let fetch = FavoriteCurrency.fetchRequest()
    fetch.predicate = NSPredicate(format: "code == %@", code)
    // 반목문으로 code를 목표로 찾아다니며 있으면 삭제
    if let result = try? context.fetch(fetch), let fav = result.first {
      context.delete(fav)
      try? context.save()
    }
  }

  // 모든 즐찾 불러오기
  func fetchAllFavorites() -> [String] {
    let fetch = FavoriteCurrency.fetchRequest()
    if let favs = try? context.fetch(fetch) {
      return favs.compactMap { $0.code }
    }
    return []
  }
}
