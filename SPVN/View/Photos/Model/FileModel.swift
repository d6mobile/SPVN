//
//  FileModel.swift
//  SPVN
//
//  Created by ntq on 11/26/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit
import Photos

final class FileModel: NSObject, NSCoding {
    
    var fileName: String = ""
    var fileSize: UInt64 = 0
    var fileExtension: String = ""
    
    override init() {
        super.init()
    }
    
    init(iFileName: String, iFileSize: UInt64, iFileExtension: String) {
        
        self.fileName = iFileName
        self.fileSize = iFileSize
        self.fileExtension = iFileExtension
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.fileName = aDecoder.decodeObject(forKey: "fileName") as? String ?? ""
        self.fileSize = aDecoder.decodeObject(forKey: "fileSize") as? UInt64 ?? 0
        self.fileExtension = aDecoder.decodeObject(forKey: "fileExtension") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fileName, forKey: "fileName")
        aCoder.encode(self.fileSize, forKey: "fileSize")
        aCoder.encode(self.fileExtension, forKey: "fileExtension")
    }
}
