//
//  Note.swift
//  Lido
//
//  Created by Steve Davis on 6/6/17.
//  Copyright © 2017 Steve Davis. All rights reserved.
//

import Foundation

class Note {
  static let endpoint = "http://staging.lido.celery.club/notes"

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
    dateFormatter.timeZone = TimeZone(identifier: "UTC")

    if let createdAt = dict["created_at"] as? String {
      self.createdAt = dateFormatter.date(from: createdAt)
    }

    if let updatedAt = dict["updated_at"] as? String {
      self.updatedAt = dateFormatter.date(from: updatedAt)
    }
  }

  class func all(handler: @escaping ([Note]) -> Void) {
    guard let url = URL(string: endpoint) else {
      handler([])
      return
    }

    URLSession.shared.dataTask(with: url) { data, _, _ in
      let notes: [Note]
      if let data = data,
         let values = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
        notes = values.map { Note(dict: $0) }
      } else {
        notes = []
      }

      DispatchQueue.main.async {
        handler(notes)
      }
    }.resume()
  }

  class func find(id: Int, handler: @escaping (Note?) -> Void) {
    guard let url = URL(string: "\(endpoint)/\(id)") else {
      handler(nil)
      return
    }

    URLSession.shared.dataTask(with: url) { data, _, _ in
      let note: Note?
      if let data = data,
         let value = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
        note = Note(dict: value)
      } else {
        note = nil
      }

      DispatchQueue.main.async {
        handler(note)
      }
    }.resume()
  }

  func summary() -> String {
    return String(format: "(%d) [%@]: %@", id ?? 0, title ?? "", body ?? "")
  }
}
