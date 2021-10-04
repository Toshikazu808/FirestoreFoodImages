//
//  ViewController.swift
//  TestFoodImages
//
//  Created by Ryan Kanno on 10/1/21.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeVC: UIViewController {
   static let db = Firestore.firestore()
   @IBOutlet weak private var tableView: UITableView!
   private let docNames = [
      "ChineseFood", "IndianFood",
      "JapaneseFood", "ItalianFood", "Salads",
      "BreakfastFoods", "Sandwiches", "Desserts"]
   private var food = [[Food]]()
   private var collectionName = ""
   private var index = 0
   private var detailsFood = [Food]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupTableView()
      loadData()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.destination is DetailsVC {
         let detailsVC = segue.destination as? DetailsVC
         detailsVC?.collectionName = collectionName
         detailsVC?.food = detailsFood
      }
   }
   
   private func setupTableView() {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(
         UINib(nibName: TableCell.id, bundle: nil),
         forCellReuseIdentifier: TableCell.id)
   }
   
   private func loadData() {
      NetworkManager.shared.getDataAsArrays(docNames) { [weak self] result in
         guard let self = self else { return }
         switch result {
         case .failure(let error):
            print(error)
         case .success(let success):
            self.food = success
            self.tableView.reloadData()
         }
      }
   }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return food.count
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      let screenSize: CGRect = UIScreen.main.bounds
      let cellHeight = screenSize.height * 0.55
      return cellHeight
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
         withIdentifier: TableCell.id,
         for: indexPath) as! TableCell
      cell.delegate = self
      if food.count > 0 {
         cell.configure(
            docName: docNames[indexPath.row],
            data: food[indexPath.row],
            index: indexPath.row)
      }
      return cell
   }
}

extension HomeVC: TableCellDelegate {
   func goToDetails(docName: String, index: Int) {
      collectionName = docName
      detailsFood = food[index]
      performSegue(withIdentifier: "ToDetails", sender: nil)
   }
}
