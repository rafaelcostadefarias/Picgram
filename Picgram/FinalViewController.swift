//
//  FinalViewController.swift
//  Picgram
//
//  Created by Rafael Farias on 09/03/18.
//  Copyright © 2018 Rafael Farias. All rights reserved.
//

import UIKit
import Photos

class FinalViewController: UIViewController {
    
    var image: UIImage!
    
    //MARK: Outlets
    
    @IBOutlet weak var imageViewFoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewFoto.image = image
        imageViewFoto.layer.borderWidth = 10
        imageViewFoto.layer.borderColor = UIColor.white.cgColor
    }
    
    func saveToAlbum(){
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
            let addAssetRequest = PHAssetCollectionChangeRequest()
            addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
        }) { (sucess, error) in
            if !sucess {
                print(error!.localizedDescription)
            } else {
                let alerta = UIAlertController(title: "Imagem Salva", message: "Imagem salva no álbum de fotos", preferredStyle: .alert)
                let acaoOk = UIAlertAction(title: "OK", style: .default, handler: nil)
                alerta.addAction(acaoOk)
                self.present(alerta, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: Actions
    
    @IBAction func salvar(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.saveToAlbum()
            default:
                
                let alerta = UIAlertController(title: "Erro", message: "Você precisa autorizar acesso ao álbum para poder salvar a foto", preferredStyle: .alert)
                let acaoOk = UIAlertAction(title: "OK", style: .default, handler: nil)
                alerta.addAction(acaoOk)
                self.present(alerta, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func compartilhar(_ sender: UIButton) {
        
        // image to share
        let image = self.image
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func comecar(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
