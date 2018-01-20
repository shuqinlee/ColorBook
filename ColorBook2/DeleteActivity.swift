//
//  DeleteActivity.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 20/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
protocol DeleteActivityDelegate {
    func didDeleted (deleteActivity: DeleteActivity, index: Int)
    func didChooseDeleteActivity(deleteActivity: DeleteActivity, alertController: UIAlertController) // should use this controller to present
}
class DeleteActivity: UIActivity {
    var image: UIImage?
    var ind: Int?
    var delegate: DeleteActivityDelegate?

    override var activityType: UIActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }
    
    // <# #>< de#de#> placeholder
    override var activityTitle: String? {
        return "Trash"
    }
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "Bin.png") // Bin.png
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let item = item as? UIImage {
                image = item
            }
        }
    }
    
    override func perform() {
        let confirmDeleteAction = UIAlertAction(title: "确认删除", style: .destructive, handler: {
            action in
            self.delegate?.didDeleted(deleteActivity: self, index: self.self.ind!)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(confirmDeleteAction)
        alertController.addAction(cancelAction)
        
        
//        delegate?.didChooseDeleteActivity(deleteActivity: self)
        delegate?.didChooseDeleteActivity(deleteActivity: self, alertController: alertController)
//        present(alertController, animated: true, completion: nil)
        activityDidFinish(true)
    }
    
}
