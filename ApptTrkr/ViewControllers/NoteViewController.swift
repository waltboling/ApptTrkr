//
//  NoteViewController.swift
//  ApptTrkr
//
//  Created by Jon Boling on 2/12/19.
//  Copyright © 2019 Walt Boling. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    
    var passedNote: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = passedNote {
            noteTextView.text = note
        } else {
            noteTextView.text = "Error loading note..."
        }
        
        noteTextView.isUserInteractionEnabled = true
        noteTextView.isEditable = false
        noteTextView.dataDetectorTypes = .all
        noteTextView.layer.cornerRadius = 5
        noteTextView.backgroundColor = UIColor.ATColors.white
        noteTextView.textColor = UIColor.ATColors.midBlue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
