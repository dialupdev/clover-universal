//
//  DetailViewController.swift
//  Lido
//
//  Created by Steve Davis on 5/31/17.
//  Copyright © 2017 Steve Davis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var detailLoader: UIActivityIndicatorView!

  var noteId: Int? {
    didSet {
      loadNote()
    }
  }

  private let textView = UITextView()

  override func viewDidLoad() {
    super.viewDidLoad()

    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.isEditable = false
    textView.font = .preferredFont(forTextStyle: .body)
    view.addSubview(textView)

    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: view.topAnchor),
      textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    loadNote()
  }

  func loadNote() {
    guard let noteId = noteId else { return }

    detailLoader?.startAnimating()

    Note.find(id: noteId) { [weak self] result in
      guard let self = self else { return }
      self.detailLoader?.stopAnimating()

      if let note = result {
        self.detailDescriptionLabel?.text = note.summary()
        self.textView.attributedText = Self.attributedBody(from: note.body)
      }
    }
  }

  private static func attributedBody(from body: String?) -> NSAttributedString {
    guard let body = body, !body.isEmpty else {
      return NSAttributedString(string: "")
    }

    if let attributed = try? NSAttributedString(markdown: body) {
      return attributed
    }

    return NSAttributedString(string: body)
  }
}
