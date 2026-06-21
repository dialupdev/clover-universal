//
//  DetailViewController.swift
//  Lido
//
//  Created by Steve Davis on 5/31/17.
//  Copyright © 2017 Steve Davis. All rights reserved.
//

import UIKit
import MarkdownTextView

class DetailViewController: UIViewController {
  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var detailLoader: UIActivityIndicatorView!

  var noteId: Int? {
    didSet {
      loadNote()
    }
  }
  
  var textView: MarkdownTextView!

  override func viewDidLoad() {
    super.viewDidLoad()
    loadNote()
    
    let attributes = MarkdownAttributes()
    let textStorage = MarkdownTextStorage(attributes: attributes)
    do {
      textStorage.addHighlighter(try LinkHighlighter())
    } catch let error {
      fatalError("Error initializing LinkHighlighter: \(error)")
    }
    textStorage.addHighlighter(MarkdownStrikethroughHighlighter())
    textStorage.addHighlighter(MarkdownSuperscriptHighlighter())
    if let codeBlockAttributes = attributes.codeBlockAttributes {
      textStorage.addHighlighter(MarkdownFencedCodeHighlighter(attributes: codeBlockAttributes))
    }
    
    textView = MarkdownTextView(frame: CGRect.zero, textStorage: textStorage)
    textView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(textView)
    
    let views: [String : Any] = ["textView": textView]
    var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[textView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[textView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
    NSLayoutConstraint.activate(constraints)
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
