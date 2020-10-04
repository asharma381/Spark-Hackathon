//
//  Report.swift
//  Cafegram2EN
// Ishan Version - The data other than the pictures are being sent to the FireBase database in the Cafegram2EN project in Ishan's FB (The name, address, etc)

import UIKit
import CoreData
import FirebaseDatabase
import FirebaseStorage
import MapKit


class NewCafeController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var cafe: CafeMO!
    
    var initialLatitude = 0.0
    var initialLongitude = 0.0
    var counter: Int = 1
    
    //
    
    @IBOutlet weak var imageView: UIImageView!
    var images: [UIImage] = []
    
    
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet weak var phoneTextField: RoundedTextField!{
    
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
 
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var photoImageView: UIImageView!
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        counter+=1
        print ("SCU TESTING SAVE BUTTON")
        
        
        
        //-------------------
        
        if typeTextField.text == "" || addressTextField.text == "" || descriptionTextView.text == ""
         || phoneTextField.text == ""
        {
            
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            
            present(alertController, animated: true, completion: nil)
 
            return
        }
      
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            //FB code here -> Where save button is used
           
            cafe = CafeMO(context: appDelegate.persistentContainer.viewContext)
            cafe.name = nameTextField.text
            cafe.type = typeTextField.text
            //cafe.address = addressTextField.text
            cafe.location = addressTextField.text
            cafe.phone = phoneTextField.text
            cafe.summary = descriptionTextView.text
            //
            
            cafe.isVisited = false
            
 
            let storageRef = Storage.storage().reference()
            storageRef.child("Picture")
            
            if let cafeImage = photoImageView.image {
                // For Xcode 9 users cafeImage.pngData() is equal to UIImagePNGRepresentation(cafeImage)
                cafe.image = cafeImage.pngData()
 
            }
 
 
            print("Saving data to context...")
            appDelegate.saveContext()
            
            
            
            //FB code
            //Data for picture storage
            
            // Upload the file to the path "images/rivers.jpg"
  
            // Data for database
            
            
            
            let ref = Database.database().reference()
            let newCafeRef = ref
                .child("Reports")
                .childByAutoId()
                //
                //.child("OURTEST")
            
            //
            
            print (cafe.image)
 
            //var userID
           // var numChild = newCafeRef.child("Reports").DataSnapshot.childrenCount
            
            ref.child("Reports").observe(DataEventType.value, with: { (snapshot) in
                let numChildren = snapshot.childrenCount
                var myLatitude : String = ""
                var access = MapViewController.self
                //myLatitude = access.initialLatitude
                
                var loc: String = String(self.initialLatitude) + ", " + String(self.initialLongitude)
                
                
                newCafeRef.setValue(["UserID": numChildren+1,  "Name": self.cafe.name, "Type": self.cafe.type, "Location": loc, "Phone" : self.cafe.phone,"Description" : self.cafe.summary])
                
                
            })
            //print("HelloJHKKJHJHJKJHKHKJHHJKHKJ")
            
          
            
            
           // let ref = Database.database().reference()
           // ref.child("numReports/1").setValue(["username": cafe.name])
 
            
            
            // MARK: - Upload Photo
            guard let image = photoImageView.image,
                  let data = image.jpegData(compressionQuality: 1.0)
                else {
                    print("Something went wrong with saving the image")
                    return
            }
            
            let imageName = UUID().uuidString
            let imageReference = Storage.storage().reference().child(imageName)
            
            imageReference.putData(data, metadata: nil) { (metadata, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                imageReference.downloadURL { (url, err) in
                    if let err = err {
                        print(err.localizedDescription)
                        return
                    }
                    
                    guard let url = url else{
                        print("Something went wrong")
                        return
                    }
                    
                    let dataReference = Database.database().reference()
                    
                    let urlString = url.absoluteString
                    
                }
            }
            
        }
 //-------------------
/*
        
        let alertController = UIAlertController(title: "Your Report Has Been Filed", message: "It has been sent and saved", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: {(action)in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        return
      */
            dismiss(animated: true, completion: nil)

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        //print ("HELLO")
        //print (newCafeRef)
       // let newCafeId = newCafeRef.key
        //images = createImageArray(total: 59, imagePrefix: "PR")

        
        
        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            // For Xcode 9 users, NSAttributedString.Key is equal to NSAttributedStringKey
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 153.0/255.0, alpha: 1), NSAttributedString.Key.font: customFont]
            
        }
        
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Text Field methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }

    
    // MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    //self.animate(imageView: self.imageView, image: self.images)
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    //self.animate(imageView: self.imageView, image: self.images)
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
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
//        imageView.animationRepeatCount = 2
//        imageView.startAnimating()
//    }
    
    // MARK: - Image Picker methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // For Xcode 9 users, UIImagePickerController.InfoKey.originalImage is UIImagePickerControllerOriginalImage
        // MARK: - Animate
        //imageView
//        animate(imageView: imageView, image: images)
        
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        initialLatitude = (locValue.latitude)
        initialLongitude = (locValue.longitude)
        
        print("locations = \(initialLatitude) \(initialLongitude)")
        let userLocation = locations.last
        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600, longitudinalMeters: 600)
        //self.mapView.setRegion(viewRegion, animated: true)
        
        
    }
}


extension NewCafeController{


    func uploadImage(_ image:UIImage, completion: @escaping (_ url: URL?) ->  ()){
        let storageRef = Storage.storage().reference().child("gotPic.png")
        let imgData = photoImageView.image?.pngData()  //Might not be correct
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storageRef.putData(imgData!, metadata: metaData) { (metaData, error) in
            if (error == nil){
                print("success")
                storageRef.downloadURL(completion: { (url, error) in
                    completion(url!)
                })
                
            }
            else{
                print("error in save image")
                completion(nil)
            }
            
        }
    }
    
    /*
     IN IF LET CAFEIMAGE
     
     let theImage = cafe.image!
     
     
     //guard let imageData = cafeImage.jpegData(compressionQuality: 0.5) else {return}
     
     storageRef.putData(theImage, metadata: nil, completion: {(metadata, error) in
     if (error != nil){
     print("error")
     return
     }
     print(metadata)
     })
     
     /*
     guard let profileImage = self.profilePicture.image else{return}
     if let uploadData = UIImageJPEGRepresentation(self.profilePicture.image!, 0.5){
     
     let StorageRef = Storage.storage().reference()
     let StorageRefChild = StorageRef.child("user_profile_pictures/\(uid).jpg")
     StorageRefChild.putData(uploadData, metadata: nil) { (metadata, err) in
     if let err = err {
     print("unable to upload Image into storage due to \(err)")
     }
     StorageRefChild.downloadURL(completion: { (url, err) in
     if let err = err{
     print("Unable to retrieve URL due to error: \(err.localizedDescription)")
     }
     let profilePicUrl = url?.absoluteString
     print("Profile Image successfully uploaded into storage with url: \(profilePicUrl ?? "" )")
     })
     }
     */
     //----------
     /*let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
     
     guard let metadata = metadata else {
     // Uh-oh, an error occurred!
     return
     }
     // Metadata contains file metadata such as size, content-type.
     let size = metadata.size
     // You can also access to download URL after upload.
     storageRef.downloadURL { (url, error) in
     guard let downloadURL = url else {
     // Uh-oh, an error occurred!
     return
     }
     }
     }
     */
     //print (imageData)
     */
    
}
