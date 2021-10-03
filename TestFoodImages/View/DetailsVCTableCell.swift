//
//  DetailsVCTableCell.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/2/21.
//

import UIKit

class DetailsVCTableCell: UITableViewCell {
   static let id = "DetailsVCTableCell"
   static let preferredHeight: CGFloat = 75
   @IBOutlet weak private var nameLabel: UILabel!
   @IBOutlet weak private var priceLabel: UILabel!
   @IBOutlet weak private var picture: UIImageView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      picture.layer.cornerRadius = 6
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(food: Food) {
      nameLabel.text = food.name
      priceLabel.text = food.price
      // We don't want to download images again since the CollectionCells already downloaded them.
      // TODO: Figure out how to pass the [UIImage] from the collectionView cells back to HomeVC to it can be passed to DetailsVC
   }
}
