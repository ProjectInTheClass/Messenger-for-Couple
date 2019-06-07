//
//  TViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 10..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
//import Firebase

class TViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var photo : [Any] = []
    var photoName : String = ""
    var photoHash : [Int] = []
    
    let picker = UIImagePickerController()
    
    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return photo.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = scroll.dequeueReusableCell(withReuseIdentifier: "TCell", for: indexPath) as! TCellScroll
     print(photo[indexPath.item])
     cell.image.image = UIImage(named: photo[indexPath.item])
     
     
     // Configure the cell
     
     return cell
     }*/
    @IBAction func unwindVC1 (segue : UIStoryboardSegue) {
        var dataRecieved : [UIImage] = []
        if let sourceViewController = segue.source as? DViewController {
            dataRecieved = sourceViewController.delete
        }

        for i in 0...dataRecieved.count - 1{
            for j in 0...photo.count - 1{
                    if type(of:photo[j]) == String.self {
                        if UIImage(named: photo[j] as! String) ==  dataRecieved[i]  {
                            photo.remove(at: j)
                            break
                        }
                    }
                    else if type(of:photo[j]) == UIImage.self {
                        if photo[j] as? UIImage == dataRecieved[i] {
                            photo.remove(at: j)
                            break
                        }
                    }
                }
            
        }
        for index in 0...albums.count - 1 {
            var date = photoName.components(separatedBy: "/")
            if String(albums[index].year) == date[0] && String(albums[index].month) == date[1]  && String(albums[index].day) == date[2] {
                if photo.count != 0 {
                    albums[index].photo = photo
                    break
                }
                else {
                    albums.remove(at: index)
                    break
                }
                //selectedPhotosName = albums[index].name
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if photo.count == 0 {
            let nothing = UIAlertController(title: nil, message: "No photo in this day", preferredStyle: UIAlertController.Style.alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (action) in
                
                /*let storyboard: UIStoryboard = self.storyboard!
                 let nextView = storyboard.instantiateViewController(withIdentifier: "Main")
                 self.present(nextView, animated: true, completion: nil)
                 nextView.viewDidLoad()*/
                
                //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            
            nothing.addAction(ok)
            self.present(nothing, animated: true) {
                
            }
        }
        else {
            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            for i in 0..<photo.count {
                
                let imageView = UIImageView()
                if type(of: photo[i]) == String.self {
                    imageView.image = UIImage(named: photo[i] as! String)
                }
                else if type(of: photo[i]) == UIImage.self {
                    imageView.image = photo[i] as? UIImage
                }
                imageView.contentMode = .scaleAspectFit
                let xPosition = self.view.frame.width * CGFloat(i)
                
                imageView.frame = CGRect(x: xPosition, y: -100, width: self.view.frame.width, height: self.view.frame.height)
                scrollView.contentSize.width = self.view.frame.width * CGFloat(1+i)
                
                scrollView.addSubview(imageView)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
 
            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            for i in 0..<photo.count {
                
                let imageView = UIImageView()
                if type(of: photo[i]) == String.self {
                    imageView.image = UIImage(named: photo[i] as! String)
                }
                else if type(of: photo[i]) == UIImage.self {
                    imageView.image = photo[i] as? UIImage
                }
                imageView.contentMode = .scaleAspectFit
                let xPosition = self.view.frame.width * CGFloat(i)
                
                imageView.frame = CGRect(x: xPosition, y: -100, width: self.view.frame.width, height: self.view.frame.height)
                scrollView.contentSize.width = self.view.frame.width * CGFloat(1+i)
                
                scrollView.addSubview(imageView)
            }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if  segue.identifier == "DSegue",
            let detailVC = segue.destination as? DViewController {
        
            for i in 0...photo.count - 1{
                detailVC.photos.append(photo[i])
            }
            //detailVC.DCollectionView.reloadData()
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     print("222\n")
     if  segue.identifier == "TPhoto_segue",
     let detailVC = segue.destination as? TViewController,
     let cell = sender as? ACellViewCell {
     var selectedPhotos : [String] = []
     for index in 0...albums.count {
     if albums[index].name == cell.label.text {
     selectedPhotos = albums[index].photo
     }
     }
     detailVC.photo = selectedPhotos
     }
     }*/
    
    
}
/*extension TViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] {
            /*let localFile = info[UIImagePickerController.InfoKey.imageURL]
             let riversRef = storageRef.child("image/album")
             let uploadTask = riversRef.putFile(from: localFile, metadata: nil) {
             metadata, error in guard let metadata = metadata else {
             //when error occurred
             return
             }
             }*/
            print(type(of: image))
            photo.append(image)
            viewDidLoad()
            for i in 0...albums.count-1 {
                if albums[i].name == photoName {
                    albums[i].photo = photo
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}*/
