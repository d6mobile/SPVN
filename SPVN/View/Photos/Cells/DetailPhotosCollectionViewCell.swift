//
//  DetailPhotosCollectionViewCell.swift
//  SPVN
//
//  Created by ntq on 11/26/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

class DetailPhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillDataToCell(_ object: FileModel, nameAlbum: String) {
        if let path = Document().fetPathFileFromDirectory(ConstantKey.photos + "/\(nameAlbum)") {
            self.imageView.image = UIImage(contentsOfFile: path + "/" + object.fileName + ".\(object.fileExtension)")
        }
    }
}
