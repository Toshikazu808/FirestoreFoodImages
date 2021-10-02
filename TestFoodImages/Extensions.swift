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
