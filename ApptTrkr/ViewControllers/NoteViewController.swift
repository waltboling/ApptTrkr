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
            noteTextView.text = "This is a test"
        }
        noteTextView.isUserInteractionEnabled = true
        noteTextView.isEditable = false
        noteTextView.dataDetectorTypes = .all
        
        noteTextView.layer.cornerRadius = 3
        noteTextView.backgroundColor = UIColor.ATColors.white
        noteTextView.textColor = UIColor.ATColors.midBlue
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
