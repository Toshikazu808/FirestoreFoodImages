//
//  Extensions.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit

extension UIImageView {
   func load(urlString: String) {
      guard let url = URL(string: urlString) else { return }
      DispatchQueue.main.async { [weak self] in
         guard let self = self else { return }
         guard let data = try? Data(contentsOf: url) else { return }
         guard let image = UIImage(data: data) else { return }
         DispatchQueue.main.async {
            self.image = image
         }
      }
   }
}

extension String {
   func separateWords() -> String {
      var collectionName = ""
      for i in 0..<self.count {
         let index = self.index(self.startIndex, offsetBy: i)
         if i > 0 && self[index].isUppercase {
            collectionName += " \(self[index])"
         } else {
            collectionName += "\(self[index])"
         }
      }
      return collectionName
   }
}
