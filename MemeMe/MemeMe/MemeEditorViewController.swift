//
//  ViewController.swift
//  MemeMe
//
//  Created by ÅF Jacob Taxén on 2017-03-07.
//  Copyright © 2017 Jazze and the Tazzers. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet var pickedImage: UIImageView!
	@IBOutlet var topTextField: UITextField!
	@IBOutlet var bottomTextField: UITextField!
	@IBOutlet var toolbar: UIToolbar!
	@IBOutlet var navbar: UINavigationBar!
	@IBOutlet var shareButton: UIBarButtonItem!
	@IBOutlet var cameraButton: UIBarButtonItem!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	
	let textDelegate = TextFieldDelegate()
	var meme: Meme?
	
	let memeTextAttributes:[String:Any] = [
		NSStrokeColorAttributeName: UIColor.black,
		NSForegroundColorAttributeName: UIColor.white,
		NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
		NSStrokeWidthAttributeName: "-3.0",
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for field in [topTextField, bottomTextField] {
			field!.defaultTextAttributes = memeTextAttributes
			field!.textAlignment = .center
			field!.delegate = textDelegate
			field!.tag = (field == topTextField) ? 1 : 2
			field!.text = (field == topTextField) ? "TOP" : "BOTTOM"
			field!.autocapitalizationType = .allCharacters
		}
		shareButton.isEnabled = false
		saveButton.isEnabled = false
		
		// If user came here from table view, show the chosen meme in the editor
		guard let meme = self.meme else { return }
		topTextField.text = meme.topString
		bottomTextField.text = meme.bottomString
		pickedImage.image = meme.originalImage
		shareButton.isEnabled = true
		saveButton.isEnabled = true
	}
	
	func save(_ memeImage: UIImage) {
		
		//Generate meme
		let meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, originalImage: pickedImage.image!, memeImage: memeImage)
		
		//Save meme to array
		let object = UIApplication.shared.delegate
		let appDelegate = object as! AppDelegate
		appDelegate.memes.append(meme)
		
		self.meme = meme
	}
	
	func generateMemeImage() -> UIImage {
		barsWillHide()
		
		UIGraphicsBeginImageContext(view.frame.size)
		view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
		let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		barsWillShow()
		
		return memeImage
	}
	
	@IBAction func share(_ sender: UIButton) {
		let image = generateMemeImage()
		let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		controller.completionWithItemsHandler = {(activity, completed, items, error) in
			if(completed) {
				let _ = self.save(image)
			}
		}
		present(controller, animated: true)
	}
	
	func dismissResponder(_ sender: UITextField) {
		textDelegate.textFieldDidEndEditing(sender)
	}
	
	/// MARK: Keyboard configuration
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		subscribeToKeyboardNotifications()
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unsubscribeFromKeyboardNotification()
	}
	
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow , object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	func unsubscribeFromKeyboardNotification() {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
	
	func keyboardWillShow(_ notification: Notification) {
		if bottomTextField.isFirstResponder {
			view.frame.origin.y -= getKeyboardHeight(notification) - toolbar.frame.height
		}
	}
	
	func keyboardWillHide(_ notification: Notification) {
		if bottomTextField.isFirstResponder {
			view.frame.origin.y += getKeyboardHeight(notification) - toolbar.frame.height
		}
	}
	
	func barsWillHide() {
		toolbar.isHidden = true
		navbar.isHidden = true
	}
	
	func barsWillShow() {
		toolbar.isHidden = false
		navbar.isHidden = false
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			pickedImage.image = image
		}
		dismiss(animated: true, completion: nil)
		shareButton.isEnabled = true
		saveButton.isEnabled = true
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func presentImagePicker(_ sender: UIBarButtonItem) {
		let controller = UIImagePickerController()
		controller.delegate = self
		controller.sourceType = (sender.tag == 3) ? .photoLibrary : .camera
		present(controller, animated: true, completion: nil)
	}
	
	@IBAction func onCancelButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onSaveButton(_ sender: UIBarButtonItem) {
		save(generateMemeImage())
	}
}

