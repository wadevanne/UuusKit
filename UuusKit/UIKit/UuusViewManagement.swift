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

class UuusController: UIViewController {
    class Pu1lToRefresh: PullToRefresh {
        class RefreshView: UIView {
            var images: [UIImage] = []
            
            private(set) lazy var indicator: UIImageView? = {
                guard images.count > 0 else {
                    return nil
                }
                
                let size = images.first!.size
                let frame = CGRect(origin: .zero, size: size)
                let imageView = UIImageView(frame: frame)
                imageView.animationImages = images
                imageView.animationDuration = 3/4
                imageView.animationRepeatCount = 0
                addSubview(imageView)
                return imageView
            }()
            
            override func willMove(toSuperview newSuperview: UIView?) {
                super.willMove(toSuperview: newSuperview)
                setupFrame(in: superview)
                centerActivityIndicator()
            }
            override func layoutSubviews() {
                setupFrame(in: superview)
                centerActivityIndicator()
                indicator?.startAnimating()
                super.layoutSubviews()
            }
            
            func setupFrame(in newSuperview: UIView?) {
                guard let superview = newSuperview else {
                    return
                }
                frame = CGRect(x: frame.minX, y: frame.minY, width: superview.frame.width, height: frame.height)
            }
            func centerActivityIndicator() {
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
    
    deinit {
        n0tification.removeObserver(self)
    }
}

extension UIViewController {
    private static var SteveAssist = "SteveAssist"
    private static var A1Interface = "A1Interface"
}

extension UIViewController {
    var stevenash: Any? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.SteveAssist)
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.SteveAssist, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var interfaceOrientationMaskAll: Bool {
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
    
    /// bar button changed from [< title] to [<]
    var backBarButtonItemPure: UIBarButtonItem {
        return UIBarButtonItem(title: String.empty, style: .plain, target: nil, action: nil)
    }
}

extension UIViewController {
    static func new(storyboard name: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: self.name)
    }
    
    static func playground(under: UIViewController? = app1ication.keyWindow?.rootViewController) -> UIViewController? {
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
    func presentc(type: UIViewController.Type, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        presentc(type.init(), assist: assist, animated: flag, completion: completion)
    }
    func presentc(_ controller: UIViewController, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        controller.stevenash = assist
        let nav = NavigationContro1ler()
        nav.addChildViewController(controller)
        DispatchQueue.main.async {
            self.present(nav, animated: flag, completion: completion)
        }
    }
    func presents(type: UIViewController.Type, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        presents(type.init(), assist: assist, animated: flag, completion: completion)
    }
    func presents(_ controller: UIViewController, assist: Any? = nil, animated flag: Bool = true, completion: (() -> Swift.Void)? = nil) {
        controller.stevenash = assist
        DispatchQueue.main.async {
            self.present(controller, animated: flag, completion: completion)
        }
    }
    
    func pushController(type: UIViewController.Type, assist: Any? = nil, animated flag: Bool = true) {
        pushController(type.init(), assist: assist, animated: flag)
    }
    func pushController(_ controller: UIViewController, assist: Any? = nil, animated flag: Bool = true) {
        controller.stevenash = assist
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: flag)
        }
    }
    func popController(animated flag: Bool = true) {
        DispatchQueue.main.async {
            if 2 > self.navigationController?.viewControllers.count ?? 0 {
                self.dismiss(animated: flag)
                return
            }
            self.navigationController?.popViewController(animated: flag)
        }
    }
    
    func insert(below controller: UIViewController) {
        guard let nav = controller.navigationController else {
            return
        }
        var controllers = nav.viewControllers
        guard let idx = controllers.index(of: controller) else {
            return
        }
        controllers.insert(self, at: idx)
        nav.viewControllers = controllers
    }
    func removeFromNavigationController() {
        guard let nav = navigationController else {
            return
        }
        var controllers = nav.viewControllers
        guard let idx = controllers.index(of: self) else {
            return
        }
        controllers.remove(at: idx)
        nav.viewControllers = controllers
    }
    
    func initBackBarButtonItemPure() {
        if 0 < navigationController?.navigationBar.items?.count ?? 0 {
            navigationItem.backBarButtonItem = backBarButtonItemPure
        }
    }
    
    
    func reloadData() {}
    func updateData() {}
    
    
    func showPhotoActionSheet(in viewController: UIViewController = contro1ler!, withTitle title: String? = nil, message: String? = nil, popoverPresentationControllerBlock: ((RMPopoverPresentationController) -> Void)? = nil, croppingParameters: CroppingParameters = CroppingParameters(isEnabled: true), completion: @escaping CameraViewCompletion) {
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
    
    func addObserver4Keyboard() {
        n0tification.addObserver(self, selector: #selector(keyboardWillBeShown(_:)), name: .UIKeyboardWillShow, object: nil)
        n0tification.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardDidShow, object: nil)
        n0tification.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
        n0tification.addObserver(self, selector: #selector(keyboardWasHidden(_:)), name: .UIKeyboardDidHide, object: nil)
    }
    func removeObserver() {
        n0tification.removeObserver(self)
    }
    /// called when the UIKeyboardWillShowNotification is sent
    @objc func keyboardWillBeShown(_ notification: Notification) {}
    /// called when the UIKeyboardDidShowNotification is sent
    @objc func keyboardWasShown(_ notification: Notification) {}
    /// called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(_ notification: Notification) {}
    /// called when the UIKeyboardDidHideNotification is sent
    @objc func keyboardWasHidden(_ notification: Notification) {}
}

class NavigationContro1ler: UINavigationController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMaskAll ? .all : .portrait
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = childViewControllers.count > 0
        super.pushViewController(viewController, animated: animated)
    }
}

class TabBarContro1ler: UITabBarController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return interfaceOrientationMaskAll ? .all : .portrait
    }
    
    func addController(_ controller: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        guard let nav = controller as? UINavigationController else {
            let nav = NavigationContro1ler()
            nav.addChildViewController(controller)
            nav.tabBarItem = tabBarItem
            addChildViewController(nav)
            return
        }
        nav.tabBarItem = tabBarItem
        addChildViewController(nav)
    }
}
