//
//  UuusAVKit.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import AVKit
import RMUniversalAlert

class ScanContro1ler: UuusController, AVCaptureMetadataOutputObjectsDelegate {
    class ScanView: UuusView {
        private let line = "line"
        
        private lazy var backLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.strokeColor = UIColor.black.cgColor
            layer.opacity = 1/2
            self.layer.addSublayer(layer)
            return layer
        }()
        private lazy var lineLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 1/2
            self.layer.addSublayer(layer)
            return layer
        }()
        private lazy var overLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 3
            layer.lineDashPhase = 15
            self.layer.addSublayer(layer)
            return layer
        }()
        private lazy var moveLayer: CAGradientLayer = { [unowned self] in
            let layer = CAGradientLayer()
            let clear = UIColor.clear.cgColor
            let white = UIColor.white.cgColor
            layer.startPoint = CGPoint.zero
            layer.endPoint = CGPoint(x: 1, y: 0)
            layer.colors = [clear, white, clear]
            self.layer.addSublayer(layer)
            return layer
        }()
        private lazy var animation: CABasicAnimation = { [unowned self] in
            let animation = CABasicAnimation()
            animation.keyPath = "position.y"
            animation.fromValue = self.moveLayer.position.y
            animation.toValue = self.scanrect?.maxY
            animation.speed = 1/10
            animation.repeatCount = HUGE
            return animation
        }()
        private(set) var scanrect: CGRect?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            let name = NSNotification.Name.UIApplicationDidBecomeActive
            n0tification.addObserver(self, selector: #selector(roll), name: name, object: nil)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            scanrect = scanned(rect)
            
            let rest = rect.height - scanrect!.height
            let minY = scanrect!.minY
            let backWidth = (rest - minY) > 0 ? (rest - minY) : minY
            let backInset = backWidth / 2 + 1/2
            let backFrame = scanrect!.insetBy(dx: -backInset, dy: -backInset)
            backLayer.lineWidth = backWidth
            backLayer.path = UIBezierPath(rect: backFrame).cgPath
            
            let lineFrame = scanrect!.insetBy(dx: -1, dy: -1)
            lineLayer.path = UIBezierPath(rect: lineFrame).cgPath
            
            let number = NSNumber(value: Double(scanrect!.width) - 30.0)
            overLayer.lineDashPattern = [30, number]
            overLayer.path = UIBezierPath(rect: scanrect!).cgPath
            
            moveLayer.frame = CGRect(x: scanrect!.minX, y: scanrect!.minY, width: scanrect!.width, height: 3)
            
            roll()
        }
        
        func scanned(_ rect: CGRect?) -> CGRect? {
            guard rect != nil else {
                return nil
            }
            
            let inset = CGFloat(64)
            var rectangle = rect!.insetBy(dx: inset, dy: inset)
            let minimum = min(rectangle.width, rectangle.height)
            if rectangle.width != minimum {
                rectangle.origin.x += (rectangle.width - minimum) / 2
                rectangle.size.width = minimum
            } else if rectangle.height != minimum {
                rectangle.origin.y += (rectangle.height - minimum) / 2
                rectangle.size.height = minimum
            }
            let dy = (-screenHeight + screenWidth) / 2 + statusHeight
            return rectangle.offsetBy(dx: 0, dy: dy)
        }
        @objc func roll() {
            let keys = moveLayer.animationKeys()
            guard keys?.contains(line) ?? false else {
                moveLayer.add(animation, forKey: line)
                return
            }
        }
        @objc func stop() {
            moveLayer.removeAnimation(forKey: line)
        }
    }
    
    lazy var prelayer: AVCaptureVideoPreviewLayer? = { [unowned self] in
        guard let session = self.session else {
            return nil
        }
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspect
        layer.frame = self.scanView.bounds
        return layer
    }()
    lazy var scanView: ScanView = { [unowned self] in
        let view = ScanView(frame: self.view.bounds)
        view.clipsToBounds = true
        self.view.addSubview(view)
        return view
    }()
    lazy var device: AVCaptureDevice? = {
        if #available(iOS 10.0, *) {
            return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        }
        return AVCaptureDevice.default(for: .video)
    }()
    lazy var session: AVCaptureSession? = { [unowned self] in
        guard let device = self.device else {
            return nil
        }
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch _ {
            return nil
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.rectOfInterest = self.rectOfInterest
        let session = AVCaptureSession()
        session.sessionPreset = .high
        if session.canAddInput(input!) {
            session.addInput(input!)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        output.metadataObjectTypes = [.qr]
        
        return session
    }()
    var rectOfInterest: CGRect {
        return .zero
    }
    var didOutputMetadataObjectsClosure: completionc?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interfaceOrientationMaskAll = false
        navigationItem.title = "扫描".local
        edgesForExtendedLayout = UIRectEdge()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !(scanView.layer.sublayers?.first?.isKind(of: AVCaptureVideoPreviewLayer.self) ?? false) {
            if let prelayer = prelayer {
                scanView.layer.insertSublayer(prelayer, at: 0)
            }
        }
        session?.startRunning()
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            let dictionKey = "NSCameraUsageDescription"
            let dictionary = Bundle.main.infoDictionary
            let message = dictionary?[dictionKey] as? String
            let cancelButtonTitle = "好的".local
            let otherButtonTitles = ["设置".local]
            RMUniversalAlert.show(in: self, withTitle: nil, message: message?.local, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: otherButtonTitles, tap: { [unowned self] (alert, index) in
                switch index {
                case alert.cancelButtonIndex:
                    self.popController()
                case alert.firstOtherButtonIndex:
                    app1ication.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                default:
                    break
                }
            })
        }
    }
    
    func startRunning() {
        scanView.roll()
        session?.startRunning()
    }
    func stopRunning() {
        scanView.stop()
        session?.stopRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {
            return
        }
        stopRunning()
        guard didOutputMetadataObjectsClosure == nil else {
            didOutputMetadataObjectsClosure!(metadataObjects)
            return
        }
        
        let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        let message = metadataObject?.stringValue ?? String.empty
        let cancelButtonTitle = "好的".local
        let otherButtonTitles = ["重新扫描".local]
        RMUniversalAlert.show(in: self, withTitle: nil, message: message, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: otherButtonTitles) { [unowned self] (alert, index) in
            switch index {
            case alert.cancelButtonIndex:
                self.popController()
            case alert.firstOtherButtonIndex:
                self.startRunning()
            default:
                break
            }
        }
    }
}
