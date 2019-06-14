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
    let myUid = FirebaseDataService.instance.currentUserEmail
    @IBOutlet weak var scrollView: UIScrollView!
    var photo : [String] = []
    var photoName : String = ""
    var photoHash : [Int] = []
    var ralbums = FirebaseDataService.instance.groupRef.child("albums")
    let picker = UIImagePickerController()
    let storageRef = FirebaseDataService.instance.storage.reference()
    
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
                        var dimage : UIImage? = nil
                        if let data = try? Data(contentsOf: URL(string: photo[j])!) {
                            if let image = UIImage(data: data) {
                                    dimage = image
                            }
                        }
                        print(dimage?.pngData() == dataRecieved[i].pngData())
                        
                        if dimage?.pngData()?.description ==  dataRecieved[i].pngData()?.description  {
                    
                            let file = photo[j].split(separator: "/")
                            let name = file[file.count-1].split(separator: "?")[0]
                            let real = FirebaseDataService.instance.currentUserUid! + "/" + name
                            
                                storageRef.child(real).delete { error in
                                if let error = error {
                                    // Uh-oh, an error occurred!
                                } else {
                                    // File deleted successfully
                                }
                            }
                            photo.remove(at: j)
                            
                            print(photo.count)
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
               
                if Int(date[1])! < 10 {
                    date[1] = "0"+date[1]
                }
                if Int(date[2])! < 10 {
                    date[2] = "0"+date[2]
                }
                if photo.count != 0 {
                    ralbums.child("A"+date[0]+date[1]+date[2]).child("photo").setValue(photo)
                    albums[index].photo = photo
                    break
                }
                else {
                    print(date[0]+date[1]+date[2])
                    ralbums.child("A"+date[0]+date[1]+date[2]).removeValue()
                    albums.remove(at: index)
                    print(albums.count)
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
                    //let data = Data(contentsOf: URL(string: photo[i])!)
                    //imageView.image = UIImage(data: data)
                    print(URL(fileURLWithPath: photo[i]))
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: photo[i])) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                imageView.image = image
                            }
                        }
                    }
                    //imageView.image = UIImage(contentsOfFile: photo[i])
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
        let groupName = FirebaseDataService.instance.userRef.child(myUid!).child("groups").child("groupname").observeSingleEvent(of: .value, with: {(snapshot) in
            let dic = snapshot.value as! Dictionary<String, String>.Element
            self.ralbums = FirebaseDataService.instance.groupRef.child(dic.value).child("albums")
        })
            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            for i in 0..<photo.count {
                
                let imageView = UIImageView()
                if type(of: photo[i]) == String.self {
                    if let data = try? Data(contentsOf: URL(string: photo[i])!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                imageView.image = image
                            }
                        }
                    }
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
