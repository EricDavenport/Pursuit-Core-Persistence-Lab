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
  @IBOutlet weak var heartImage: UIImageView!
  
  var image : PhotoInfo?
  var buttonBoolean = false
  
  
  func toggleButton() {
    if buttonBoolean == true {
      favoriteButton.isHidden = true
      favoriteImageView.image = UIImage(systemName: "")
    }
  }
  
  var tap = UITapGestureRecognizer()
  
  @objc func doubleTapped() {
    imageView.isUserInteractionEnabled = true
       favoriteImageView.image = UIImage(systemName: "star.fill")
    let thisImage = PhotoInfo(largeImageURL: image!.largeImageURL, likes: image!.likes, views: image!.views, tags: image!.tags, previewURL: image!.previewURL, favorites: image!.favorites, webformatURL: image!.webformatURL)
    
    do {
      try PersistenceHelper.save(photo: thisImage)
      heartImage.isHidden = false
    } catch {
      print("failed to persist photo info")
    }
    dismiss(animated: true)

  }
  func tapSetup() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
    tap.numberOfTapsRequired = 2
    view.addGestureRecognizer(tap)
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    tapSetup()
    
  }
  
  func updateUI() {
    toggleButton()
    heartImage.isHidden = true
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

