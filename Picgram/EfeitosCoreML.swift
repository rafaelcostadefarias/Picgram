//
//  EfeitosCoreML.swift
//  Picgram
//
//  Created by Rafael Farias on 12/03/18.
//  Copyright © 2018 Rafael Farias. All rights reserved.
//

import UIKit
import CoreML

/// Image buffer.
typealias ImageBuffer = CVPixelBuffer

extension FilterManager{
    
    func aplicaLapisCoreML(_ inputImage : UIImage) -> UIImage{
        
        let hedMain = HED_fuse()
        let hedSO = HED_so()
        var selectedModel = "upscore-dsn1"
        
        
        // Convert our image to proper input format
        // In this case we need to feed pixel buffer which is 500x500 sized.
        let originalW = inputImage.size.width
        let originalH = inputImage.size.height
        let inputW = 500
        let inputH = 500
        guard let inputPixelBuffer = inputImage.resized(width: inputW, height: inputH)
            .pixelBuffer(width: inputW, height: inputH) else {
                fatalError("Couldn't create pixel buffer.")
        }
        
        //Use model dsn1
        let featureProvider: MLFeatureProvider
        featureProvider = try! hedSO.prediction(data: inputPixelBuffer)
        
        // Retrieve results
        guard let outputFeatures = featureProvider.featureValue(for: selectedModel)?.multiArrayValue else {
            fatalError("Couldn't retrieve features")
        }
        
        // Calculate total buffer size by multiplying shape tensor's dimensions
        let bufferSize = outputFeatures.shape.lazy.map { $0.intValue }.reduce(1, { $0 * $1 })
        
        // Get data pointer to the buffer
        let dataPointer = UnsafeMutableBufferPointer(start: outputFeatures.dataPointer.assumingMemoryBound(to: Double.self),
                                                     count: bufferSize)
        
        // Prepare buffer for single-channel image result
        var imgData = [UInt8](repeating: 0, count: bufferSize)
        
        // Normalize result features by applying sigmoid to every pixel and convert to UInt8
        for i in 0..<inputW {
            for j in 0..<inputH {
                let idx = i * inputW + j
                let value = dataPointer[idx]
                
                let sigmoid = { (input: Double) -> Double in
                    return 1 / (1 + exp(-input))
                }
                
                let result = sigmoid(value)
                imgData[idx] = UInt8(result * 255)
            }
        }
        
        // Create single chanel gray-scale image out of our freshly-created buffer
        let cfbuffer = CFDataCreate(nil, &imgData, bufferSize)!
        let dataProvider = CGDataProvider(data: cfbuffer)!
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let cgImage = CGImage(width: inputW, height: inputH, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: inputW, space: colorSpace, bitmapInfo: [], provider: dataProvider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        let resultImage = UIImage(cgImage: cgImage!)
        
        return originalImageSize(resultImage, originalW, oriH: originalH)
        
    }
    
    func aplicaCandy(_ inputImage : UIImage) -> ImageBuffer?{
        
        let model = FNSCandy()
        
        let inputW = 720
        let inputH = 720
        
        let resizedImage = inputImage.resized(width: inputW, height: inputH)
        let prediction = try? model.prediction(inputImage: buffer(resizedImage)!)
        
        return prediction?.outputImage
        
        
    }
    
    func aplicaFeathers(_ inputImage : UIImage) -> ImageBuffer?{
        
        let model = FNSFeathers()
        
        let inputW = 720
        let inputH = 720
        
        let resizedImage = inputImage.resized(width: inputW, height: inputH)
        let prediction = try? model.prediction(inputImage: buffer(resizedImage)!)
        
        return prediction?.outputImage
        
    }
    
    func aplicaLaMuse(_ inputImage : UIImage) -> ImageBuffer?{
        
        let model = FNSLaMuse()
        
        let inputW = 720
        let inputH = 720
        
        let resizedImage = inputImage.resized(width: inputW, height: inputH)
        let prediction = try? model.prediction(inputImage: buffer(resizedImage)!)
        
        return prediction?.outputImage
        
    }
    
    func aplicaScream(_ inputImage : UIImage) -> ImageBuffer?{
        
        let model = FNSTheScream()
        
        let inputW = 720
        let inputH = 720
        
        let resizedImage = inputImage.resized(width: inputW, height: inputH)
        let prediction = try? model.prediction(inputImage: buffer(resizedImage)!)
        
        return prediction?.outputImage
        
    }
    
    func aplicaMosaico(_ inputImage : UIImage) -> ImageBuffer?{
        
        let model = FNSMosaic()
        
        let inputW = 720
        let inputH = 720
        
        let resizedImage = inputImage.resized(width: inputW, height: inputH)
        let prediction = try? model.prediction(inputImage: buffer(resizedImage)!)
        
        return prediction?.outputImage
        
    }
    
    func aplicaUdnie(_ inputImage : UIImage) -> ImageBuffer?{
        
        let model = FNSUdnie()
        
        let inputW = 720
        let inputH = 720
        
        let resizedImage = inputImage.resized(width: inputW, height: inputH)
        let prediction = try? model.prediction(inputImage: buffer(resizedImage)!)
        
        return prediction?.outputImage
        
    }
    
    //Converte de CVPixelBuffer para CGImage
    func CreateCGImageFromCVPixelBuffer(pixelBuffer: CVPixelBuffer) -> CGImage? {
        let bitmapInfo: CGBitmapInfo
        let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
        if kCVPixelFormatType_32ARGB == sourcePixelFormat {
            bitmapInfo = [.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)]
        } else
            if kCVPixelFormatType_32BGRA == sourcePixelFormat {
                bitmapInfo = [.byteOrder32Little, CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)]
            } else {
                return nil
        }
        
        // only uncompressed pixel formats
        let sourceRowBytes = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        print("Buffer image size \(width) height \(height)")
        
        let val: CVReturn = CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        if  val == kCVReturnSuccess,
            let sourceBaseAddr = CVPixelBufferGetBaseAddress(pixelBuffer),
            let provider = CGDataProvider(dataInfo: nil, data: sourceBaseAddr, size: sourceRowBytes * height, releaseData: {_,_,_ in })
        {
            let colorspace = CGColorSpaceCreateDeviceRGB()
            let image = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: sourceRowBytes,
                                space: colorspace, bitmapInfo: bitmapInfo, provider: provider, decode: nil,
                                shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            return image
        } else {
            return nil
        }
    }
    
    /// Transforming the UIImage into a CVPixelBuffer (ImageBuffer).
    ///
    /// - Returns: Image buffer representation of the UIImage.
    func buffer(_ inputImage : UIImage) -> ImageBuffer? {
        let width = inputImage.size.width
        let height = inputImage.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        
        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        return nil
        }
        
        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        inputImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return resultPixelBuffer
    }
    
    func originalImageSize(_ finalImage : UIImage, _ oriW : CGFloat, oriH : CGFloat) -> UIImage{
        
        let image = finalImage
        
        //Retornar imagem ao tamanho original
        let originalWidth = oriW
        let aspectRatio = originalWidth / oriH
        var smallSize : CGSize
        //Se largura maior que altura = aspectRation > 1 = imagem landscape
        if aspectRatio > 1{
            smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
        } else {
            smallSize = CGSize(width: 1000*aspectRatio, height: 1000)
        }
        
        UIGraphicsBeginImageContext(smallSize)
        
        //Redimensionando a imagem
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Recuperar a imagem redimensionanda
        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //Finalizar o contexto de manipulacao da imagem
        UIGraphicsEndImageContext()
        ///
        return smallImage!
        
    }
    
}
