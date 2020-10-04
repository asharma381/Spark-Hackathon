//
//  HomeViewController.swift
//  Cafegram2EN
//
//  Created by Aditya Sharma on 2/22/20.
//  Copyright © 2020 Farukh IQBAL. All rights reserved.
//

import UIKit
import Lottie
//import GoogleSignIn

class HomeViewController: UIViewController {
//, GIDSignInDelegate {
    
//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressAnimationView: AnimationView!
    
    var animationView : AnimationView?
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpAnimation()
        //GIDSignIn.sharedInstance()?.delegate = self
        // Do any additional setup after loading the view.
        
        progressAnimationView.backgroundColor = .clear
        //progressAnimationView.loopMode = .loop
        progressAnimationView.play()
        
//        animationView = .init(name: "check")
//        animationView?.frame = view.bounds
//        view.addSubview(animationView!)
        
        //images = createImageArray(total: 59, imagePrefix: "PR")
    }
    
    @IBAction func getStartedTapped(_ sender: UIButton) {
        let transition = storyboard?.instantiateViewController(identifier: "tabController") as? TabBarViewController
        view.window?.rootViewController = transition
        view.window?.makeKeyAndVisible()
    }
    
    
    //    func createImageArray(total: Int, imagePrefix: String) -> [UIImage]{
//
//        var imageArray: [UIImage] = []
//
//        for imageCount in 0..<total {
//            let imageName = "\(imagePrefix)_\(imageCount).png"
//            let image = UIImage(named: imageName)!
//
//            imageArray.append(image)
//        }
//
//        return imageArray
//    }
//
//    func animate(imageView: UIImageView, image: [UIImage]) {
//        imageView.animationImages = images
//        imageView.animationDuration = 2.0
//        imageView.animationRepeatCount = 5
//        imageView.startAnimating()
//    }
    
    
//    @IBAction func googleLogin(_ sender: UIButton) {
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.signIn()
//    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if error != nil {
//            print(user.userID!)
//        }
//    }
    
//    func setUpAnimation(){
//        animationView.animation = Animation.named("check")
//        animationView.frame = CGRect(x: 0, y: 200, width: 200, height: 200)
//        animationView.backgroundColor = .black
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        animationView.play()
//    }
    
}
