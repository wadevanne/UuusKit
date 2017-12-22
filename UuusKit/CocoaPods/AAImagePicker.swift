//
//  AAImagePicker.swift
//  AAImagePicker
//
//  Created by Engr. Ahsan Ali on 01/04/2017.
//  Copyright (c) 2017 AA-Creations. All rights reserved.
//

import UIKit

open class AAImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var options: AAImagePickerOptions = AAImagePickerOptions()
    var getImage: ((UIImage) -> Swift.Void)!

    var rootViewController: UIViewController {
        guard let root = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("AAImagePicker - Application key window not found. Please check UIWindow in AppDelegate.")
        }

        return root
    }

    func setupAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: options.actionSheetTitle, message: options.actionSheetMessage, preferredStyle: .actionSheet)

        let camera = UIAlertAction(title: options.optionCamera, style: .default, handler: { _ in
            if !self.rootViewController.presentCameraAlertController() {
                self.presentPicker(sourceType: .camera)
            }
        })

        let photoLibrary = UIAlertAction(title: options.optionLibrary, style: .default, handler: { _ in
            self.presentPicker(sourceType: .photoLibrary)
        })

        let cancel = UIAlertAction(title: options.optionCancel, style: .cancel, handler: nil)

        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        return alertController
    }

    func presentPicker(sourceType: UIImagePickerControllerSourceType) {

        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }

        imagePicker.allowsEditing = options.allowsEditing
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .overCurrentContext
        imagePicker.sourceType = sourceType
        rootViewController.present(imagePicker, animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        picker.dismiss(animated: true, completion: nil)

        let imageType = options.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage

        var image = info[imageType] as! UIImage
        image = image.fixOrientation()

        switch options.resizeType {
        case .width:
            image = image.resize(width: options.resizeValue)
            break
        case .scale:
            image = image.resize(scale: options.resizeValue)
            break
        default:
            break
        }
        getImage(image)
    }

    open func present(_ options: AAImagePickerOptions? = nil, _ completion: @escaping ((UIImage) -> Void)) {

        if let pickerOptions = options {
            self.options = pickerOptions
        }
        let alertController = setupAlertController()
        rootViewController.present(alertController, animated: true, completion: nil)

        getImage = { image in
            completion(image)
        }
    }
}

extension UIImage {

    // MARK: - Credits: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload

    func fixOrientation() -> UIImage {

        // No-op if the orientation is already correct
        if imageOrientation == UIImageOrientation.up {
            return self
        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity

        if imageOrientation == UIImageOrientation.down || imageOrientation == UIImageOrientation.downMirrored {
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(uuus1mpi))
        }

        if imageOrientation == UIImageOrientation.left || imageOrientation == UIImageOrientation.leftMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(uuusm2pi))
        }

        if imageOrientation == UIImageOrientation.right || imageOrientation == UIImageOrientation.rightMirrored {
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-uuusm2pi))
        }

        if imageOrientation == UIImageOrientation.upMirrored || imageOrientation == UIImageOrientation.downMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if imageOrientation == UIImageOrientation.leftMirrored || imageOrientation == UIImageOrientation.rightMirrored {
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                       bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: cgImage!.colorSpace!,
                                       bitmapInfo: cgImage!.bitmapInfo.rawValue)!

        ctx.concatenate(transform)

        if imageOrientation == UIImageOrientation.left ||
            imageOrientation == UIImageOrientation.leftMirrored ||
            imageOrientation == UIImageOrientation.right ||
            imageOrientation == UIImageOrientation.rightMirrored {
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        } else {
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
    }

    func resize(scale: CGFloat) -> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width * scale, height: size.height * scale)))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    func resize(width: CGFloat) -> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

open class AAImagePickerOptions: NSObject {
    open var actionSheetTitle: String?
    open var actionSheetMessage: String?
    open var optionCamera = "拍照".local
    open var optionLibrary = "相册".local
    open var optionCancel = "取消".local
    open var allowsEditing = true
    open var resizeValue: CGFloat = 500
    open var resizeType: AAResizer = .none
}

public enum AAResizer {
    case width
    case scale
    case none
}
