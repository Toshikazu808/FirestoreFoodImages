//
//  NetworkManager.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

final class NetworkManager {
   static let shared = NetworkManager()
   private init() {}
   static private let storage = Storage.storage().reference()
   
   // MARK: - Basic http request
   func performRequest<T: Codable>(urlString: String, returnType: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
      guard let url = URL(string: urlString) else { return }
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, _, error in
         if let error = error {
            completion(.failure(error))
         }
         guard let data = data else { return }
         let decoder = JSONDecoder()
         do {
            let decodedData = try decoder.decode(T.self, from: data)
            completion(.success(decodedData))
         } catch let error {
            completion(.failure(error))
         }
      }
      task.resume()
   }
   
   // MARK: - Get data as dictionaries
   func getDataAsDictionaries(_ docNames: [String], completion: @escaping(Result<[[Food]], Error>) -> Void) {
      var foodCollection = [[Food]]()
      var tempDict = [String: [Food]]()
      let group = DispatchGroup()
      for food in docNames {
         group.enter()
         let docRef = HomeVC.db.collection("FoodAgain").document(food)
         docRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            defer { group.leave() }
            if let error = error { completion(.failure(error)) }
            if let document = document, document.exists {
               let (foods: [Food], category: String) = self.initFromDictData(document.data()!)
               tempDict[category] = foods
            } else { print("\nDocument does not exist") }
         }
      }
      group.notify(queue: .main) { [weak self] in
         guard let self = self else { return }
         foodCollection = self.sort(dictionary: tempDict, order: docNames)
         self.downloadImages(foodCollection) { foodWithImages in
            completion(.success(foodWithImages))
         }
      }
   }
   
   private func initFromDictData(_ data: [String: Any]) -> ([Food], String) {
      var foods = [Food]()
      var category = ""
      for (key, value) in data {
         let d = value as! [String: String]
         category = key
         let food = Food(
            name: d["Name"]!,
            price: d["Price"]!,
            category: key,
            img: nil)
         foods.append(food)
      }
      return (foods, category)
   }
   
   // MARK: - Get data as arrays
   func getDataAsArrays(_ docNames: [String], completion: @escaping(Result<[[Food]], Error>) -> Void) {
      var foodCollection = [[Food]]()
      var tempDict = [String: [Food]]()
      let group = DispatchGroup()
      for food in docNames {
         group.enter()
         let docRef = HomeVC.db.collection("Food").document(food)
         docRef.getDocument { [weak self] document, error in
            guard let self = self else { return }
            defer { group.leave() }
            if let error = error { completion(.failure(error)) }
            if let document = document, document.exists {
               let (foods: [Food], category: String) = self.initFromArrayData(document.data()!)
               tempDict[category] = foods
            } else { print("\nDocument does not exist") }
         }
      }
      group.notify(queue: .main) { [weak self] in
         guard let self = self else { return }
         foodCollection = self.sort(dictionary: tempDict, order: docNames)
         self.downloadImages(foodCollection) { foodCollectionWithImages in
            completion(.success(foodCollectionWithImages))
         }
      }
   }
   
   private func initFromArrayData(_ data: [String: Any]) -> ([Food], String) {
      var foods = [Food]()
      var category = ""
      for (_, value) in data {
         let v = value as! [String]
         category = v[2]
         let food = Food(
            name: v[0],
            price: v[1],
            category: v[2],
            img: nil)
         foods.append(food)
      }
      return (foods, category)
   }
   
   // MARK: - Get images
   private func downloadImages(_ foodCollection: [[Food]], completion: @escaping([[Food]]) -> Void) {
      var foods = foodCollection
      let group = DispatchGroup()
      for i in 0..<foods.count {
         for j in 0..<foods[i].count {
            group.enter()
            let ref = NetworkManager.storage.child(foods[i][j].imgPath)
            ref.getData(maxSize: 500000) { data, error in
               defer { group.leave() }
               if let error = error { print("\nError downloading img: \(error)") } else {
                  guard let data = data else { return }
                  guard let img = UIImage(data: data) else { return }
                  foods[i][j].img = img
               }
            }
         }
      }
      group.notify(queue: .main) {
         completion(foods)
      }
   }
   
   // MARK: - Sort dictionary to return [[Food]]
   private func sort(dictionary: [String: [Food]], order: [String]) -> [[Food]] {
      var sortedFoods = [[Food]]()
      for category in order {
         sortedFoods.append(dictionary[category]!)
      }
      return sortedFoods
   }
}
