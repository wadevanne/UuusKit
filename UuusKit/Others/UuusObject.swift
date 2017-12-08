//
//  UuusObject.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import Alamofire
import KeychainAccess
import ObjectMapper
import PKHUD

open class UuusObject: NSObject {}

extension UuusObject {

    // MARK: - Classes and Structures

    public class Uuid: NSObject {

        // MARK: - Singleton

        public static let shared: String = {
            let identifier = Bundle.main.bundleIdentifier
            let keychain = Keychain(service: identifier ?? .empty)
            var uuid = keychain[UIDevice.Identifier]
            if uuid == nil {
                uuid = UserDefaults.standard.string(forKey: UIDevice.Identifier)
                if uuid == nil {
                    uuid = Uuid.dIFV
                    keychain[UIDevice.Identifier] = uuid
                    UserDefaults.standard.set(uuid, forKey: UIDevice.Identifier)
                    UserDefaults.standard.synchronize()
                }
            }
            return uuid!
        }()

        // MARK: - Properties

        @available(iOS 6.0, *)
        public static var uuid: String {
            return NSUUID().uuidString
        }

        @available(iOS 6.0, *)
        public static var dIFV: String? {
            let device = UIDevice.current
            let identifier = device.identifierForVendor
            return identifier?.uuidString
        }

        public static var rand: String? {
            let uuid = CFUUIDCreate(kCFAllocatorDefault)
            let char = CFUUIDCreateString(kCFAllocatorDefault, uuid)
            return char as String?
        }
    }
}

extension UuusObject {

    // MARK: - Classes and Structures

    public class Base64Transform: TransformType {
        public typealias Object = String
        public typealias JSON = String
        init() {}

        /// decode base64
        public func transformFromJSON(_ value: Any?) -> String? {
            guard let string = value as? String else { return nil }
            guard let data = string.debase64Data else { return string }
            return String(data: data, encoding: .utf8)
        }
        /// encode base64
        public func transformToJSON(_ value: String?) -> String? {
            guard let string = value else { return nil }
            let data = Data(bytes: Array(string.utf8))
            return data.enbase64String
        }
    }
}

open class UuusRequest: NSObject {

    // MARK: - Enumerations

    public enum Loaded {
        case `default`
        case exception
    }

    public enum Loading {
        case `default`
        case animations
        case customized
    }

    // MARK: - Closures

    public var completion: completionc?
    public var exception: exceptionc?
    public var failure: failurec?

    // MARK: - Properties

    public var loaded: Loaded = .default

    public var method: HTTPMethod = .post

    public var loading: Loading = .default

    public var tag: Int = 0

    open var loadURL: String? {
        get {
            return loadurl ?? (scheme + baseURL + port + prefix + path)
        }
        set {
            loadurl = newValue
        }
    }

    private(set) var loadurl: String?
    public var scheme = String.http
    public var baseURL = String.empty
    public var port = String.empty
    public var prefix = String.empty
    public var path = String.empty

    open var headers: HTTPHeaders?
    open var parameters: Parameters?
}

open class UuusDelivery: NSObject {

    // MARK: - Initialization

    public override init() {
        super.init()
        startListening()
    }

    // MARK: - Properties

    let manager = NetworkReachabilityManager(host: "www.apple.com")

    // MARK: - Public - Functions

    public func request(_ request: UuusRequest, completion: completionc? = nil, failure: failurec? = nil) {
        switch request.loading {
        case .default:
            HUD.show(.systemActivity, onView: playground?.view)
        case .animations:
            break
        case .customized:
            break
        }

        Alamofire.request(request.loadURL!, method: request.method, parameters: request.parameters, headers: request.headers).responseJSON { response in
            #if DEBUG
                debugPrint(response)
            #endif
            HUD.hide(animated: true)
            switch response.result {
            case let .success(result):
                completion?(result)
            case let .failure(error):
                failure?(error)
            }
        }
    }

    // MARK: - Private - Functions

    @discardableResult
    private func startListening() -> Bool? {
        manager?.listener = { reachabilityStatus in
            switch reachabilityStatus {
            case .unknown:
                break
            case .notReachable:
                break
            case .reachable(.ethernetOrWiFi):
                break
            case .reachable(.wwan):
                break
            }
        }
        return manager?.startListening()
    }
}

open class UuusMagician: NSObject {}

extension NSObject {

    // MARK: - Properties

    public static var name: String {
        return "\(classForCoder())"
    }

    public var className: String {
        return "\(classForCoder)"
    }
}
