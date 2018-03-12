//
//  MetodosProprios.swift
//  Picgram
//
//  Created by Rafael Farias on 10/03/18.
//  Copyright © 2018 Rafael Farias. All rights reserved.
//

import UIKit


//MARK: Métodos próprios

extension ViewController{
    
    func alerta(){
        let alerta = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a foto", preferredStyle: .alert)
        
        //Verificar se camera disponivel
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action) in
                self.selectPicture(sourceType: .camera)
                
            })
            alerta.addAction(cameraAction)
        }
        
        //opcao para fotos do usuario
        let albumAction = UIAlertAction(title: "Fotos do usuário", style: .default) { (action) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
            
        }
        alerta.addAction(albumAction)
        
        //opcao para biblioteca de fotos
        let bibliAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
            
        }
        alerta.addAction(bibliAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alerta.addAction(cancelAction)
        
        
        present(alerta, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}



extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            //Limitar o tamanho da imagem em 1000 pixels
            let originalWidth = image.size.width
            let aspectRatio = originalWidth / image.size.height
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
            
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "effectsSegue", sender: smallImage)
            })
            
        }
    }
    
}

extension EfeitosViewController{
    func showLoading(_ show : Bool){
        viewLoading.isHidden = !show
    }
}


