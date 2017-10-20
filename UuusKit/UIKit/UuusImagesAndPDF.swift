//
//  UuusImagesAndPDF.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import UIKit

extension UIImage {
    public func colors(at point: CGPoint, count: Int) -> [UIColor] {
        let height = cgImage!.height
        let width = cgImage!.width
        let bitmap = CGBitmapInfo.byteOrder32Big
        let alpha = CGImageAlphaInfo.premultipliedLast
        let bitmapInfo = bitmap.rawValue | alpha.rawValue
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let data = calloc(bytesPerPixel * width * height, MemoryLayout<CUnsignedChar>.size)
        let space = CGColorSpaceCreateDeviceRGB()
        
        var colors: [UIColor] = []
        
        guard let context = CGContext(data: data, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: space, bitmapInfo: bitmapInfo) else {
            return colors
        }
        context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        /// now your data contains the image data in the RGBA8888 pixel format
        var byteIndex = bytesPerPixel * Int(point.x) + bytesPerRow * Int(point.y)
        for _ in 0..<count {
            let A = CGFloat(data!.load(fromByteOffset: byteIndex+3, as: UInt8.self)) / 255
            let R = CGFloat(data!.load(fromByteOffset: byteIndex+0, as: UInt8.self)) / A
            let G = CGFloat(data!.load(fromByteOffset: byteIndex+1, as: UInt8.self)) / A
            let B = CGFloat(data!.load(fromByteOffset: byteIndex+2, as: UInt8.self)) / A
            colors.append(UIColor(R: R, G: G, B: B, A: A))
            byteIndex += bytesPerPixel
        }
        free(data)
        return colors
    }
}
