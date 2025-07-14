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

  func isFavorite(code: String) -> Bool {
    let fetch = FavoriteCurrency.fetchRequest()
    fetch.predicate = NSPredicate(format: "code == %@", code)
    return (try? context.count(for: fetch)) ?? 0 > 0
  }

  func addFavorite(code: String) {
    guard !isFavorite(code: code) else { return }
    let fav = FavoriteCurrency(context: context)
    fav.code = code
    try? context.save()
  }

  func removeFavorite(code: String) {
    let fetch = FavoriteCurrency.fetchRequest()
    fetch.predicate = NSPredicate(format: "code == %@", code)
    if let result = try? context.fetch(fetch), let fav = result.first {
      context.delete(fav)
      try? context.save()
    }
  }

  func fetchAllFavorites() -> [String] {
    let fetch = FavoriteCurrency.fetchRequest()
    if let favs = try? context.fetch(fetch) {
      return favs.compactMap { $0.code }
    }
    return []
  }
}
