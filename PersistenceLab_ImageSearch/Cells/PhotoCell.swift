//
//  PhotoCell.swift
//  PersistenceLab_ImageSearch
//
//  Created by Eric Davenport on 1/21/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import UIKit
import ImageKit

class PhotoCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView : UIImageView!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = 20.0
    backgroundColor = .black
  }
  
  public func configureCell(photo: PhotoInfo) {
    imageView.getImage(with: photo.previewURL) { [weak self] (result) in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self?.imageView.image = UIImage(systemName: "photo.fill")
        }
      case .success(let image):
        DispatchQueue.main.async {
          self?.imageView.image = image
        }
      }
    }
  }
}
