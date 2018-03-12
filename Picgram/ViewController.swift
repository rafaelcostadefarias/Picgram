//
//  ViewController.swift
//  Picgram
//
//  Created by Rafael Farias on 09/03/18.
//  Copyright © 2018 Rafael Farias. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EfeitosViewController
        vc.image = sender as! UIImage
    }
    
    //MARK: Actions
    
    @IBAction func tirarEscolherFoto(_ sender: UIButton) {
        
        alerta()
        

    }
    
    
    
}


