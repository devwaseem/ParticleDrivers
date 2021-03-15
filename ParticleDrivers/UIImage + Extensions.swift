//
//  test.swift
//  ParticleDrivers
//
//  Created by Waseem Akram on 15/03/21.
//

import UIKit

extension UIImage {
    
    func getPixels() -> [[Int]] {
//        let image = UIImage(named: "apple.png")!.resizeImage(targetSize: CGSize(width: 400, height: 400))
        
        guard let cgImage = self.cgImage,
              let data = cgImage.dataProvider?.data,
              let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        var pixelMap = repeatElement(repeatElement(0, count: cgImage.height).map { $0 }, count: cgImage.width).map { $0 }
        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        for y in 0 ..< cgImage.height {
            for x in 0 ..< cgImage.width {
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                let components = (r: bytes[offset], g: bytes[offset + 1], b: bytes[offset + 2])
//                print("[x:\(x), y:\(y)] \(components)")
                pixelMap[x][y] = Int((components.r + components.g + components.b)/3)
            }
            
        }
        
        return pixelMap
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
