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
   @IBOutlet weak var tableView: UITableView!
   private var food = [Food]()
   private var name = ""
   private var price = ""
   private var imgUrl = ""
   private var picture: UIImage?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupTableView()
      loadData()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.destination is DetailsVC {
         let detailsVC = segue.destination as? DetailsVC
         detailsVC?.name = name
         detailsVC?.price = price
         detailsVC?.url = imgUrl
         detailsVC?.image = picture
      }
   }
   
   private func setupTableView() {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.register(UINib(nibName: TableCell.id, bundle: nil), forCellReuseIdentifier: TableCell.id)
   }
   
   private func loadData() {
      NetworkManager.shared.getData { [weak self] result in
         guard let self = self else { return }
         switch result {
         case .failure(let error):
            print(error)
         case .success(let success):
            self.food = success
            DispatchQueue.main.async {
               self.tableView.reloadData()
            }            
         }
      }
   }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return food.count
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return TableCell.preferredHeight
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.id, for: indexPath) as! TableCell
      cell.delegate = self
      cell.configure(with: food[indexPath.row], at: indexPath.row)
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      name = food[indexPath.row].name
      price = food[indexPath.row].price
      imgUrl = food[indexPath.row].imgUrl
      picture = food[indexPath.row].img
      performSegue(withIdentifier: "ToDetails", sender: nil)
   }
}

extension HomeVC: TableCellDelegate {
   func updateUIImage(_ image: UIImage, index: Int) {
      food[index].img = image
   }
}
