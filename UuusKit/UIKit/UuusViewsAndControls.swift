//
//  UuusViewsAndControls.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import PKHUD
import RxCocoa
import RxSwift
import SnapKit

open class UuusView: UIView {
    open var disposeBag = DisposeBag()

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

    @IBInspectable open var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable open var borderColor: UIColor {
        get {
            return layer.borderColor?.uiColor ?? .clear
        }
        set {
            layer.borderColor = newValue.cgColor
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
    public func blotWindow() {
        if let subview = app1ication.keyWindow?.subviews.last {
            if subview.isMember(of: classForCoder) {
                subview.removeFromSuperview()
            }
        }

        app1ication.keyWindow?.addSubview(self)
        if superview != nil {
            snp.makeConstraints { make in
                make.edges.equalTo(superview!)
            }
        }
    }

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
        collectionView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaInsets)
            } else {
                make.edges.equalTo(view)
            }
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
            let image = UIColor(white: 0.5, alpha: 0.5).image
            selectedBackgroundView = UIImageView(image: image)
            selectedBackgroundView?.bringToFront()
        }
    }
}

@IBDesignable
open class Neat9icker: UuusView, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var pickerTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var ensureButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!

    public var options: [Any]? {
        didSet {
            if 0 < options?.count ?? 0 {
                return
            }
            options = ["壹", "贰", "叁"]
        }
    }

    public var current: Int? = 0
    public var actions: completionc?

    public class func xib(in options: [Any], select option: Any? = nil, actions: completionc?) -> Neat9icker {
        let neat9icker = self.xib as! Neat9icker
        neat9icker.tapGesture.rx.event.bind { [unowned neat9icker] sender in
            neat9icker.removeAction(sender)
            neat9icker.actions?(nil)
        }.disposed(by: neat9icker.disposeBag)
        neat9icker.cancelButton.rx.tap.bind { [unowned neat9icker] sender in
            neat9icker.removeAction(sender)
            neat9icker.actions?(nil)
        }.disposed(by: neat9icker.disposeBag)
        neat9icker.ensureButton.rx.tap.bind { [unowned neat9icker] sender in
            neat9icker.removeAction(sender)
            guard let index = neat9icker.current else { return }
            neat9icker.actions?(neat9icker.options![index])
        }.disposed(by: neat9icker.disposeBag)
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

    open func push() {
        blotWindow()

        backgroundColor = .clear
        pickerTop.constant = 0
        layoutIfNeeded()

        pickerTop.constant = 294
        let color = UIColor(white: 0, alpha: 0.5)
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = color
            self.layoutIfNeeded()
        }, completion: { _ in
            self.pickerView.selectRow(self.current ?? 0, inComponent: 0, animated: true)
        })
    }

    open func removeAction(_: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerTop.constant = 0
            self.backgroundColor = .clear
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    open func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    open func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return options?.count ?? 0
    }

    open func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let option = options?[row] else { return .short }
        return "\(option)"
    }

    open func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        current = row
    }
}

@IBDesignable
open class Area9icker: UuusView, UIPickerViewDataSource, UIPickerViewDelegate {
    public enum `Type`: Int {
        case province
        case city
        case district
    }

    public struct Part {
        public var options: [Any]?
        public var current: Int?

        /// the chosen name
        public var address: String {
            return options(forKey: "name") as! String
        }

        /// the chosen five
        public var five: [String]? {
            return options(forKey: "five") as? [String]
        }

        /// the chosen area
        public var area: [[String: Any]]? {
            return options(forKey: "area") as? [[String: Any]]
        }

        /// the chosen city
        public var city: [[String: Any]]? {
            return options(forKey: "city") as? [[String: Any]]
        }

        public init(options: [Any]? = nil, title: String? = nil) {
            self.options = options
            guard let name = title else { return }
            guard let array = options else { return }
            for (index, value) in array.enumerated() {
                if let dict = value as? [String: Any] {
                    if name == dict["name"] as! String {
                        self.current = index
                        break
                    }
                }
                if name == value as? String ?? .empty {
                    self.current = index
                    break
                }
            }
        }

        public func options(forKey key: String) -> Any? {
            guard let count = options?.count else { return nil }
            guard let index = current, index < count else {
                if let dict = options as? [[String: Any]] {
                    guard dict[0].keys.contains(key) else {
                        return nil
                    }
                    return dict[0][key]
                }
                return options![0]
            }
            if let dict = options as? [[String: Any]] {
                guard dict[index].keys.contains(key) else {
                    return nil
                }
                return dict[index][key]
            }
            return options![index]
        }

        public func address(forRow row: Int) -> String! {
            if let dict = options as? [[String: Any]] {
                return dict[row]["name"] as! String
            }
            return options![row] as! String
        }
    }

    public struct Area {
        public var province: Part?
        public var city: Part?
        public var district: Part?

        public var address: String {
            let p = province?.address ?? .empty
            let c = city?.address ?? .empty
            let d = district?.address ?? .empty
            return (p == c ? p : p + c) + d
        }

        private(set) lazy var provinces: [[String: Any]] = {
            let area = "UuusArea"
            let main = Bundle(for: Area9icker.self)
            let path = main.path(forResource: area, ofType: "plist")
            return NSArray(contentsOfFile: path!) as! [[String: Any]]
        }()

        init(province: String? = nil, city: String? = nil, district: String? = nil) {
            self.province = Part(options: provinces, title: province)
            self.city = Part(options: self.province?.city, title: city)
            self.district = Part(options: self.city?.area, title: district)
        }
    }

    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var pickerTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var ensureButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!

    public var address: Area?
    public var actions: completionc?

    public class func xib(select province: String? = nil, city: String? = nil, district: String? = nil, actions: completionc?) -> Area9icker {
        let area9icker = self.xib as! Area9icker
        area9icker.tapGesture.rx.event.bind { [unowned area9icker] sender in
            area9icker.removeAction(sender)
            area9icker.actions?(nil)
        }.disposed(by: area9icker.disposeBag)
        area9icker.cancelButton.rx.tap.bind { [unowned area9icker] sender in
            area9icker.removeAction(sender)
            area9icker.actions?(nil)
        }.disposed(by: area9icker.disposeBag)
        area9icker.ensureButton.rx.tap.bind { [unowned area9icker] sender in
            area9icker.removeAction(sender)
            area9icker.actions?(area9icker.address)
        }.disposed(by: area9icker.disposeBag)
        area9icker.address = Area(province: province, city: city, district: district)
        area9icker.actions = actions
        return area9icker
    }

    open func push() {
        blotWindow()

        backgroundColor = .clear
        pickerTop.constant = 0
        layoutIfNeeded()

        pickerTop.constant = 294
        let color = UIColor(white: 0, alpha: 0.5)
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = color
            self.layoutIfNeeded()
        }, completion: { _ in
            if let p = self.address?.province, 0 < p.options?.count ?? 0 {
                self.pickerView.selectRow(p.current ?? 0, inComponent: Type.province.hashValue, animated: true)
            }
            if let c = self.address?.city, 0 < c.options?.count ?? 0 {
                self.pickerView.selectRow(c.current ?? 0, inComponent: Type.city.hashValue, animated: true)
            }
            if let d = self.address?.district, 0 < d.options?.count ?? 0 {
                self.pickerView.selectRow(d.current ?? 0, inComponent: Type.district.hashValue, animated: true)
            }
        })
    }

    open func removeAction(_: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerTop.constant = 0
            self.backgroundColor = .clear
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    open func numberOfComponents(in _: UIPickerView) -> Int {
        return 3
    }

    open func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Type(rawValue: component)! {
        case .province:
            return address?.province?.options?.count ?? 0
        case .city:
            return address?.city?.options?.count ?? 0
        case .district:
            return address?.district?.options?.count ?? 0
        }
    }

    open func pickerView(_: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        switch Type(rawValue: component)! {
        case .province:
            label.text = address?.province?.address(forRow: row)
        case .city:
            label.text = address?.city?.address(forRow: row)
        case .district:
            label.text = address?.district?.address(forRow: row)
        }
        let size = UIFont.buttonFontSize
        label.font = UIFont.systemFont(ofSize: size, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.69
        return label
    }

    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch Type(rawValue: component)! {
        case .province:
            address = Area(province: address?.province?.address(forRow: row), city: nil, district: nil)
            pickerView.reloadComponent(Type.city.hashValue)
            if let c = address?.city, 0 < c.options?.count ?? 0 {
                pickerView.selectRow(c.current ?? 0, inComponent: Type.city.hashValue, animated: true)
            }
            pickerView.reloadComponent(Type.district.hashValue)
            if let d = address?.district, 0 < d.options?.count ?? 0 {
                pickerView.selectRow(d.current ?? 0, inComponent: Type.district.hashValue, animated: true)
            }
        case .city:
            address?.city?.current = row
            address?.district = Part(options: address?.city?.area, title: nil)
            pickerView.reloadComponent(Type.district.hashValue)
            if let d = address?.district, 0 < d.options?.count ?? 0 {
                pickerView.selectRow(d.current ?? 0, inComponent: Type.district.hashValue, animated: true)
            }
        case .district:
            address?.district?.current = row
        }
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
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - 4, bottom: 0, right: imageWidth + 4)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
        frame = CGRect(x: 0, y: 0, width: labelWidth + imageWidth, height: boundedUpright ?? CGFloat(UInt8.min))
    }
}

@IBDesignable
open class Date9icker: UuusView {
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var pickerTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var ensureButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    public var predate: Date?
    public var actions: completionc?

    public class func xib(select date: Date? = nil, actions: completionc?) -> Date9icker {
        let date9icker = self.xib as! Date9icker
        date9icker.tapGesture.rx.event.bind { [unowned date9icker] sender in
            date9icker.removeAction(sender)
            date9icker.actions?(nil)
        }.disposed(by: date9icker.disposeBag)
        date9icker.cancelButton.rx.tap.bind { [unowned date9icker] sender in
            date9icker.removeAction(sender)
            date9icker.actions?(nil)
        }.disposed(by: date9icker.disposeBag)
        date9icker.ensureButton.rx.tap.bind { [unowned date9icker] sender in
            date9icker.removeAction(sender)
            date9icker.actions?(date9icker.datePicker.date)
        }.disposed(by: date9icker.disposeBag)
        date9icker.predate = date
        date9icker.actions = actions
        return date9icker
    }

    open func push() {
        blotWindow()

        backgroundColor = .clear
        pickerTop.constant = 0
        layoutIfNeeded()

        pickerTop.constant = 294
        let color = UIColor(white: 0, alpha: 0.5)
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = color
            self.layoutIfNeeded()
        }, completion: { _ in
            if let predate = self.predate {
                self.datePicker.setDate(predate, animated: true)
            }
        })
    }

    open func removeAction(_: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.pickerTop.constant = 0
            self.backgroundColor = .clear
            self.layoutIfNeeded()
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

extension UITextField {
    /// block queue outside as exception
    public func phone(check exception: Bool = true) -> Bool {
        guard text?.isChinaPhone ?? false else {
            if exception {
                let local = "手机号码格式不正确".local
                HUD.flash(.label(local), delay: 0.5)
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
                HUD.flash(.label(local), delay: 0.5)
                becomeFirstResponder()
            }
            return false
        }
        return true
    }
}

@IBDesignable
open class RoundViEffectView: UIVisualEffectView {}
