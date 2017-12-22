//
//  UuusAVKit.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import AVKit
import RMUniversalAlert

open class ScanControllor: UuusController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Classes and Structures

    open class ScanView: UuusView {

        // MARK: - Singleton

        private let line = "line"

        // MARK: - Initialization

        override init(frame: CGRect) {
            super.init(frame: frame)
            let roll = #selector(ScanControllor.ScanView.roll)
            let name = NSNotification.Name.UIApplicationDidBecomeActive
            notificationc.addObserver(self, selector: roll, name: name, object: nil)
        }

        public required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Lazy Initialization

        public lazy var backLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.fillColor = .clear
            layer.strokeColor = .black
            layer.opacity = 0.5
            self.layer.addSublayer(layer)
            return layer
        }()

        public lazy var lineLayer: CAShapeLayer = { [unowned self] in
            let layer = CAShapeLayer()
            layer.fillColor = .clear
            layer.strokeColor = .white
            layer.lineWidth = 0.5
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
            animation.speed = 0.1
            animation.repeatCount = HUGE
            return animation
        }()

        // MARK: - Properties

        private(set) var scanrect: CGRect?

        // MARK: - View Handling

        open override func draw(_ rect: CGRect) {
            super.draw(rect)
            scanrect = scanned(rect)

            let rest = rect.height - scanrect!.height
            let minY = scanrect!.minY
            let backWidth = (rest - minY) > 0 ? (rest - minY) : minY
            let backInset = backWidth / 2 + 0.5
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

        // MARK: - Public - Functions

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

    // MARK: - Lazy Initialization

    public lazy var prelayer: AVCaptureVideoPreviewLayer? = { [unowned self] in
        guard let session = self.session else { return nil }
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspect
        layer.frame = self.scanView.bounds
        return layer
    }()

    public lazy var scanView: ScanView = { [unowned self] in
        let view = ScanView(frame: screenBounds)
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

    // MARK: - Closures

    public var didOutputMetadataObjectsClosure: completionc?

    // MARK: - Properties

    private var rectOfInterest: CGRect {
        let rect = view.bounds
        let scan = scanView.scanned(rect) ?? .zero
        let per1 = rect.height / rect.width
        let per2 = CGFloat(1920.0 / 1080.0)
        var minX, minY, width, height: CGFloat
        if per1 < per2 {
            let upright = rect.width * per2
            let padding = upright / 2 - rect.height / 2
            minX = (scan.minY + padding) / upright
            minY = scan.minX / rect.width
            width = scan.height / upright
            height = scan.width / rect.width
        } else {
            let aclinic = rect.height / per2
            let padding = aclinic / 2 - rect.width / 2
            minX = scan.minY / rect.height
            minY = (scan.minX + padding) / aclinic
            width = scan.height / rect.height
            height = scan.width / aclinic
        }
        let origin = CGPoint(x: minX, y: minY)
        let size = CGSize(width: width, height: height)
        return CGRect(origin: origin, size: size)
    }

    // MARK: - View Handling

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
        presentCameraAlertController()
    }

    // MARK: - Public - Functions

    open func startRunning() {
        scanView.roll()
        session?.startRunning()
    }

    open func stopRunning() {
        scanView.stop()
        session?.stopRunning()
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate

    open func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
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
        let cancelButtonTitle = "重新扫描".local
        let otherButtonTitles = ["好".local]
        RMUniversalAlert.show(in: self, withTitle: nil, message: message, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: otherButtonTitles) { [unowned self] alert, index in
            switch index {
            case alert.cancelButtonIndex:
                self.startRunning()
            case alert.firstOtherButtonIndex:
                self.popController()
            default:
                break
            }
        }
    }
}

extension UIViewController {
    @discardableResult
    public func presentCameraAlertController() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            let dictionKey = "NSCameraUsageDescription"
            let dictionary = Bundle.main.infoDictionary
            let message = dictionary?[dictionKey] as? String
            let cancelButtonTitle = "设置".local
            let otherButtonTitles = ["好".local]
            RMUniversalAlert.show(in: self, withTitle: nil, message: message?.local, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: nil, otherButtonTitles: otherButtonTitles, tap: { [unowned self] alert, index in
                switch index {
                case alert.cancelButtonIndex:
                    uiapplication.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                case alert.firstOtherButtonIndex:
                    self.popController()
                default:
                    break
                }
            })
            return true
        }
        return false
    }
}
