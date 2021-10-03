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
   
   func getData(_ docNames: [String], completion: @escaping(Result<[[Food]], Error>) -> Void) {
      var foodCollection = [[Food]]()
      var tempDict = [String: [Food]]()
      let group = DispatchGroup()
      for food in docNames {
         group.enter()
         let docRef = HomeVC.db.collection("Food").document(food)
         docRef.getDocument { document, error in
            defer { group.leave() }
            if let error = error { completion(.failure(error)) }
            if let document = document, document.exists {
               var foods = [Food]()
               var category = ""
               for (_, data) in document.data()! {
                  let d = data as! [String]
                  category = d[2]
                  let food = Food(
                     name: d[0],
                     price: d[1],
                     category: d[2],
                     img: nil)
                  foods.append(food)
               }
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
   
   private func sort(dictionary: [String: [Food]], order: [String]) -> [[Food]] {
      var sortedFoods = [[Food]]()
      for category in order {
         sortedFoods.append(dictionary[category]!)
      }
      return sortedFoods
   }
}
