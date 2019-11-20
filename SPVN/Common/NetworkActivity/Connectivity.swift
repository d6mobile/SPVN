//
//  Connectivity.swift
//  Music Apps
//
//  Created by DuyDV on 11/28/18.
//  Copyright © 2018 DuyDV. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
