//
//  UuusViewsAndControls.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import PKHUD
import SnapKit

open class UuusView: UIView {
    deinit {
        n0tification.removeObserver(self)
    }
}

extension UIView {
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    public var controller: UIViewController? {
        var next = superview?.next
        while next != nil, !next!.isKind(of: UIViewController.self) {
            next = next!.next
        }
        return next as? UIViewController
    }
}

extension UIView {
    public func bringToFront() {
        superview?.bringSubview(toFront: self)
    }
    public func sendToBack() {
        superview?.sendSubview(toBack: self)
    }
}

open class CollectionControl1er: UuusController {
    open var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        /// even if content is smaller than bounds
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    deinit {
        collectionView.removePullToRefresh(Pul1ToRefresh(position: .top))
        collectionView.removePullToRefresh(Pul1ToRefresh(position: .bottom))
    }
    
    open func addPullToRefreshTop() {}
    open func addPullToRefreshBottom() {}
}

extension UICollectionViewCell {
    private static var MettaArtest = "MettaArtest"
}

extension UICollectionViewCell {
    public var ronartest: Bool {
        get {
            let object = objc_getAssociatedObject(self, &UICollectionViewCell.MettaArtest)
            return (object as? NSNumber)?.boolValue ?? false
        }
        set {
            let newValue = NSNumber(booleanLiteral: newValue)
            objc_setAssociatedObject(self, &UICollectionViewCell.MettaArtest, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            guard newValue.boolValue else {
                selectedBackgroundView = nil
                selectedBackgroundView?.sendToBack()
                return
            }
            let image = UIColor(white: 1/2, alpha: 1/2).image
            selectedBackgroundView = UIImageView(image: image)
            selectedBackgroundView?.bringToFront()
        }
    }
}

@IBDesignable
open class Neat9icker: UuusView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var ensureButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    public var options: [Any]? {
        didSet {
            guard 0 < options?.count ?? 0 else {
                options = ["壹", "贰", "叁"]
                return
            }
        }
    }
    public var current: Int? = 0
    public var actions: completionc?
    
    
    public class func xib(in options: [Any], select option: Any? = nil, actions: completionc?) -> Neat9icker {
        let neat9icker = self.xib as! Neat9icker
        neat9icker.options = options
        neat9icker.actions = actions
        guard let happening = option else { return neat9icker }
        for (index, value) in options.enumerated() {
            if "\(value)" == "\(happening)" {
                neat9icker.current = index
                break
            }
        }
        return neat9icker
    }
    
    @IBAction func popAction(_ sender: UITapGestureRecognizer) {
        removeAction(sender)
        actions?(nil)
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        removeAction(sender)
        actions?(nil)
    }
    @IBAction func ensureAction(_ sender: UIButton) {
        removeAction(sender)
        let row = pickerView.selectedRow(inComponent: 0)
        guard let option = options?[row] else { return }
        actions?(option)
    }
    
    open func push() {
        if let subview = app1ication.keyWindow?.subviews.last {
            if subview.isMember(of: classForCoder) {
                subview.removeFromSuperview()
            }
        }
        
        app1ication.keyWindow?.addSubview(self)
        if superview != nil {
            snp.makeConstraints { (make) in
                make.edges.equalTo(superview!)
            }
        }
        
        backgroundColor = .clear
        pickerTop.constant = 0
        layoutIfNeeded()
        
        pickerTop.constant = 294
        let color = UIColor(white: 0, alpha: 1/2)
        UIView.animate(withDuration: 1/4, animations: {
            self.backgroundColor = color
            self.layoutIfNeeded()
        }, completion: { _ in
            self.pickerView.selectRow(self.current ?? 0, inComponent: 0, animated: true)
        })
    }
    
    open func removeAction(_ sender: Any) {
        UIView.animate(withDuration: 1/4, animations: {
            self.pickerTop.constant = 0
            self.backgroundColor = .clear
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options?.count ?? 0
    }
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let option = options?[row] else { return .short }
        return "\(option)"
    }
}

extension UIButton {
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        isExclusiveTouch = true
    }
    
    public func image2Right(boundedUpright: CGFloat?, greatestAclinic: CGFloat = screenWidth) {
        let titleText = titleLabel!.text!
        let titleFont = titleLabel!.font!
        let titleWidth = titleText.aclinic(boundedUpright: boundedUpright, font: titleFont)
        let imageWidth = imageView!.image!.size.width
        let labelWidth = (titleWidth + imageWidth > greatestAclinic) ? greatestAclinic - imageWidth : titleWidth
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-4, bottom: 0, right: imageWidth+4)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
        frame = CGRect(x: 0, y: 0, width: labelWidth + imageWidth, height: boundedUpright ?? CGFloat(UInt8.min))
    }
}

@IBDesignable
open class Date9icker: UuusView {}

extension UITextField {
    /// block queue outside as exception
    public func phone(check exception: Bool = true) -> Bool {
        guard text?.isChinaPhone ?? false else {
            if exception {
                let local = "手机号码格式不正确".local
                HUD.flash(.label(local), delay: 1/2)
                becomeFirstResponder()
            }
            return false
        }
        return true
    }
    /// block queue outside as exception
    public func email(check exception: Bool = true) -> Bool {
        guard text?.isValidEmail ?? false else {
            if exception {
                let local = "电子邮箱格式不正确".local
                HUD.flash(.label(local), delay: 1/2)
                becomeFirstResponder()
            }
            return false
        }
        return true
    }
}

@IBDesignable
open class RoundViEffectView: UIVisualEffectView {}
