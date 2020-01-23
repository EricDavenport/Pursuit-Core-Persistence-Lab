//
//  PhotoObject.swift
//  PersistenceLab_ImageSearch
//
//  Created by Eric Davenport on 1/21/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation

struct PhotoObject: Codable {
  let hits: [PhotoInfo]
}

struct PhotoInfo: Codable {
  let largeImageURL : String
  let likes : Int
  let views : Int
  let tags : String
  let previewURL : String
  let favorites : Int
  let webformatURL : String
}
