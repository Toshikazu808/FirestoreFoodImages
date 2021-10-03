//
//  TableCell.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit

protocol TableCellDelegate: AnyObject {
   func goToDetails(docName: String, index: Int)
}

class TableCell: UITableViewCell {
   weak var delegate: TableCellDelegate?
   static let id = "TableCell"
   @IBOutlet weak private var nameLabel: UILabel!
   @IBOutlet weak private var collectionView: UICollectionView!
   private var data = [Food]()
   private var fileName = ""
   
   override func awakeFromNib() {
      super.awakeFromNib()
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.register(UINib(nibName: CollectionCell.id, bundle: nil), forCellWithReuseIdentifier: CollectionCell.id)
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(docName: String, data: [Food], index: Int) {
      nameLabel.text = docName.separateWords()
      self.fileName = docName
      self.data = data
      self.tag = index
      collectionView.reloadData()
   }
   
   @IBAction func buttonTapped(_ sender: UIButton) {
      let title = nameLabel.text!.separateWords()
      delegate?.goToDetails(docName: title, index: self.tag)
   }
}

extension TableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return data.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(
         withReuseIdentifier: CollectionCell.id,
         for: indexPath) as! CollectionCell
      if data.count > 0 {
         cell.configure(
            file: nameLabel.text!,
            food: data[indexPath.row])
      }
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let screenSize: CGRect = UIScreen.main.bounds
      let cellWidth = screenSize.width * 0.75
      let cellHeight = self.bounds.height * 0.9
      return CGSize(width: cellWidth, height: cellHeight)
   }
}
