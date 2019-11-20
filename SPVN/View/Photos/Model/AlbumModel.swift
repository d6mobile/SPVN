//
//  AlbumModel.swift
//  SPVN
//
//  Created by ntq on 11/20/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

final class AlbumModel: NSObject, NSCoding {
    var title = ""
    var date = Date()
    
    init(iTitle: String) {
        self.title = iTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: ConstantKey.title) as? String ?? ""
        self.date = aDecoder.decodeObject(forKey: ConstantKey.date) as? Date ?? Date()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: ConstantKey.title)
        aCoder.encode(self.date, forKey: ConstantKey.date)
    }
}

