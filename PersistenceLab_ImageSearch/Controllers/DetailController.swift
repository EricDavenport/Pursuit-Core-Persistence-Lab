//
//  DetailController.swift
//  PersistenceLab_ImageSearch
//
//  Created by Eric Davenport on 1/22/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import ImageKit

class DetailController: UIViewController {
  
  @IBOutlet weak var favoriteImageView: UIImageView!
  @IBOutlet weak var imageView : UIImageView!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var likesLabel : UILabel!
  @IBOutlet weak var tagsLabel : UILabel!
  @IBOutlet weak var webFormatLabel : UILabel!
  @IBOutlet weak var previewURLLabel: UILabel!
  @IBOutlet weak var favoritesLabel: UILabel!
  
  var image : PhotoInfo?
  var buttonBoolean = false
  
  func toggleButton() {
    if buttonBoolean == true {
      favoriteButton.isHidden = true
      favoriteImageView.image = UIImage(systemName: "")
    }
  }
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    
  }
  
  func updateUI() {
    toggleButton()
    likesLabel.text = "Likes: \(image!.likes)"
    tagsLabel.text = "Tags: \(image!.tags)"
    previewURLLabel.text = "Preview URL: \(image!.previewURL)"
    webFormatLabel.text = "WebFormat URL: \(image!.webformatURL)"
    favoritesLabel.text = "Favorites: \(image!.favorites)"
    imageView.getImage(with: image!.largeImageURL) { (result) in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self.imageView.image = UIImage(systemName: "photo.fill")
        }
      case .success(let image):
        DispatchQueue.main.async {
          self.imageView.image = image
        }
      }
    }
  }
  
  @IBAction func favoriteButtonPressed(_ sender: UIButton) {
    favoriteImageView.image = UIImage(systemName: "star.fill")
    let thisImage = PhotoInfo(largeImageURL: image!.largeImageURL, likes: image!.likes, views: image!.views, tags: image!.tags, previewURL: image!.previewURL, favorites: image!.favorites, webformatURL: image!.webformatURL)
    
    do {
      try PersistenceHelper.save(photo: thisImage)
    } catch {
      print("failed to persist photo info")
    }
    dismiss(animated: true)
  }
  
}
