//
//  MyPageViewController.swift
//  How_About_U
//
//  Created by 박중선 on 2023/03/08.
//

import UIKit

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func tapLogoutButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "pw")
        self.dismiss(animated: true)
    }
    
    //func goToLoginViewController
    

}
