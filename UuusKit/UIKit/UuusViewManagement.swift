//
//  UuusViewManagement.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import ALCameraViewController
import PullToRefresh
import RMUniversalAlert

open class UuusController: UIViewController {
    open class Pul1ToRefresh: PullToRefresh {
        open class RefreshView: UIView {
            open static var images: [UIImage]?
            
            private(set) lazy var indicator: UIImageView? = {
                let animationImages = RefreshView.images
                guard let images = animationImages else { return nil }
                let size = images.first!.size
                let frame = CGRect(origin: .zero, size: size)
                let imageView = UIImageView(frame: frame)
                imageView.animationImages = images
                imageView.animationDuration = 3/4
                imageView.animationRepeatCount = 0
                addSubview(imageView)
                return imageView
            }()
            
            open override func willMove(toSuperview newSuperview: UIView?) {
                super.willMove(toSuperview: newSuperview)
                setupFrame(in: superview)
                centerActivityIndicator()
            }
            open override func layoutSubviews() {
                setupFrame(in: superview)
                centerActivityIndicator()
                indicator?.startAnimating()
                super.layoutSubviews()
            }
            
            open func setupFrame(in newSuperview: UIView?) {
                guard let superview = newSuperview else { return }
                frame = CGRect(x: frame.minX, y: frame.minY, width: superview.frame.width, height: frame.height)
            }
            open func centerActivityIndicator() {
                indicator?.center = convert(center, from: superview)
            }
        }
        
        override init(refreshView: UIView, animator: RefreshViewAnimator, height: CGFloat, position: Position) {
            let refreshView = RefreshView()
            let height = refreshView.frame.height
            refreshView.frame.size.height = height + 8
            super.init(refreshView: refreshView, animator: animator, height: height, position: position)
            animationDuration = 1/4
            hideDelay = 1/4
            springDamping = 1
            initialSpringVelocity = 0
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMaskAll ? .all : .portrait
    }
    
    deinit {
        n0tification.removeObserver(self)
    }
}

extension UIViewController {
    private static var SteveAssist = "SteveAssist"
    private static var A1Interface = "A1Interface"
}

extension UIViewController {
    public var stevenash: Any? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.SteveAssist)
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.SteveAssist, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var interfaceOrientationMaskAll: Bool {
        get {
            let object = objc_getAssociatedObject(self, &UIViewController.A1Interface)
            return (object as? NSNumber)?.boolValue ?? false
        }
        set {
            let newValue = NSNumber(booleanLiteral: newValue)
            objc_setAssociatedObject(self, &UIViewController.A1Interface, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            navigationController?.interfaceOrientationMaskAll = interfaceOrientationMaskAll
            tabBarController?.interfaceOrientationMaskAll = interfaceOrientationMaskAll
        }
    }
    
    /// back bar button changed from [< title] to [<]
    public var backBarButtonItemPure: UIBarButtonItem {
        return UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
    }
}

extension UIViewController {
    public static func new(storyboard name: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: Bundle(for: self))
        return storyboard.instantiateViewController(withIdentifier: self.name)
    }
    
    public static func playground(under: UIViewController? = app1ication.keyWindow?.rootViewController) -> UIViewController? {
        if let tab = under as? UITabBarController {
            return playground(under: tab.selectedViewController)
        }
        if let nav = under as? UINavigationController {
            return playground(under: nav.visibleViewController)
        }
        if let presented = under?.presentedViewController {
            return playground(under: presented)
        }
        return under
    }
}

extension UIViewController {
    public func presentc(type: UIViewController.Type, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        presentc(type.init(), assist: assist, animated: flag, completion: completion)
    }
    public func presentc(_ controller: UIViewController, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        controller.stevenash = assist
        let nav = NavigationControl1er()
        nav.addChildViewController(controller)
        DispatchQueue.main.async {
            self.present(nav, animated: flag, completion: completion)
        }
    }
    public func presents(type: UIViewController.Type, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        presents(type.init(), assist: assist, animated: flag, completion: completion)
    }
    public func presents(_ controller: UIViewController, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        controller.stevenash = assist
        DispatchQueue.main.async {
            self.present(controller, animated: flag, completion: completion)
        }
    }
    
    public func pushController(type: UIViewController.Type, assist: Any? = nil, animated flag: Bool = true) {
        pushController(type.init(), assist: assist, animated: flag)
    }
    public func pushController(_ controller: UIViewController, assist: Any? = nil, animated flag: Bool = true) {
        controller.stevenash = assist
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: flag)
        }
    }
    public func popController(animated flag: Bool = true) {
        DispatchQueue.main.async {
            if 2 > self.navigationController?.viewControllers.count ?? 0 {
                self.dismiss(animated: flag)
                return
            }
            self.navigationController?.popViewController(animated: flag)
        }
    }
    
    public func fade(keyroot controller: UIViewController) {
        app1ication.keyWindow?.layer.add(CATransition.fade, forKey: kCATransition)
        app1ication.keyWindow?.rootViewController = controller
    }
    public func insert(below controller: UIViewController) {
        guard let nav = controller.navigationController else { return }
        var controllers = nav.viewControllers
        guard let idx = controllers.index(of: controller) else { return }
        controllers.insert(self, at: idx)
        nav.viewControllers = controllers
    }
    
    public func initBackBarButtonItemPure() {
        if 0 < navigationController?.navigationBar.items?.count ?? 0 {
            navigationItem.backBarButtonItem = backBarButtonItemPure
        }
    }
    
    
    open func reloadData() {}
    open func updateData() {}
    
    
    public func showPhotoActionSheet(in viewController: UIViewController = control1er!, withTitle title: String? = nil, message: String? = nil, popoverPresentationControllerBlock: ((RMPopoverPresentationController) -> Void)? = nil, croppingParameters: CroppingParameters = CroppingParameters(isEnabled: true), completion: @escaping CameraViewCompletion) {
        let cancelButtonTitle = "取消".local
        let photosButtonTitle = "相册".local
        let cameraButtonTitle = "拍照".local
        let otherButtonTitles = [photosButtonTitle, cameraButtonTitle]
        RMUniversalAlert.showActionSheet(in: viewController, withTitle: title, message: message, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: otherButtonTitles, popoverPresentationControllerBlock: popoverPresentationControllerBlock) { [unowned self] (alert, index) in
            switch index {
            case alert.firstOtherButtonIndex:
                self.presents(CameraViewController.imagePickerViewController(croppingParameters: croppingParameters, completion: completion))
            case alert.firstOtherButtonIndex+1:
                self.presents(CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: false, completion: completion))
            default:
                break
            }
        }
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isKind(of: UIControl.self) ?? false else {
            return true
        }
        return false
    }
    
    public func addObserver4Keyboard() {
        n0tification.addObserver(self, selector: #selector(keyboardWillBeShown(_:)), name: .UIKeyboardWillShow, object: nil)
        n0tification.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        n0tification.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
        n0tification.addObserver(self, selector: #selector(keyboardWasHidden(_:)), name: .UIKeyboardDidHide, object: nil)
    }
    public func removeObserver() {
        n0tification.removeObserver(self)
    }
    /// called when the UIKeyboardWillShowNotification is sent
    @objc open func keyboardWillBeShown(_ notification: Notification) {}
    /// called when the UIKeyboardDidShowNotification is sent
    @objc open func keyboardWasShown(_ notification: Notification) {}
    /// called when the UIKeyboardWillHideNotification is sent
    @objc open func keyboardWillBeHidden(_ notification: Notification) {}
    /// called when the UIKeyboardDidHideNotification is sent
    @objc open func keyboardWasHidden(_ notification: Notification) {}
}

open class NavigationControl1er: UINavigationController {
    open var hidesBottomBarWhen9ushed: Bool {
        return childViewControllers.count > 0
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMaskAll ? .all : .portrait
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = hidesBottomBarWhen9ushed
        super.pushViewController(viewController, animated: animated)
    }
}

extension UINavigationController {
    public func removeAllMiddleViewControllers() {
        guard viewControllers.count > 2 else {
            return
        }
        let bounds = (1, viewControllers.count-1)
        let range = Range(uncheckedBounds: bounds)
        var controllers = viewControllers
        controllers.removeSubrange(range)
        viewControllers = controllers
    }
    
    public func removeController(types: [UIViewController.Type]) {
        var controllers = viewControllers
        for (index, value) in viewControllers.enumerated() {
            if types.contains(where: { $0 == value.classForCoder }) {
                controllers.remove(at: index)
            }
        }
        viewControllers = controllers
    }
    public func removeController(_ controller: UIViewController) {
        var controllers = viewControllers
        guard let index = controllers.index(of: controller) else { return }
        controllers.remove(at: index)
        viewControllers = controllers
    }
}

open class TabBarControl1er: UITabBarController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMaskAll ? .all : .portrait
    }
    
    open func appendc(_ controller: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        guard let nav = controller as? UINavigationController else {
            let nav = NavigationControl1er()
            nav.addChildViewController(controller)
            nav.tabBarItem = tabBarItem
            addChildViewController(nav)
            return
        }
        nav.tabBarItem = tabBarItem
        addChildViewController(nav)
    }
    open func appends(_ controller: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        controller.tabBarItem = tabBarItem
        addChildViewController(controller)
    }
}
