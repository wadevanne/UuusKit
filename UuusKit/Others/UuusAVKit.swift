//
//  UuusAVKit.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import AVKit
import RMUniversalAlert

open class ScanControl1er: UuusController, AVCaptureMetadataOutputObjectsDelegate {
    open class ScanView: UuusView {
        private let line = "line"
        
        public lazy var backLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.fillColor = .clear
            layer.strokeColor = .black
            layer.opacity = 1/2
            self.layer.addSublayer(layer)
            return layer
        }()
        public lazy var lineLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.fillColor = .clear
            layer.strokeColor = .white
            layer.lineWidth = 1/2
            self.layer.addSublayer(layer)
            return layer
        }()
        public lazy var overLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.fillColor = .clear
            layer.strokeColor = .white
            layer.lineWidth = 3
            layer.lineDashPhase = 15
            self.layer.addSublayer(layer)
            return layer
        }()
        public lazy var moveLayer: CAGradientLayer = { [unowned self] in
            let clear = CGColor.clear
            let white = CGColor.white
            let layer = CAGradientLayer()
            layer.startPoint = CGPoint.zero
            layer.endPoint = CGPoint(x: 1, y: 0)
            layer.colors = [clear, white, clear]
            self.layer.addSublayer(layer)
            return layer
        }()
        public lazy var animation: CABasicAnimation = { [unowned self] in
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
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        open override func draw(_ rect: CGRect) {
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
        
        open func scanned(_ rect: CGRect?) -> CGRect? {
            guard let rect = rect else { return nil }
            let inset = CGFloat(64)
            var rectangle = rect.insetBy(dx: inset, dy: inset)
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
        @objc open func roll() {
            let keys = moveLayer.animationKeys()
            guard keys?.contains(line) ?? false else {
                moveLayer.add(animation, forKey: line)
                return
            }
        }
        @objc open func stop() {
            moveLayer.removeAnimation(forKey: line)
        }
    }
    
    public lazy var prelayer: AVCaptureVideoPreviewLayer? = { [unowned self] in
        guard let session = self.session else { return nil }
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspect
        layer.frame = self.scanView.bounds
        return layer
    }()
    public lazy var scanView: ScanView = { [unowned self] in
        let view = ScanView(frame: self.view.bounds)
        view.clipsToBounds = true
        self.view.addSubview(view)
        return view
    }()
    public lazy var device: AVCaptureDevice? = {
        if #available(iOS 10.0, *) {
            return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        }
        return AVCaptureDevice.default(for: .video)
    }()
    public lazy var session: AVCaptureSession? = { [unowned self] in
        guard let device = self.device else { return nil }
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
    private var rectOfInterest: CGRect {
        let rect = view.bounds
        let scan = scanView.scanned(rect) ?? .zero
        let per1 = rect.height / rect.width
        let per2 = CGFloat(1920.0 / 1080.0)
        var minX, minY, width, height: CGFloat
        if per1 < per2 {
            let upright = rect.width * per2
            let padding = upright/2 - rect.height/2
            minX = (scan.minY + padding) / upright
            minY = scan.minX / rect.width
            width = scan.height / upright
            height = scan.width / rect.width
        } else {
            let aclinic = rect.height / per2
            let padding = aclinic/2 - rect.width/2
            minX = scan.minY / rect.height
            minY = (scan.minX + padding) / aclinic
            width = scan.height / rect.height
            height = scan.width / aclinic
        }
        let origin = CGPoint(x: minX, y: minY)
        let size = CGSize(width: width, height: height)
        return CGRect(origin: origin, size: size)
    }
    public var didOutputMetadataObjectsClosure: completionc?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interfaceOrientationMaskAll = false
        navigationItem.title = "扫描".local
        edgesForExtendedLayout = UIRectEdge()
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let kind = AVCaptureVideoPreviewLayer.self
        if !(scanView.layer.sublayers?.first?.isKind(of: kind) ?? false) {
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
    
    open func startRunning() {
        scanView.roll()
        session?.startRunning()
    }
    open func stopRunning() {
        scanView.stop()
        session?.stopRunning()
    }
    
    open func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {
            return
        }
        stopRunning()
        guard didOutputMetadataObjectsClosure == nil else {
            didOutputMetadataObjectsClosure!(metadataObjects)
            return
        }
        
        let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject
        let message = metadataObject?.stringValue ?? .empty
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
