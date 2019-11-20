//
//  AppLocker.swift
//  SPVN
//
//  Created by DuyDV on 11/18/19.
//  Copyright © 2019 DuyDV. All rights reserved.
//

import UIKit

import UIKit
import AudioToolbox
import LocalAuthentication
import Valet

public enum ALConstants {
    static let nibName = "AppLocker"
    static let kPincode = "pincode" // Key for saving pincode to keychain
    static let kLocalizedReason = "Unlock with sensor" // Your message when sensors must be shown
    static let duration = 0.3 // Duration of indicator filling
    static let maxPinLength = 4
    
    enum button: Int {
        case delete = 1000
        case cancel = 1001
        case face_touch_id = 1002
    }
}

public struct ALAppearance { // The structure used to display the controller
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    public var color: UIColor?
    public var isSensorsEnabled: Bool?
    public init() {}
}

public enum ALMode { // Modes for AppLocker
    case validate
    case change
    case deactive
    case create
}

public class AppLocker: UIViewController {
    
    // MARK: - Top view
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var submessageLabel: UILabel!
    @IBOutlet var pinIndicators: [Indicator]!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cRation: NSLayoutConstraint!
    @IBOutlet weak var sensorButton: UIButton!
    
    static let valet = Valet.valet(with: Identifier(nonEmpty: "Druidia")!, accessibility: .whenUnlockedThisDeviceOnly)
    // MARK: - Pincode
    static let isEmptyPinCode = (AppLocker.valet.string(forKey: ALConstants.kPincode) != nil) ? false : true
    private let context = LAContext()
    private var pin = "" // Entered pincode
    private var reservedPin = "" // Reserve pincode for confirm
    private var isFirstCreationStep = true
    private var savedPin: String? {
        get {
            return AppLocker.valet.string(forKey: ALConstants.kPincode)
        }
        set {
            guard let newValue = newValue else { return }
            AppLocker.valet.set(string: newValue, forKey: ALConstants.kPincode)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        switch Biometric.biometricType() {
        case .face:
            sensorButton.setTitle("Use FaceID", for: .normal)
        case .touch:
            sensorButton.setTitle("Use TouchID", for: .normal)
        default:
            break
        }
        self.sensorButton.isHidden = (AppLocker.valet.string(forKey: ALConstants.kPincode) != nil) ? false : true
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.view.layoutIfNeeded()
        }
    }
    
    static func deletePin() {
        AppLocker.valet.removeObject(forKey: ALConstants.kPincode)
    }
    
    fileprivate var mode: ALMode? {
        didSet {
            let mode = self.mode ?? .validate
            switch mode {
            case .create:
                submessageLabel.text = "Create your passcode" // Your submessage for create mode
            case .change:
                submessageLabel.text = "Enter your passcode" // Your submessage for change mode
            case .deactive:
                submessageLabel.text = "Enter your passcode" // Your submessage for deactive mode
            case .validate:
                submessageLabel.text = "Enter your passcode" // Your submessage for validate mode
                cancelButton.isHidden = true
                isFirstCreationStep = false
            }
        }
    }
    
    private func precreateSettings () { // Precreate settings for change mode
        mode = .create
        clearView()
    }
    
    private func drawing(isNeedClear: Bool, tag: Int? = nil, backgroundColor: UIColor = .white) { // Fill or cancel fill for indicators
        let results = pinIndicators.filter { $0.isNeedClear == isNeedClear }
        let pinView = isNeedClear ? results.last : results.first
        pinView?.isNeedClear = !isNeedClear
        if let view = pinView {
            view.layer.cornerRadius = view.frame.height/2
            view.clipsToBounds = true
            view.layer.borderColor = isNeedClear ? UIColor(rgb: AppColor.shared.tintColorApp).cgColor : backgroundColor.cgColor
        }
        
        UIView.animate(withDuration: ALConstants.duration, animations: {
            pinView?.backgroundColor = isNeedClear ? .white : backgroundColor
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                isNeedClear ? self.pin = String(self.pin.dropLast()) : self.pincodeChecker(tag ?? 0)
            }
        }
    }
    
    private func pincodeChecker(_ pinNumber: Int) {
        if pin.count < ALConstants.maxPinLength {
            pin.append("\(pinNumber)")
            if pin.count == ALConstants.maxPinLength {
                switch mode ?? .validate {
                case .create:
                    createModeAction()
                case .change:
                    changeModeAction()
                case .deactive:
                    deactiveModeAction()
                case .validate:
                    validateModeAction()
                }
            }
        }
    }
    
    // MARK: - Modes
    private func createModeAction() {
        if isFirstCreationStep {
            isFirstCreationStep = false
            reservedPin = pin
            clearView()
            messageLabel.text = "Confirm Passcode"
        } else {
            confirmPin()
        }
    }
    
    private func changeModeAction() {
        pin == savedPin ? precreateSettings() : incorrectPinAnimation()
    }
    
    private func deactiveModeAction() {
        pin == savedPin ? dismissAppLocker() : incorrectPinAnimation()
    }
    
    private func validateModeAction() {
        pin == savedPin ? dismissAppLocker() : incorrectPinAnimation()
    }
    
    private func dismissAppLocker() {
        dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                appDelegate().isLocked = false
            }
        })
    }
    
    private func confirmPin() {
        if pin == reservedPin {
            savedPin = pin
            dismiss(animated: true, completion: nil)
        } else {
            incorrectPinAnimation()
        }
    }
    
    private func incorrectPinAnimation() {
        pinIndicators.forEach { view in
            view.shake(delegate: self)
            view.backgroundColor = .white
            view.layer.borderColor = UIColor(rgb: AppColor.shared.tintColorApp).cgColor
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    fileprivate func clearView(isEmpty: Bool = true) {
        pin = ""
        pinIndicators.forEach { view in
            view.isNeedClear = false
            UIView.animate(withDuration: ALConstants.duration, animations: {
                view.backgroundColor = .white
                guard isEmpty else { return }
                view.layer.borderColor = UIColor(rgb: AppColor.shared.tintColorApp).cgColor
            })
        }
    }
    
    // MARK: - Touch ID / Face ID
    fileprivate func checkSensors() {
        guard mode == .validate else {return}
        
        var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics // iOS 8+ users with Biometric and Custom (Fallback button) verification
        
        // Depending the iOS version we'll need to choose the policy we are able to use
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        }
        
        var err: NSError?
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy, error: &err) else {return}
        
        // The user is able to use his/her Touch ID / Face ID 👍
        context.evaluatePolicy(policy, localizedReason: ALConstants.kLocalizedReason, reply: {  success, error in
            if success {
                DispatchQueue.main.async {
                    self.dismissAppLocker()
                }
            }
        })
    }
    
    // MARK: - Keyboard
    @IBAction func keyboardPressed(_ sender: UIButton) {
        switch sender.tag {
        case ALConstants.button.delete.rawValue:
            drawing(isNeedClear: true)
        case ALConstants.button.cancel.rawValue:
            clearView()
            dismiss(animated: true, completion: nil)
        case ALConstants.button.face_touch_id.rawValue:
            checkSensors()
        default:
            drawing(isNeedClear: false, tag: sender.tag, backgroundColor:UIColor(rgb: AppColor.shared.tintColorApp))
        }
    }
}

// MARK: - CAAnimationDelegate
extension AppLocker: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        clearView()
    }
}

// MARK: - Present
public extension AppLocker {
    // Present AppLocker
    class func present(with mode: ALMode, and config: ALAppearance? = nil, style: UIModalPresentationStyle, animated: Bool) {
        guard let root = UIApplication.shared.keyWindow?.rootViewController,
            
            let locker = Bundle(for: self.classForCoder()).loadNibNamed(ALConstants.nibName, owner: self, options: nil)?.first as? AppLocker else {
                return
        }
        locker.messageLabel.text = config?.title ?? ""
        locker.submessageLabel.text = config?.subtitle ?? ""
        locker.view.backgroundColor = config?.color ?? .black
        locker.mode = mode
        
        if config?.isSensorsEnabled ?? false {
            locker.checkSensors()
        }
        
        if let image = config?.image {
            locker.photoImageView.image = image
        } else {
            locker.photoImageView.isHidden = true
        }
        
        locker.modalPresentationStyle = style
        root.present(locker, animated: animated, completion: nil)
    }
}
