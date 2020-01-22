//
//  FaveCell.swift
//  PersistenceLab_ImageSearch
//
//  Created by Eric Davenport on 1/22/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import ImageKit

class FaveCell: UITableViewCell {
  
  @IBOutlet weak var favImageView: UIImageView!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var tagsLabel: UILabel!
  @IBOutlet weak var viewsLabel: UILabel!
  
  func configureCell(for image: PhotoInfo) {
    likesLabel.text = "Likes: \(image.likes)"
    tagsLabel.text = "Tags: \(image.tags)"
    viewsLabel.text = "Total Views: \(image.views)"
    favImageView.getImage(with: image.previewURL) {[weak self] (result) in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self?.favImageView.image = UIImage(systemName: "photo.fill")
        }
      case .success(let thisPhoto):
        self?.favImageView.image = thisPhoto
      }
    }
  }
}
