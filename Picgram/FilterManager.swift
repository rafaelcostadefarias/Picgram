//
//  FilterManager.swift
//  Picgram
//
//  Created by Rafael Farias on 10/03/18.
//  Copyright © 2018 Rafael Farias. All rights reserved.
//

import UIKit
import CoreML

enum FilterType : Int{
    case comic
    case sepia
    case halftone
    case crystallize
    case vignette
    case noir
    case lapis
    case candy
    case feathers
    case lamuse
    case scream
    case mosaico
    case udnie
}

class FilterManager{
    let originalImage : UIImage
    let context = CIContext(options: nil)
    let filterNames = [
    
        "CIComicEffect",
        "CISepiaTone",
        "CICMYKHalftone",
        "CICrystallize",
        "CIVignette",
        "CIPhotoEffectNoir",
        //Efeitos CoreML
        "lapis",
        "candy",
        "feathers",
        "lamuse",
        "scream",
        "mosaico",
        "udnie"
    ]
    
    init(image: UIImage) {
        self.originalImage = image
    }
    
    func applyFilter(type : FilterType) -> UIImage{
        let ciImage = CIImage(image: originalImage)!
        
        ////////Efeitos CoreML
        
        switch type.hashValue {
        case 6:
            return aplicaLapisCoreML(self.originalImage)
        case 7:
            let imageCandy = aplicaCandy(self.originalImage)
            let imageCGI = CreateCGImageFromCVPixelBuffer(pixelBuffer: imageCandy!)
            let imageUI = UIImage(cgImage: imageCGI!)
            
            return originalImageSize(imageUI, self.originalImage.size.width , oriH: self.originalImage.size.height)
        case 8:
            let imageFeathers = aplicaFeathers(self.originalImage)
            let imageCGI = CreateCGImageFromCVPixelBuffer(pixelBuffer: imageFeathers!)
            let imageUI = UIImage(cgImage: imageCGI!)
            
            return originalImageSize(imageUI, self.originalImage.size.width , oriH: self.originalImage.size.height)
            
        case 9:
            
            let imageLaMuse = aplicaLaMuse(self.originalImage)
            let imageCGI = CreateCGImageFromCVPixelBuffer(pixelBuffer: imageLaMuse!)
            let imageUI = UIImage(cgImage: imageCGI!)
            
            return originalImageSize(imageUI, self.originalImage.size.width , oriH: self.originalImage.size.height)
            
        case 10:
            let imageScream = aplicaScream(self.originalImage)
            let imageCGI = CreateCGImageFromCVPixelBuffer(pixelBuffer: imageScream!)
            let imageUI = UIImage(cgImage: imageCGI!)
            
            return originalImageSize(imageUI, self.originalImage.size.width , oriH: self.originalImage.size.height)
        case 11:
            let imageMosaico = aplicaMosaico(self.originalImage)
            let imageCGI = CreateCGImageFromCVPixelBuffer(pixelBuffer: imageMosaico!)
            let imageUI = UIImage(cgImage: imageCGI!)
            
            return originalImageSize(imageUI, self.originalImage.size.width , oriH: self.originalImage.size.height)
        case 12:
            let imageUdnie = aplicaUdnie(self.originalImage)
            let imageCGI = CreateCGImageFromCVPixelBuffer(pixelBuffer: imageUdnie!)
            let imageUI = UIImage(cgImage: imageCGI!)
            
            return originalImageSize(imageUI, self.originalImage.size.width , oriH: self.originalImage.size.height)
            
        default:
            break
        }
        
        ///////////Filtros Normais
        
        let filter = CIFilter(name: filterNames[type.hashValue])!
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        switch type {
        case .comic:
            break
        case .sepia:
            filter.setValue(1.0, forKey: kCIInputIntensityKey)
        case .halftone:
            filter.setValue(25, forKey: kCIInputWidthKey)
        case .crystallize:
            filter.setValue(15, forKey: kCIInputRadiusKey)
        case .vignette:
            filter.setValue(3, forKey: kCIInputIntensityKey)
            filter.setValue(30, forKey: kCIInputRadiusKey)
        case .noir:
            break
        case .lapis:
            break
        case .candy:
            break
        case .feathers:
            break
        case .lamuse:
            break
        case .scream:
            break
        case .mosaico:
            break
        case .udnie:
            break
        }
        let filteredImage = filter.value(forKey: kCIOutputImageKey) as! CIImage
        let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent)
        
        return UIImage(cgImage: cgImage!)
        
    }
    
}
