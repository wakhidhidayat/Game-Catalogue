//
//  ProfileViewController.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 06/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageProfile.layer.borderWidth = 1
        imageProfile.layer.masksToBounds = false
        imageProfile.layer.borderColor = UIColor.black.cgColor
        imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        imageProfile.clipsToBounds = true
    }

}
