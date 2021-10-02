//
//  DetailsVC.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit

class DetailsVC: UIViewController {
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var priceLabel: UILabel!
   @IBOutlet weak var urlLabel: UILabel!
   @IBOutlet weak var picture: UIImageView!
   var name = ""
   var price = ""
   var url = ""
   var image: UIImage?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      picture.layer.cornerRadius = 6
      setupUI()
   }
   
   private func setupUI() {
      title = name
      nameLabel.text = name
      priceLabel.text = price
      urlLabel.text = url
      picture.image = image
   }
}
