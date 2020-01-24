//
//  ViewController.swift
//  PersistenceLab_ImageSearch
//
//  Created by Eric Davenport on 1/21/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var searchQuery = "money" {
    didSet {
      searchImages(with: searchQuery)
    }
  }
  
  var images = [PhotoInfo]() {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    collectionView.dataSource = self
    collectionView.delegate = self
    searchImages(with: searchQuery)
  }
  
  func searchImages(with search: String) {
    PhotoAPIClient.getPhotos(for: search) { [weak self] (result) in
      switch result {
      case .failure(let appError):
        print("error: \(appError)")
      case .success(let photos):
        self?.images = photos
      }
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "searchSegue" {
      guard let detailController = segue.destination as? DetailController,
        let indexPath = collectionView.indexPathsForSelectedItems?.first else {
          fatalError("failed to segue")
      }
      detailController.image = images[indexPath.row]
      
    }
  }
}

extension ImageListViewController : UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else {
      fatalError("could not deque cell properly - need to downcast")
    }
    let photo = images[indexPath.row]
    
    cell.configureCell(photo: photo)
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "searchSegue", sender: self)
    
    
  }
}

extension ImageListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let maxWidth: CGFloat = UIScreen.main.bounds.size.width
      let itemWidth: CGFloat = maxWidth * 0.80
      return CGSize(width: itemWidth, height: itemWidth)  }
  
}

extension ImageListViewController : UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    guard let search = searchBar.text else {
      print("Search Invalid")
      return
    }
    searchImages(with: search)
  }
}
