//
//  ViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 8..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let myUid = FirebaseDataService.instance.currentUserEmail?.replacingOccurrences(of: ".", with: "-")
    
    var ralbums = FirebaseDataService.instance.groupRef.child("albums")
    let storageRef = FirebaseDataService.instance.storage.reference()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //print(albums.count)
        if albums.count == 0 {
            self.label?.isEnabled = true
        }
        else {
            self.label?.isEnabled = false
        }
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACell", for: indexPath) as! ACellViewCell
        /*let year = albums.value(forKey: "year") as! String
         let month = albums.value(forKey: "month") as! String
         let day = albums.value(forKey: "day") as! String*/
        //print(albums[indexPath.item])
        let year = String(albums[indexPath.item].year)
        let month = String(albums[indexPath.item].month)
        let day = String(albums[indexPath.item].day)
        
        cell.layer.borderColor = UIColor.brown.cgColor
        cell.layer.borderWidth = 1
        let imageView = UIImageView()
        if type(of: albums[indexPath.item].photo[0]) == String.self {
            /*if let data = try? Data(contentsOf: URL(string: albums[indexPath.item].photo[0])!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.cellImage.image = image
                    }
                }
            }*/
            if let data = try? Data(contentsOf: URL(string: albums[indexPath.item].photo[0])!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.cellImage.image = image
                    }
                }
            }
            else {
                cell.cellImage.image = nil
            }
        }
        cell.label.text = year + "/" + month + "/" + day
        //cell.cellImage.image = albums[indexPath.item].photo[0]
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "TPhoto_segue",
            let detailVC = segue.destination as? TViewController,
            let cell = sender as? ACellViewCell {
            var selectedPhotos : [String] = []
            //var selectedPhotosName : String = ""
            
            for index in 0...albums.count - 1 {
                let date = cell.label.text?.components(separatedBy: "/")
                if String(albums[index].year) == date![0] && String(albums[index].month) == date![1]  && String(albums[index].day) == date![2] {
                    selectedPhotos = albums[index].photo
                    break
                    //selectedPhotosName = albums[index].name
                }
            }
            detailVC.photo = selectedPhotos
            detailVC.photoName = cell.label.text!
            //print("test: " + String(detailVC.photo.count))
        }
        
        
    }
    
    @IBOutlet weak var collectionview: UICollectionView!
    let picker = UIImagePickerController()
    
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        let groupName = FirebaseDataService.instance.userRef.child(myUid!).child("groups").child("groupname").observeSingleEvent(of: .value, with: {(snapshot) in
            let dic = snapshot.value as! Dictionary<String, String>.Element
            self.ralbums = FirebaseDataService.instance.groupRef.child(dic.value).child("albums")
        })
        //self.collectionview?.reloadData()
        for i in 0..<albums.count {
            for j in i+1..<albums.count {
                if albums[i].year > albums[j].year {
                    albums.swapAt(i, j)
                }
                else if albums[i].year == albums[i].year {
                    if albums[i].month > albums[j].month {
                        albums.swapAt(i, j)
                    }
                        
                    else if albums[i].month == albums[j].month {
                        if albums[i].day > albums[j].day {
                            albums.swapAt(i, j)
                        }
                    }
                }
                
            }
        }
        self.label?.text = "No Album. Make your albums"
        picker.delegate = self
        if albums.count == 0 {
            self.label?.isEnabled = true
        }
        else {
            self.label?.isEnabled = false
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.collectionview?.reloadData()
        if albums.count == 0 {
            self.label?.isEnabled = true
        }
        else {
            self.label?.isEnabled = false
        }
        
    }
    @IBAction func addPhoto(_ sender: Any) {
        openLibrary()
    }
    
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    /*func deletePhoto() {
     /*let storyBoard = self.storyboard!
     let DView = storyBoard.instantiateViewController(withIdentifier: "DView") as! DViewController
     */
     let storyBorad = UIStoryboard(name: "Main", bundle: nil)
     let modal = storyBorad.instantiateViewController(withIdentifier: "DView") as! DViewController
     modal.modalPresentationStyle = UIModalPresentationStyle.fullScreen
     modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
     
     for index in 0...albums.count - 1 {
     for num in 0...albums[index].photo.count - 1 {
     modal.photos.append(albums[index].photo[num])
     }
     }
     print(modal.photos.count)
     present(modal, animated: true, completion: nil)
     }*/
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let fileUrl = info[UIImagePickerController.InfoKey.imageURL] {
            //let image = info[UIImagePickerController.InfoKey.originalImage]
            let image = info[UIImagePickerController.InfoKey.imageURL]
            
            let imageSource = CGImageSourceCreateWithURL(fileUrl as! CFURL, nil)
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil)! as NSDictionary
            let exifDict = imageProperties.value(forKey: "{Exif}")  as! NSDictionary
            let dateTimeOriginal = exifDict.value(forKey: "DateTimeOriginal") as! String
            
            
            var date = dateTimeOriginal.components(separatedBy: " ")[0].components(separatedBy: ":")
            var downloadURL : URL? = nil
            
            //print((image as! URL))
            var imagepath = (image as! URL).absoluteString.split(separator: "/")
            let imagename = imagepath[imagepath.count-1]
            let rimagename = FirebaseDataService.instance.currentUserEmail! + "/" + imagename
            let imageRef = storageRef.child(rimagename)
            imageRef.putFile(from: (image as! URL), metadata: nil) { (metadata, error) in
                guard error == nil else {
                    print("put File error :", error);
                    return
                }
                print("upload success")
                
                imageRef.downloadURL(completion: { (url, error) in
                    guard error == nil else {
                        print("download url error :", error)
                        return
                    }
                    print("download url :", url)
                    downloadURL = url!
                    // Get the download URL for 'images/stars.jpg'
                    for index in 0..<albums.count {
                        //print("index : " + String(index))
                        
                        if Int(date[0]) == albums[index].year && Int(date[1]) == albums[index].month && Int(date[2]) == albums[index].day {
                            albums[index].photo.append((image as! URL).absoluteString)
                            self.ralbums.child("A"+date[0]+date[1]+date[2]).child("photo").updateChildValues([String(albums[index].photo.count-1): downloadURL!.absoluteString])
                            date = []
                            //print(image as! URL)
                            
                            //print(uploadTask)
                            
                            break
                        }
                            
                        else if index == albums.count-1 {
                            print(downloadURL)
                            let pnew : [String] = [(downloadURL!.absoluteString)]
                            let new = Album(year: Int(date[0])!, month:Int(date[1])!, day:Int(date[2])!, photo: pnew)
                            
                            albums.append(new)
                            self.ralbums.child("A"+date[0]+date[1]+date[2]).child("year").setValue(Int(date[0])!)
                            self.ralbums.child("A"+date[0]+date[1]+date[2]).child("month").setValue(Int(date[1])!)
                            self.ralbums.child("A"+date[0]+date[1]+date[2]).child("day").setValue(Int(date[2])!)
                            self.ralbums.child("A"+date[0]+date[1]+date[2]).child("photo").setValue(pnew)
                            
                            /*storageRef.child("common.jpeg").downloadURL { url, error in
                             if let error = error {
                             // Handle any errors
                             } else {
                             print(url)
                             // Get the download URL for 'images/stars.jpg'
                             }
                             }*/
                        }
                        
                    }
                    if albums.count == 0 {
                        let pnew : [String] = [(downloadURL?.absoluteString)!]
                        let new = Album(year: Int(date[0])!, month:Int(date[1])!, day:Int(date[2])!, photo: pnew)
                        albums.append(new)
                        self.ralbums.child("A"+date[0]+date[1]+date[2]).child("year").setValue(Int(date[0])!)
                        self.ralbums.child("A"+date[0]+date[1]+date[2]).child("month").setValue(Int(date[1])!)
                        self.ralbums.child("A"+date[0]+date[1]+date[2]).child("day").setValue(Int(date[2])!)
                        self.ralbums.child("A"+date[0]+date[1]+date[2]).child("photo").setValue(new)
                        
                        
                    }
                    for i in 0..<albums.count {
                        for j in i+1..<albums.count {
                            if albums[i].year > albums[j].year {
                                albums.swapAt(i, j)
                            }
                            else if albums[i].year == albums[i].year {
                                if albums[i].month > albums[j].month {
                                    albums.swapAt(i, j)
                                }
                                    
                                else if albums[i].month == albums[j].month {
                                    if albums[i].day > albums[j].day {
                                        albums.swapAt(i, j)
                                    }
                                }
                            }
                            
                        }
                    }
                    self.collectionview.reloadData()
                    
                

                })
                

                // Metadata contains file metadata such as size, content-type.

                // You can also access to download URL after upload.
            }
            //let uploadTask = storageRef.putFile(from: image as! URL)
          
            
 
            
            
        }
        dismiss(animated: true, completion: nil)
    }
}
