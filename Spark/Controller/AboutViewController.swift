//
//  AboutViewController.swift
//  Cafegram2EN

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnTapped(_ sender: UIButton) {
        let transition = storyboard?.instantiateViewController(identifier: "tabController") as? TabBarViewController
        view.window?.rootViewController = transition
        view.window?.makeKeyAndVisible()
    }
    
}
