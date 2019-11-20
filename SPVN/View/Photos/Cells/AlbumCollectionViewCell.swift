//
//  AlbumCollectionViewCell.swift
//  SPVN
//
//  Created by ntq on 11/20/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillDataToCell(_ title: String) {
        image = UIImage(color: UIColor(red: 54/255, green: 55/255, blue: 70/255, alpha: 1)) 
        self.titleLabel.text = title
        if let object = Document().fetListFileFromDirectory(name: ConstantKey.photos + "/\(title)") {
            self.countLabel.text = "\(object.count)"
        }
    }
}
