//
//  DetailViewController.swift
//  Lido
//
//  Created by Steve Davis on 5/31/17.
//  Copyright © 2017 Steve Davis. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
  var index: Int?

  @IBOutlet weak var detailDescriptionLabel: UILabel!

  func configureView() {
    print("http://staging.lido.celery.club/notes/\(self.index!)")

    Alamofire.request("http://staging.lido.celery.club/notes/\(self.index!)").responseJSON { response in
      if let value = response.result.value as? [String: Any]{
        let note = Note.init(dict: value)
        print(note.description())
      }
      else {
        print(response.error!)
      }
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

