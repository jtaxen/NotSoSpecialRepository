//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by ÅF Jacob Taxén on 2017-03-08.
//  Copyright © 2017 Jazze and the Tazzers. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.becomeFirstResponder()
		
		// The text field not being edited is disabled
		let tag = textField.tag
		textField.superview?.viewWithTag(( 3 - tag ))?.isUserInteractionEnabled = false
		
		// If text is default, it automatically disappears
		switch textField.text! {
		case "TOP":
			textField.text = ""
		case "BOTTOM":
			textField.text = ""
		default: break
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		let tag = textField.tag
		textField.superview?.viewWithTag(( 3 - tag ))?.isUserInteractionEnabled = true
		
		// If field is left empty, the default text reappears. Otherwise the user can not find it again
		if textField.text == "" {
			if textField.tag == 1 {
				textField.text = "TOP"
			} else if textField.tag == 2 {
				textField.text = "BOTTOM"
			}
		}
		textField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
