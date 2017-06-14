//
//  Note.swift
//  Lido
//
//  Created by Steve Davis on 6/6/17.
//  Copyright © 2017 Steve Davis. All rights reserved.
//

import Foundation
import Alamofire

class Note {
  var id: Int?
  var title: String?
  var body: String?
  var createdAt: Date?
  var updatedAt: Date?

  init(id: Int, title: String, body: String, createdAt: Date, updatedAt: Date) {
    self.id = id
    self.title = title
    self.body = body
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }

  init(dict: [String: Any]) {
    self.id = dict["id"] as? Int
    self.title = dict["title"] as? String
    self.body = dict["body"] as? String

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!

    if let createdAt = dict["created_at"] as? String {
      self.createdAt = dateFormatter.date(from: createdAt)
    }

    if let updatedAt = dict["updated_at"] as? String {
      self.updatedAt = dateFormatter.date(from: updatedAt)
    }
  }

  class func find(id: Int, handler: @escaping (Note?) -> ()) {
    print("\(self.endpoint)/\(id)")
    Alamofire.request("\(self.endpoint)/\(id)").responseJSON { response in
      if let value = response.result.value as? [String: Any] {
        let note = Note(dict: value)
        handler(note)
      }
      else {
        handler(nil)
      }
    }
  }

  func description() -> String {
    return String.init(format: "(%d) [%@]: %@", self.id!, self.title!, self.body!)
  }
}
