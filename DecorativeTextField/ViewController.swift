//
//  ViewController.swift
//  DecorativeTextField
//
//  Created by Naresh Kumar Nagulavancha on 11/7/18.
//  Copyright © 2018 incomm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var decoratedTextField: DecoratedTextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		decoratedTextField.delegate = self
		// Do any additional setup after loading the view, typically from a nib.
	}
	@IBAction func updateViews(_ sender: Any) {
		let button = UIButton(type: .infoDark)
		let sw = UISwitch()
		sw.isOn = true
		let image = UIImageView(image: UIImage(named: "Chess-Game"))
		let dict = [0: button, 1: sw, 2: image]
		let random = Int(arc4random_uniform(3))
		decoratedTextField.rightAccessoryView = dict[random]
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == decoratedTextField {
			if let text = textField.text, text.count > 5 {
				decoratedTextField.errorMessage = "Error Occured"
				decoratedTextField.hasErrorMessage = true
			} else {
				decoratedTextField.hasErrorMessage = false
			}
		}
	}

}

