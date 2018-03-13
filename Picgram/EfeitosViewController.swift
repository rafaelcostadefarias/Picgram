//
//  EfeitosViewController.swift
//  Picgram
//
//  Created by Rafael Farias on 09/03/18.
//  Copyright © 2018 Rafael Farias. All rights reserved.
//

import UIKit

class EfeitosViewController: UIViewController {

    var image : UIImage!
    lazy var filterManager : FilterManager = {
       let filterManager = FilterManager(image: image)
        return filterManager
    }()
    
    
    let filterImageNames = [
    "comic",
    "sepia",
    "halftone",
    "crystallize",
    "vignette",
    "noir",
    "lapis",
    "candy",
    "feathers",
    "lamuse",
    "scream",
    "mosaico",
    "udnie"
    ]
    
    //MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var imageViewFoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewFoto.image = image
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FinalViewController
            vc.image = imageViewFoto.image
    
    }
    
}

//MARK: Extensions

extension EfeitosViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager.filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celula", for: indexPath) as! EfeitosCollectionViewCell

        cell.imageViewEfeitos.image = UIImage(named: filterImageNames[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let type = FilterType(rawValue: indexPath.row){
            showLoading(true)
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let filteredImage = self.filterManager.applyFilter(type: type)
                
                DispatchQueue.main.async {
                    self.imageViewFoto.image = filteredImage
                    self.showLoading(false)
                }
            }
            
        }
    }
}
