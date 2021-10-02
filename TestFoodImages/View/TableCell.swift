//
//  TableCell.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit
import FirebaseStorage

protocol TableCellDelegate: AnyObject {
   func updateUIImage(_ image: UIImage, index: Int)
}

class TableCell: UITableViewCell {
   weak var delegate: TableCellDelegate?
   static let id = "TableCell"
   static let preferredHeight: CGFloat = 75
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var priceLabel: UILabel!
   @IBOutlet weak var picture: UIImageView!
   private let storage = Storage.storage().reference()
   
   override func awakeFromNib() {
      super.awakeFromNib()
      picture.layer.cornerRadius = 5
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(with food: Food, at index: Int) {
      nameLabel.text = food.name
      priceLabel.text = food.price
      downloadImage(name: food.name, at: index)
   }
   
   private func downloadImage(name: String, at index: Int) {
      NetworkManager.shared.downloadImage(name: name, at: index) { [weak self] imgData in
         guard let self = self else { return }
         self.picture.image = imgData
         self.delegate?.updateUIImage(imgData, index: index)
      }
   }
   
   private func downloadImageUrl(imgRef name: String) {
      let ref = storage.child("\(name).jpg")
      ref.downloadURL { url, error in
         if let error = error {
            print(error)
         } else {
            guard let url = url else { return }
            print("\nname: \(name)")
            print(url)
         }
      }
   }
}
