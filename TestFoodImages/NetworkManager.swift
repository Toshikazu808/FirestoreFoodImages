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
   
   func getData(completion: @escaping(Result<[Food], Error>) -> Void) {
      let docRef = HomeVC.db.collection("Food").document("Foods")
      docRef.getDocument { document, error in
         if let error = error {
            completion(.failure(error))
         }
         if let document = document, document.exists {
            var foods = [Food]()
            for (_, data) in document.data()! {
               let d = data as! [String]
               let food = Food(name: d[0], price: d[1], imgUrl: d[2], img: nil)
               foods.append(food)
            }
            completion(.success(foods))
         } else {
            print("\nDocument does not exist")
         }
      }
   }
   
   func downloadImage(name: String, at index: Int, completion: @escaping(UIImage) -> Void) {
      let ref = NetworkManager.storage.child("\(name).jpg")
      ref.getData(maxSize: 5000000) { data, error in
         if let error = error {
            print(error)
         } else {
            guard let data = data else { return }
            DispatchQueue.main.async {
               guard let imgData = UIImage(data: data) else { return }
               completion(imgData)
            }
         }
      }
   }
}
