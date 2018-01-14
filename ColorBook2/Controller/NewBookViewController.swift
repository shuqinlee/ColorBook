//
//  NewBookViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 14/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
fileprivate let identifier = "BookImageCell"

protocol NewBookViewControllerDelegate {
    func newBookViewController(newBookViewController: NewBookViewController, rawBook: RawBook)
}

class NewBookViewController: UIViewController {
    // MARK: - outlet variables
    
    @IBOutlet weak var bookNameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - outlet methods
    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIBarButtonItem) {
        // save
        delegate?.newBookViewController(newBookViewController: self, rawBook: rawBook)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - none outlets
    var rawBook: RawBook!
    var imageList = [UIImage]()
    let imageNameList = ["elephant", "fox", "hedgehogs", "monkey", "mountain", "mouse", "owl", "rabbit",
                         "tortoise", "winter", "witch"]
    var delegate: NewBookViewControllerDelegate?
    
    // MARK: - methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for name in imageNameList {
            if let image = UIImage(named: name) {
                imageList.append(image)
            }
        }
        
        if rawBook == nil {
            rawBook = RawBook()
            rawBook.id = NSUUID().uuidString
//            rawBook.paintingList = [RawPainting]()
            rawBook.createDate = Date()
            rawBook.name = "Color Book"
            rawBook.cover = imageList[0]
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        bookNameTextField.delegate = self
        
        bookNameTextField.attributedPlaceholder =  NSAttributedString(string: "", attributes:[NSAttributedStringKey.foregroundColor: UIColor.clear])
        imageView.image = rawBook.cover
        bookNameTextField.text = rawBook.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: - extensions
extension NewBookViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count + rawBook.paintingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! BookImageCollectionViewCell
        let row = indexPath.row
        if row < imageList.count {
            cell.imageView.image = imageList[row]
        } else {
            cell.imageView.image = rawBook.paintingList[row - imageList.count].painting
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let image: UIImage!
        if row < imageList.count {
            image = imageList[row]
            rawBook.cover = imageList[row]
        } else {
            if let painting = rawBook.paintingList[row - imageList.count].painting {
                image = painting
            } else {
                image = rawBook.paintingList[row - imageList.count].raw
            }
        }
        self.imageView.image = image
        rawBook.cover? = image
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension NewBookViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rawBook.name = textField.text ?? "Color Book"
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rawBook.name = textField.text ?? "Color Book"
    }
}

