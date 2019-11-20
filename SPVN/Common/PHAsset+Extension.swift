//
//  PHAsset+Extension.swift
//  SPVN
//
//  Created by ntq on 11/26/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
}
