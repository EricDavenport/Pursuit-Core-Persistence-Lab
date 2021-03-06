//
//  FavoritesVC.swift
//  PersistenceLab_ImageSearch
//
//  Created by Eric Davenport on 1/22/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var images = [PhotoInfo]() {
    didSet {
      DispatchQueue.main.async {
        self.loadFaves()
        self.tableView.reloadData()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadFaves()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func loadFaves() {
    do {
      images = try PersistenceHelper.loadEvents()
    } catch {
      print("failed to load favorites")
    }
  }
  
  func displayDetailVC(image: PhotoInfo) {
    guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailController") as? DetailController else {
      fatalError("failed to downcast to DetailController")
    }
    detailVC.image = image
    detailVC.buttonBoolean = true
    
    present(detailVC, animated: true)
  }
}

extension FavoritesVC : UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "favesCell", for: indexPath) as? FaveCell else {
      fatalError("failed to deque to cell")
    }
    let photo = images[indexPath.row]
    
    cell.configureCell(for: photo)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return images.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //let detailImage = tableView[indexPath.row]
    displayDetailVC(image: images[indexPath.row])
  }
}

