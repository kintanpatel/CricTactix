//
//  Date+Ext.swift
//  CricTactix
//
//  Created by kintan on 06/05/24.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.date(from: self)
    }
}
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
}

extension Array where Element: UIColor {
    func averageColor() -> UIColor? {
        guard !isEmpty else { return nil }
        
        var (red, green, blue, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        for color in self {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            red += r
            green += g
            blue += b
            alpha += a
        }
        
        let count = CGFloat(count)
        return UIColor(red: red / count, green: green / count, blue: blue / count, alpha: alpha / count)
    }
}

extension Color {
    var isDark: Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let lum = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return lum < 0.5
    }
}


extension UIImage {
    func dominantColors() -> [UIColor] {
        guard let cgImage = self.cgImage else { return [] }

        let width = cgImage.width
        let height = cgImage.height

        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        guard let context = CGContext(data: &pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else { return [] }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var colorCountDict = [UInt32: Int]()
        for i in stride(from: 0, to: width * height * bytesPerPixel, by: bytesPerPixel) {
            let red = UInt32(pixelData[i])
            let green = UInt32(pixelData[i + 1])
            let blue = UInt32(pixelData[i + 2])

            let color = (red << 16) | (green << 8) | blue

            if let count = colorCountDict[color] {
                colorCountDict[color] = count + 1
            } else {
                colorCountDict[color] = 1
            }
        }

        let sortedColors = colorCountDict.sorted { $0.value > $1.value }

        let dominantColors = sortedColors.prefix(3).map { UIColor(red: CGFloat(($0.key >> 16) & 0xFF) / 255.0,
                                                                  green: CGFloat(($0.key >> 8) & 0xFF) / 255.0,
                                                                  blue: CGFloat($0.key & 0xFF) / 255.0,
                                                                  alpha: 1.0) }

        return dominantColors
    }
}

