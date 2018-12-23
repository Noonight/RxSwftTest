//
//  DetailViewController.swift
//  RxTest
//
//  Created by ayur on 20.12.2018.
//  Copyright © 2018 ayur. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var mTextField: UITextField!
    @IBOutlet weak var mTextView: UILabel!
    
    let disposeBag = DisposeBag()
    
    var textHere: Bool? {
        didSet {
            self.mTextView.text =  !textHere! ? "true" : "false"
            //print(mTextView.text)
        }
    }
    
    var text: String? {
        didSet {
            textHere = text!.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTextField.rx.value
            .subscribe(onNext: { value in
                self.mLabel.text = value
                self.text = self.mLabel.text
                //self.mTextView.text = self.text!
                print (self.text)
                print (self.textHere)
//                if (self.textFieldIsEmpty()) {
//                    print ("here")
//                    self.textHere = false
//                } else {
//                    self.textHere = true
//                }
//                //print(self.mLabel.text)
//                if (self.textHere) {
//                    self.mTextView.text = "Boolean true"
//                } else {
//                    self.mTextView.text = "Boolean false"
//                }
//                //self.mTextView.text = String(self.textHere)
            },
                       onError: { error in
                //self.mTextView.text = error.localizedDescription
            }).disposed(by: disposeBag)
    }
    
    func textFieldIsEmpty() -> Bool {
        return mTextField.text?.isEmpty ?? true
    }
}
