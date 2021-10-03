//
//  CollectionCell.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/2/21.
//

import UIKit

protocol CollectionCellDelegate: AnyObject {
   func passImgDataBack()
}

class CollectionCell: UICollectionViewCell {
   weak var delegate: CollectionCellDelegate?
   static let id = "CollectionCell"
   @IBOutlet weak private var priceLabel: UILabel!
   @IBOutlet weak private var nameLabel: UILabel!
   @IBOutlet weak private var picture: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      picture.layer.cornerRadius = 5
   }
   
   func configure(file: String, food: Food) {
      nameLabel.text = food.name
      priceLabel.text = food.price
      picture.image = food.img
   }
}
