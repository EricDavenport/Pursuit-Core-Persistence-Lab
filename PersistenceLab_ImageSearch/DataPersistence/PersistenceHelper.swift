//
//  PersistenceHelper.swift
//  PersistenceLab_ImageSearch
//
//  Created by Eric Davenport on 1/21/20.
//  Copyright © 2020 Eric Davenport. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error { // conforming to the Error protocol
  case savingError(Error) // associative value
  case fileDoesNotExist(String)
  case noData
  case decodingError(Error)
  case deletingError(Error)
}
//
//class PersistenceHelper {
//
//  // CRUD - create, read, update, delete
//
//  // array of events
//  private var photos = [PhotoInfo]()
//
//  private var filename: String
//
//  init(filename: String) {
//    self.filename = filename
//  }
//
//  private func save() throws {
//    // step 1.
//     // get url path to the file that the Event will be saved to
//     let url = FileManager.pathToDocumentsDirectory(with: filename)
//
//    // events array will be object being converted to Data
//    // we will use the Data object and write (save) it to documents directory
//    do {
//      // step 3.
//      // convert (serialize) the events array to Data
//      let data = try PropertyListEncoder().encode(photos)
//
//      // step 4.
//      // writes, saves, persist the data to the documents directory
//      try data.write(to: url, options: .atomic)
//    } catch {
//      // step 5.
//      throw DataPersistenceError.savingError(error)
//    }
//  }
//
//  // for re-ordering
//  public func reorderEvents(events: [PhotoInfo]) {
//    self.photos = events
//    try? save()
//  }
//
//  // DRY - don't repeat yourself
//
//  // create - save item to documents directory
//  public func create(item: PhotoInfo) throws {
//    // step 2.
//    // append new event to the events array
//    photos.append(item)
//
//    do {
//      try save()
//    } catch {
//      throw DataPersistenceError.savingError(error)
//    }
//  }
//
//  // read - load (retrieve) items from documents directory
//  public func loadEvents() throws -> [PhotoInfo] {
//    // we need access to the filename URL that we are reading from
//    let url = FileManager.pathToDocumentsDirectory(with: filename)
//
//    // check if file exist
//    // to convert URL to String we use .path on the URL
//    if FileManager.default.fileExists(atPath: url.path) {
//      if let data = FileManager.default.contents(atPath: url.path) {
//        do {
//          photos = try PropertyListDecoder().decode([PhotoInfo].self, from: data)
//        } catch {
//          throw DataPersistenceError.decodingError(error)
//        }
//      } else {
//        throw DataPersistenceError.noData
//      }
//    }
//    else {
//      throw DataPersistenceError.fileDoesNotExist(filename)
//    }
//    return photos
//  }
//
//  // delete - remove item from documents directory
//  public func delete(event index: Int) throws {
//    // remove the item from the events array
//    photos.remove(at: index)
//
//    // save our events array to the documents directory
//    do {
//      try save()
//    } catch {
//      throw DataPersistenceError.deletingError(error)
//    }
//  }
//}


class PersistenceHelper {
    
    // CRUD - Create, Read, Update, Delete
    
    // array of events
    private static var events = [PhotoInfo]()
    
    private static let filename = "schedules.plist"
    
    // create - save items to documents directory
    
    private static func save() throws {
        // step 1
        // get url path the file that the Event will be saved to
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        // events array will be object being converted to Data
        // we will use the Data object to write (save) it to documents directory
        do {
            // step 3
            // convert (serialize) the events array to Data
            let data = try PropertyListEncoder().encode(events)
            
            // step 4
            // writes, saves, persist the data to the documents directory
            try data.write(to: url, options: .atomic)
        } catch {
            // step 5
            throw DataPersistenceError.savingError(error)
        }
    }
    
    // DRY - Don't Repeat Yourself
    
    static func save(photo: PhotoInfo) throws {
        events.append(photo)
        
        do{
            try save()
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    // read - load (retrieve) items from documents directory
    
    static func loadEvents() throws -> [PhotoInfo] {
        // we need access to the filename URL that we are reading from
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        // check if file exists
        // to convert URL to String we use .path on the URL
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    try events = PropertyListDecoder().decode([PhotoInfo].self, from: data)
                } catch {
                    throw DataPersistenceError.decodingError(error)
                }
            } else {
                print("Data not found")
                throw DataPersistenceError.noData
            }
        } else{
            print("\(filename) does not exist.")
            throw DataPersistenceError.fileDoesNotExist(filename)
        }
        
        return events
        
    }
    
    // update -
    // delete - remove item from documents directory
    
    static func delete(event index: Int) throws {
        // remove the item from the events array
        events.remove(at: index)
        
        // save our events array to the documents directory
        do {
            try save()
        } catch {
            throw DataPersistenceError.deletingError(error)
        }
    }
}



