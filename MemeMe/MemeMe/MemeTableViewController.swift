//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by ÅF Jacob Taxén on 2017-03-13.
//  Copyright © 2017 Jazze and the Tazzers. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var memes: [Meme] {
		return (UIApplication.shared.delegate as! AppDelegate).memes
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
		let meme = memes[indexPath.row]
		cell.textLabel?.text = meme.topString+" "+meme.bottomString
		cell.imageView?.image = meme.memeImage
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
		let meme = memes[indexPath.row]
		controller.meme = meme
		present(controller, animated: true, completion: nil)
	}
	
	@IBAction func newMeme(_ sender: UIBarButtonItem) {
		let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
		present(controller, animated: true, completion: nil)
	}
}
