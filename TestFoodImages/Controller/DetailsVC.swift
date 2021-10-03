//
//  DetailsVC.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit

class DetailsVC: UIViewController {
   @IBOutlet weak private var tableView: UITableView!
   var collectionName = ""
   var food = [Food]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      title = collectionName
      setupTableView()
   }
   
   private func setupTableView() {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: DetailsVCTableCell.id, bundle: nil), forCellReuseIdentifier: DetailsVCTableCell.id)
   }
}

extension DetailsVC: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return food.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: DetailsVCTableCell.id, for: indexPath) as! DetailsVCTableCell
      cell.configure(food: food[indexPath.row])
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      print(food[indexPath.row])
   }
}
