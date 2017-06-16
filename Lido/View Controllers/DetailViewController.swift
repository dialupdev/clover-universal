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

  override func viewDidLoad() {
    super.viewDidLoad()
    loadNote()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func loadNote() {
    if let loader = self.detailLoader {
      loader.startAnimating()
    }

    Note.find(id: self.noteId!) { result in
      if let loader = self.detailLoader {
        loader.stopAnimating()
      }

      if let note = result {
        print(note.description())

        if let label = self.detailDescriptionLabel {
          label.text = note.description()
        }
      }
      else {
        print("error")
      }
    }
  }
}
