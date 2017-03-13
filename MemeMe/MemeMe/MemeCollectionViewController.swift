//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by ÅF Jacob Taxén on 2017-03-13.
//  Copyright © 2017 Jazze and the Tazzers. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
	
//	@IBOutlet weak var memeCell: MemeCollectionViewCell!
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var memes: [Meme]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		memes = appDelegate.memes
		
		let space: CGFloat = 0.5
		let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
		
		flowLayout.minimumInteritemSpacing = space
		flowLayout.minimumLineSpacing = space
		flowLayout.itemSize = CGSize(width: dimension, height: dimension)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		collectionView?.reloadData()
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MemeCollectionViewCell
		let meme = memes[indexPath.row]
		cell.image.image = meme.memeImage
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
		let meme = memes[indexPath.row]
		controller.meme = meme
		present(controller, animated: true, completion: nil)
	}

	@IBAction func addMeme(_ sender: UIBarButtonItem) {
		let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditorViewController
		present(controller, animated: true, completion: nil)
		
	}
}
