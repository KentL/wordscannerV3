//
//  Tesseract.swift
//  Word Scanner
//
//  Created by Kent Li on 2016-11-06.
//  Copyright © 2016 UPEICS. All rights reserved.
//

import Foundation

class Tesseract {
    
    
    //Use tesseract framework to process the image
    func performImageRecognitionWithChinese(image: UIImage) -> String! {
        scaleImage(image, maxDimension: 640)
        
        let tesseract = G8Tesseract()
        tesseract.language = "eng+fra+chi_sim"
        tesseract.engineMode = .TesseractOnly
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        return tesseract.recognizedText
        
    }
    func performImageRecognitionWithoutChinese(image: UIImage) -> String! {
        scaleImage(image, maxDimension: 640)
        
        let tesseract = G8Tesseract()
        tesseract.language = "eng+fra"
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        return tesseract.recognizedText
        
    }

    
    //Scale the image before processing it
    private func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSizeMake(maxDimension, maxDimension)
        var scaleFactor:CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}