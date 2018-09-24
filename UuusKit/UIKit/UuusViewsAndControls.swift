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
    // MARK: - Deinitialization

    deinit {
        notificationc.removeObserver(self)
    }

    // MARK: - Properties

    open var disposeBag = DisposeBag()
}

extension UIView {
    // MARK: - IBInspectable

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

    @IBInspectable open var shadowColor: UIColor {
        get {
            return layer.shadowColor?.uiColor ?? .clear
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }

    @IBInspectable open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    // MARK: - Properties

    public var controller: UIViewController! {
        var next = superview?.next
        while next != nil, !next!.isKind(of: UIViewController.self) {
            next = next!.next
        }
        return (next as! UIViewController)
    }
}

extension UIView {
    // MARK: - Public - Functions

    public func blotWindow() {
        if let subview = uiapplication.keyWindow?.subviews.last {
            if subview.isMember(of: classForCoder) {
                subview.removeFromSuperview()
            }
        }

        uiapplication.keyWindow!.addSubview(self)
        if superview != nil {
            snp.makeConstraints { make in
                make.edges.equalTo(superview!)
            }
        }
    }

    public func bringToFront() {
        superview?.bringSubviewToFront(self)
    }

    public func sendToBack() {
        superview?.sendSubviewToBack(self)
    }
}

open class CollectionViewControllor: UICollectionViewController {
    // MARK: - Deinitialization

    deinit {
        notificationc.removeObserver(self)
        collectionView?.removePullToRefresh(at: .top)
        collectionView?.removePullToRefresh(at: .bottom)
    }

    // MARK: - Properties

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMaskAll ? .all : .portrait
    }

    open var disposeBag = DisposeBag()

    // MARK: - View Handling

    open override func viewDidLoad() {
        initBackBarButtonPure()
        super.viewDidLoad()
        /// even if content is smaller than bounds
        collectionView?.alwaysBounceVertical = true
    }

    // MARK: - Public - Functions

    open override func tryPullToRefreshBottom(last remove: Bool = true) {
        if remove {
            collectionView?.removePullToRefresh(at: .bottom)
        } else if collectionView?.bottomPullToRefresh == nil {
            addPullToRefreshBottom()
        }
    }
}

extension UICollectionViewCell {
    // MARK: - Properties

    private static var MettaArtest = "MettaArtest"

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

open class TableViewControllor: UITableViewController {
    // MARK: - Deinitialization

    deinit {
        notificationc.removeObserver(self)
        tableView.removePullToRefresh(at: .top)
        tableView.removePullToRefresh(at: .bottom)
    }

    // MARK: - Properties

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMaskAll ? .all : .portrait
    }

    open var disposeBag = DisposeBag()

    // MARK: - View Handling

    open override func viewDidLoad() {
        initBackBarButtonPure()
        super.viewDidLoad()
    }

    // MARK: - Public - Functions

    open override func tryPullToRefreshBottom(last remove: Bool = true) {
        if remove {
            tableView.removePullToRefresh(at: .bottom)
        } else if tableView.bottomPullToRefresh == nil {
            addPullToRefreshBottom()
        }
    }
}

open class TableViowCell: UITableViewCell {
    // MARK: - Properties

    public var maximum: CGFloat = 0
    public var spacing: CGFloat = 0

    // MARK: - View Handling

    open override func layoutSubviews() {
        super.layoutSubviews()
        if spacing > 0 {
            frame.origin.x = spacing
            let width = maximum - spacing * 2
            frame.size.width = width
        }
    }
}

open class Uuus9icker: UuusView {
    // MARK: - Classes and Structures

    public struct Part {
        // MARK: - Initialization

        public init(options: [Any]? = nil, index: Int? = nil, title: String? = nil) {
            self.options = options
            if let index = index {
                current = index
                return
            }
            guard let name = title else { return }
            guard let array = options else { return }
            for (index, value) in array.enumerated() {
                if let dict = value as? [String: Any] {
                    if name == dict["name"] as! String {
                        current = index
                        break
                    }
                }
                if name == value as? String {
                    current = index
                    break
                }
            }
        }

        // MARK: - Properties

        public var options: [Any]?
        public var current: Int?

        /// the chosen name
        public var name: String {
            return options(forKey: "name") as! String
        }

        /// the chosen five
        public var five: [String]? {
            return options(forKey: "five") as? [String]
        }

        /// the chosen date
        public var date: [[String: Any]]? {
            return options(forKey: "date") as? [[String: Any]]
        }

        /// the chosen week
        public var week: [[String: Any]]? {
            return options(forKey: "week") as? [[String: Any]]
        }

        /// the chosen area
        public var area: [[String: Any]]? {
            return options(forKey: "area") as? [[String: Any]]
        }

        /// the chosen city
        public var city: [[String: Any]]? {
            return options(forKey: "city") as? [[String: Any]]
        }

        // MARK: - Public - Functions

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
                return (dict[row]["name"] as! String)
            }
            return (options![row] as! String)
        }
    }

    // MARK: - IBOutlets

    @IBOutlet public var tapGesture: UITapGestureRecognizer!
    @IBOutlet public var downGesture: UISwipeGestureRecognizer!
    @IBOutlet public var pickerTop: NSLayoutConstraint!
    @IBOutlet public var titleLabel: UILabel!
    @IBOutlet public var cancelButton: UIButton!
    @IBOutlet public var ensureButton: UIButton!

    // MARK: - Closures

    public var actions: completionc?

    // MARK: - Properties

    public var sbottom: CGFloat = 0

    // MARK: - View Handling

    open override func awakeFromNib() {
        super.awakeFromNib()
        tapGesture.rx.event.bind { [unowned self] sender in
            self.removeAction(sender)
            self.actions?(nil)
        }.disposed(by: disposeBag)
        downGesture.rx.event.bind { [unowned self] sender in
            self.removeAction(sender)
            self.actions?(nil)
        }.disposed(by: disposeBag)
        cancelButton.rx.tap.bind { [unowned self] sender in
            self.removeAction(sender)
            self.actions?(nil)
        }.disposed(by: disposeBag)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11.0, *) {
            if sbottom == rootground.view.safeAreaInsets.bottom {
                return
            }
            sbottom = rootground.view.safeAreaInsets.bottom
            pickerTop.constant = sbottom + (iPhoneX ? 206 : 216)
        }
    }

    // MARK: - Public - Functions

    open func push() {
        blotWindow()

        if #available(iOS 11.0, *) {
            sbottom = rootground.view.safeAreaInsets.bottom
        }
        backgroundColor = .clear
        pickerTop.constant = 0
        layoutIfNeeded()

        pickerTop.constant = sbottom + (iPhoneX ? 206 : 216)
        let color = UIColor(white: 0, alpha: 0.4)
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = color
            self.layoutIfNeeded()
        }
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

open class Neat9icker: Uuus9icker, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - IBOutlets

    @IBOutlet public var pickerView: UIPickerView!

    // MARK: - Initialization

    public class func xib(in options: [Any], select option: Any? = nil, actions: completionc?) -> Neat9icker {
        let neat9icker = xib as! Neat9icker
        neat9icker.ensureButton.rx.tap.bind { [unowned neat9icker] sender in
            neat9icker.removeAction(sender)
            if let index = neat9icker.current {
                neat9icker.actions?(neat9icker.options![index])
            }
        }.disposed(by: neat9icker.disposeBag)
        neat9icker.options = options
        neat9icker.actions = actions

        guard let happening = option else { return neat9icker }
        DispatchQueue.global().async {
            for (index, value) in options.enumerated() {
                if "\(value)" == "\(happening)" {
                    neat9icker.current = index
                    break
                }
            }
            DispatchQueue.main.async {
                neat9icker.pickerView.selectRow(neat9icker.current ?? 0, inComponent: 0, animated: true)
            }
        }
        return neat9icker
    }

    // MARK: - Properties

    public var options: [Any]? {
        didSet {
            if 0 < options?.count ?? 0 {
                return
            }
            options = ["壹", "贰", "叁"]
        }
    }

    public var current: Int? = 0

    // MARK: - UIPickerViewDataSource

    open func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    open func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return options?.count ?? 0
    }

    // MARK: - UIPickerViewDelegate

    open func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let option = options?[row] else { return .short }
        return "\(option)"
    }

    open func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        current = row
    }
}

open class Week9icker: Uuus9icker, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Enumerations

    public enum `Type`: Int {
        case year
        case week
    }

    // MARK: - Classes and Structures

    public struct Week {
        // MARK: - Initialization

        public init(date: Date? = nil, year: String? = nil, week: String? = nil) {
            var year = year
            if let int = date?.value(for: .year) {
                year = "\(int)"
            }
            self.year = Part(options: years, title: year)
            self.week = Part(options: self.year?.week, title: week)

            guard let mondate = date?.mondate else { return }
            guard let array = self.week?.options else { return }
            for (index, value) in array.enumerated() {
                if let dict = value as? [String: Any] {
                    let monday = mondate.string(as: [.MMyddr])
                    if (dict["name"] as! String).contains(monday) {
                        self.week?.current = index
                        break
                    }
                }
            }
        }

        // MARK: - Lazy Initialization

        private(set) lazy var years: [[String: Any]] = {
            let week = "UuusWeek"
            let main = Bundle(for: Week9icker.self)
            let path = main.path(forResource: week, ofType: "plist")
            return NSArray(contentsOfFile: path!) as! [[String: Any]]
        }()

        // MARK: - Properties

        public var year: Part?
        public var week: Part?

        // MARK: - Public - Functions

        /// print(Week9icker.Week.allYearJsonInRecent().data!.string!)
        /// plutil -convert xml1 UuusWeek.json -o UuusWeek.plist
        public static func allYearJsonInRecent() -> [[String: Any]] {
            let yearInterval = (1970, 2100)
            var allYear = [[String: Any]]()
            for index in yearInterval.0 ... yearInterval.1 {
                let allWeek = Week.allWeek(of: index)
                allYear.append(["name": "\(index)", "week": allWeek])
            }
            return allYear
        }

        public static func allWeek(of year: Int) -> [[String: Any]] {
            var weekInterval = (1, 53)

            let ccomponent: Set<Calendar.Component> = [
                .year, .month, .day, .yearForWeekOfYear, .weekOfYear,
            ]

            var leftComponents = DateComponents()
            leftComponents.yearForWeekOfYear = year
            leftComponents.weekOfYear = weekInterval.0
            leftComponents.weekday = 5 // Thursday
            let dateLeft = ccalendar.date(from: leftComponents)!
            leftComponents = ccalendar.dateComponents(ccomponent, from: dateLeft)
            if leftComponents.year != year {
                weekInterval = (weekInterval.0 + 1, weekInterval.1)
            }

            var lastComponents = DateComponents()
            lastComponents.yearForWeekOfYear = year
            lastComponents.weekOfYear = weekInterval.1
            lastComponents.weekday = 5 // Thursday
            let dateLast = ccalendar.date(from: lastComponents)!
            lastComponents = ccalendar.dateComponents(ccomponent, from: dateLast)
            if lastComponents.year != year {
                weekInterval = (weekInterval.0, weekInterval.1 - 1)
            }

            var allWeek = [[String: Any]]()
            for index in weekInterval.0 ... weekInterval.1 {
                var dateComponents = DateComponents()
                dateComponents.yearForWeekOfYear = year
                dateComponents.weekOfYear = index
                dateComponents.weekday = 6
                let date = ccalendar.date(from: dateComponents)!
                let mondate = date.mondate
                let tuesdate = mondate.tomorrow
                let wednesdate = tuesdate.tomorrow
                let thursdate = wednesdate.tomorrow
                let fridate = thursdate.tomorrow
                let saturdate = fridate.tomorrow
                let sundate = saturdate.tomorrow
                let oneWeek = [
                    ["name": mondate.timestamp],
                    ["name": tuesdate.timestamp],
                    ["name": wednesdate.timestamp],
                    ["name": thursdate.timestamp],
                    ["name": fridate.timestamp],
                    ["name": saturdate.timestamp],
                    ["name": sundate.timestamp],
                ]
                let monday = mondate.string(as: [.MMyddr])
                let sunday = sundate.string(as: [.MMyddr])
                let weekof = index - weekInterval.0 + 1
                let name = "第\(weekof)周, \(monday)~\(sunday)"
                allWeek.append(["name": name, "date": oneWeek])
            }

            return allWeek
        }
    }

    // MARK: - IBOutlets

    @IBOutlet public var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet public var pickerView: UIPickerView!

    // MARK: - Initialization

    public class func xib(select date: Date? = nil, year: String? = nil, week: String? = nil, actions: completionc?) -> Week9icker {
        let week9icker = xib as! Week9icker
        week9icker.ensureButton.rx.tap.bind { [unowned week9icker] sender in
            week9icker.removeAction(sender)
            week9icker.actions?(week9icker.current)
        }.disposed(by: week9icker.disposeBag)

        DispatchQueue.global().async {
            week9icker.current = Week(date: date, year: year, week: week)
            DispatchQueue.main.async {
                week9icker.pickerView.reloadAllComponents()
                week9icker.activityIndicatorView.stopAnimating()
                if let y = week9icker.current?.year, 0 < y.options?.count ?? 0 {
                    week9icker.pickerView.selectRow(y.current ?? 0, inComponent: Type.year.hashValue, animated: true)
                }
                if let w = week9icker.current?.week, 0 < w.options?.count ?? 0 {
                    week9icker.pickerView.selectRow(w.current ?? 0, inComponent: Type.week.hashValue, animated: true)
                }
            }
        }
        week9icker.actions = actions
        return week9icker
    }

    // MARK: - Properties

    public var current: Week?

    // MARK: - UIPickerViewDataSource

    open func numberOfComponents(in _: UIPickerView) -> Int {
        return 2
    }

    open func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch Type(rawValue: component)! {
        case .year:
            return current?.year?.options?.count ?? 0
        case .week:
            return current?.week?.options?.count ?? 0
        }
    }

    // MARK: - UIPickerViewDelegate

    open func pickerView(_: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch Type(rawValue: component)! {
        case .year:
            return min(screenWidth, screenHeight) * 0.18
        case .week:
            return min(screenWidth, screenHeight) * 0.76
        }
    }

    open func pickerView(_: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()
        switch Type(rawValue: component)! {
        case .year:
            label.text = current?.year?.address(forRow: row)
        case .week:
            label.text = current?.week?.address(forRow: row)
        }
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }

    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch Type(rawValue: component)! {
        case .year:
            current?.year?.current = row
            let options = current?.year?.week
            current?.week = Part(options: options, title: nil)
            pickerView.reloadComponent(Type.week.hashValue)
            if let w = current?.week, 0 < w.options?.count ?? 0 {
                pickerView.selectRow(w.current ?? 0, inComponent: Type.week.hashValue, animated: true)
            }
        case .week:
            current?.week?.current = row
        }
    }
}

open class Area9icker: Uuus9icker, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Enumerations

    public enum `Type`: Int {
        case province
        case city
        case district
    }

    // MARK: - Classes and Structures

    public struct Area {
        // MARK: - Initialization

        public init(province: String? = nil, city: String? = nil, district: String? = nil) {
            self.province = Part(options: provinces, title: province)
            self.city = Part(options: self.province?.city, title: city)
            self.district = Part(options: self.city?.area, title: district)
        }

        // MARK: - Lazy Initialization

        private(set) lazy var provinces: [[String: Any]] = {
            let area = "UuusArea"
            let main = Bundle(for: Area9icker.self)
            let path = main.path(forResource: area, ofType: "plist")
            return NSArray(contentsOfFile: path!) as! [[String: Any]]
        }()

        // MARK: - Properties

        public var province: Part?
        public var city: Part?
        public var district: Part?

        public var address: String {
            let p = province?.name ?? .empty
            let c = city?.name ?? .empty
            let d = district?.name ?? .empty
            return (p == c ? p : p + c) + d
        }
    }

    // MARK: - IBOutlets

    @IBOutlet public var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet public var pickerView: UIPickerView!

    // MARK: - Initialization

    public class func xib(select province: String? = nil, city: String? = nil, district: String? = nil, actions: completionc?) -> Area9icker {
        let area9icker = xib as! Area9icker
        area9icker.ensureButton.rx.tap.bind { [unowned area9icker] sender in
            area9icker.removeAction(sender)
            area9icker.actions?(area9icker.address)
        }.disposed(by: area9icker.disposeBag)

        DispatchQueue.global().async {
            area9icker.address = Area(province: province, city: city, district: district)
            DispatchQueue.main.async {
                area9icker.pickerView.reloadAllComponents()
                area9icker.activityIndicatorView.stopAnimating()
                if let p = area9icker.address?.province, 0 < p.options?.count ?? 0 {
                    area9icker.pickerView.selectRow(p.current ?? 0, inComponent: Type.province.hashValue, animated: true)
                }
                if let c = area9icker.address?.city, 0 < c.options?.count ?? 0 {
                    area9icker.pickerView.selectRow(c.current ?? 0, inComponent: Type.city.hashValue, animated: true)
                }
                if let d = area9icker.address?.district, 0 < d.options?.count ?? 0 {
                    area9icker.pickerView.selectRow(d.current ?? 0, inComponent: Type.district.hashValue, animated: true)
                }
            }
        }
        area9icker.actions = actions
        return area9icker
    }

    // MARK: - Properties

    public var address: Area?

    // MARK: - UIPickerViewDataSource

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

    // MARK: - UIPickerViewDelegate

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
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        return label
    }

    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch Type(rawValue: component)! {
        case .province:
            address?.province?.current = row
            let optionz = address?.province?.city
            address?.city = Part(options: optionz, title: nil)
            pickerView.reloadComponent(Type.city.hashValue)
            if let c = address?.city, 0 < c.options?.count ?? 0 {
                pickerView.selectRow(c.current ?? 0, inComponent: Type.city.hashValue, animated: true)
            }
            let options = address?.city?.area
            address?.district = Part(options: options, title: nil)
            pickerView.reloadComponent(Type.district.hashValue)
            if let d = address?.district, 0 < d.options?.count ?? 0 {
                pickerView.selectRow(d.current ?? 0, inComponent: Type.district.hashValue, animated: true)
            }
        case .city:
            address?.city?.current = row
            let options = address?.city?.area
            address?.district = Part(options: options, title: nil)
            pickerView.reloadComponent(Type.district.hashValue)
            if let d = address?.district, 0 < d.options?.count ?? 0 {
                pickerView.selectRow(d.current ?? 0, inComponent: Type.district.hashValue, animated: true)
            }
        case .district:
            address?.district?.current = row
        }
    }
}

open class UuusButton: UIButton {
    // MARK: - Properties

    open override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? tintColor : shadowColor
        }
    }
}

extension UIButton {
    // MARK: - View Handling

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        isExclusiveTouch = true
    }

    // MARK: - Public - Functions

    public func image2Right(boundedUpright: CGFloat = CGFloat(UInt8.min), greatestAclinic: CGFloat = screenWidth) {
        let titleFont = titleLabel!.font!
        let titleText = title(for: .normal)

        let imageWidth = imageView!.image!.size.width
        let titleWidth = titleText!.aclinic(boundedUpright: boundedUpright, font: titleFont)

        let titleRight = imageWidth + (16.0 / 4.0)
        let outOfRange = imageWidth + titleWidth > greatestAclinic
        let labelWidth = outOfRange ? greatestAclinic - imageWidth - 16.0 : titleWidth

        frame.size = CGSize(width: labelWidth + imageWidth, height: boundedUpright)

        titleEdgeInsets = UIEdgeInsets(top: 0, left: -titleRight, bottom: 0, right: titleRight)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth, bottom: 0, right: -labelWidth)
    }
}

open class Date9icker: Uuus9icker {
    // MARK: - IBOutlets

    @IBOutlet public var datePicker: UIDatePicker!

    // MARK: - Initialization

    public class func xib(select date: Date? = nil, actions: completionc?) -> Date9icker {
        let date9icker = xib as! Date9icker
        date9icker.ensureButton.rx.tap.bind { [unowned date9icker] sender in
            date9icker.removeAction(sender)
            date9icker.actions?(date9icker.datePicker.date)
        }.disposed(by: date9icker.disposeBag)
        date9icker.predate = date
        date9icker.actions = actions
        return date9icker
    }

    // MARK: - Properties

    public var predate: Date?

    // MARK: - Public - Functions

    open override func push() {
        blotWindow()

        if #available(iOS 11.0, *) {
            sbottom = rootground.view.safeAreaInsets.bottom
        }
        backgroundColor = .clear
        pickerTop.constant = 0
        layoutIfNeeded()

        pickerTop.constant = sbottom + (iPhoneX ? 206 : 216)
        let color = UIColor(white: 0, alpha: 0.4)
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = color
            self.layoutIfNeeded()
        }, completion: { _ in
            if let predate = self.predate {
                self.datePicker.setDate(predate, animated: true)
            }
        })
    }
}

extension UITextField {
    // MARK: - Public - Functions

    /// block queue outside as exception
    public func phone(check exception: Bool = true, errorString alert: String = "手机号码格式不正确".local) -> Bool {
        guard text?.isChinaPhone ?? false else {
            if exception {
                HUD.flash(.label(alert), delay: 0.5)
                becomeFirstResponder()
            }
            return false
        }
        return true
    }

    /// block queue outside as exception
    public func email(check exception: Bool = true, errorString alert: String = "电子邮箱格式不正确".local) -> Bool {
        guard text?.isValidEmail ?? false else {
            if exception {
                HUD.flash(.label(alert), delay: 0.5)
                becomeFirstResponder()
            }
            return false
        }
        return true
    }
}

@IBDesignable
open class RoundViEffectView: UIVisualEffectView {}
