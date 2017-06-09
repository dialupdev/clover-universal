//
//  DetailViewController.swift
//  Lido
//
//  Created by Steve Davis on 5/31/17.
//  Copyright © 2017 Steve Davis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  var index: Int?

  @IBOutlet weak var detailDescriptionLabel: UILabel!

  func configureView() {
    if let note = Note.find(id: self.index!) {
      print(note.description())
    }
    else {
      print("Unable to find note #\(self.index!)")
    }

    // Update the user interface for the detail item.
    if let detail = detailItem {
      if let label = detailDescriptionLabel {
        label.text = detail.description
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    configureView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  var detailItem: NSDate? {
    didSet {
      // Update the view.
      configureView()
    }
  }
}

