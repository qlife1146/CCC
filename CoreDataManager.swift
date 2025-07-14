//
//  CoreDataManager.swift
//  CCC
//
//  Created by luca on 7/10/25.
//

import CoreData
import Foundation
import UIKit

final class CoreDataManager {
  static let shared = CoreDataManager()

  let persistentContainer: NSPersistentContainer

  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  private init() {
    persistentContainer = NSPersistentContainer(name: "CCC")
    persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data stack load error: \(error)")
      }
    }
  }

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

  func saveLastRates(_ rates: [String: Double], date: String) {
    let context = persistentContainer.viewContext
    let fetch: NSFetchRequest<LastRates> = LastRates.fetchRequest()
    if let old = try? context.fetch(fetch), let last = old.first {
      context.delete(last)
    }
    let entity = LastRates(context: context)
    entity.date = date
    entity.ratesData = try? JSONEncoder().encode(rates)
    try? context.save()
  }

  func loadLastRates() -> [String: Double] {
    let context = persistentContainer.viewContext
    let fetch: NSFetchRequest<LastRates> = LastRates.fetchRequest()
    if let last = try? context.fetch(fetch).first,
       let data = last.ratesData,
       let dict = try? JSONDecoder().decode([String: Double].self, from: data)
    {
      return dict
    }
    return [:]
  }

  func saveLastScreen(screen: String, param: String?) {
    let context = persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<LastScreen> = LastScreen.fetchRequest()

    if let last = try? context.fetch(fetchRequest).first {
      context.delete(last)
    }

    let lastScreen = LastScreen(context: context)
    lastScreen.screen = screen
    lastScreen.param = param

    try? context.save()
  }

  func fetchLastScreen() -> (screen: String, param: String?)? {
    let context = persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<LastScreen> = LastScreen.fetchRequest()

    if let last = try? context.fetch(fetchRequest).first {
      return (last.screen ?? "", last.param)
    }
    return nil
  }
}
