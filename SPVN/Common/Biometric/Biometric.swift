//
//  Biometric.swift
//  SPVN
//
//  Created by DuyDV on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import Foundation
import LocalAuthentication

struct Biometric {
    static func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            fatalError()
        }
    }
}

enum BiometricType {
    case none
    case touch
    case face
}


