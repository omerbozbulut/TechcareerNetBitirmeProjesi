//
//  FavoriteFoodRepository.swift
//  YemekSiparis
//
//  Created by Ömer Bozbulut on 25.05.2024.
//

import Foundation
import RxSwift
import CoreData

class FavoriteFoodRepository {
    var favoriteFoodsList = BehaviorSubject<[Food]>(value: [Food]())
    let context = appDelegate.persistentContainer.viewContext
    
    func save(id: String, name: String, imageName: String, price: String, completion: @escaping (Bool) -> ()) {
        let food = Food(context: context)
        food.id = id
        food.name = name
        food.image_name = imageName
        food.price = price
    
        appDelegate.saveContext()
        completion(true)
    }
    
    func delete(food: Food,  completion: @escaping (Bool) -> ()) {
        context.delete(food)
        appDelegate.saveContext()
        completion(true)
    }
    
    func getFavorites() {
        do {
            let fr = Food.fetchRequest()
            let list = try context.fetch(fr)
            favoriteFoodsList.onNext(list)
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func deleteAllRecords() {
//        let fr = Food.fetchRequest()
//        fr.includesPropertyValues = false // fetch only the managedObjectID
//
//        do {
//            let items = try context.fetch(fr) as [NSManagedObject]
//            for item in items {
//                context.delete(item)
//            }
//            try context.save()
//        } catch {
//            print("Failed to delete all records from: \(error)")
//        }
//    }
}
