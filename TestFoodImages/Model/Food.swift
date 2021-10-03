//
//  Food.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit

struct Food {
   let name: String
   let price: String
   let category: String
   var img: UIImage?
   var imgPath: String {
      return "\(category)/\(name).jpg"
   }
   
   init(name: String, price: String, category: String, img: UIImage?) {
      self.name = name
      self.price = price
      self.category = category
      self.img = img
   }
}
