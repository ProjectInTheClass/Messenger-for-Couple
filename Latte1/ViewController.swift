//
//  ViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 8..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let ralbums = FirebaseDataService.instance.groupRef.child("albums")
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
        let year = String(albums[indexPath.item].year)
        let month = String(albums[indexPath.item].month)
        let day = String(albums[indexPath.item].day)
        cell.label.text = year + "/" + month + "/" + day
        cell.layer.borderColor = UIColor.brown.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "TPhoto_segue",
            let detailVC = segue.destination as? TViewController,
            let cell = sender as? ACellViewCell {
            var selectedPhotos : [Any] = []
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
        /*var photo : [Any] = []
         var year : [Int] = []
         var month : [Int] = []
         var day : [Int] = []
         ralbums.observeSingleEvent(of: .value, with: { (snapshot) in
         
         if let dict = snapshot.value as? Dictionary<String, AnyObject> {
         
         for (key, _) in dict {
         self.ralbums.child(key).observeSingleEvent(of: .value, with:{ (snapshot) in
         
         if let dic = snapshot.value as? Dictionary<String, Any> {
         
         
         for(dkey, _) in dic {
         
         if dkey  == "photo" {
         
         self.ralbums.child(key).child(dkey).observeSingleEvent(of: .value, with: {(snapshot) in
         
         if let p = snapshot.value as? Array<Any> {
         photo = p
         let nalbum = Album(year: year[0], month: month[0], day: day[0], photo: photo)
         year.remove(at: 0)
         month.remove(at: 0)
         day.remove(at: 0)
         //print(photo[0] as! String)
         albums.append(nalbum)
         //print(photo)
         }
         })
         
         }
         if dkey == "year" {
         year.append(dic[dkey] as! Int)
         }
         if dkey == "month" {
         month.append(dic[dkey] as! Int)
         }
         if dkey == "day" {
         day.append(dic[dkey] as! Int)
         }
         }
         
         //print(albums.count)
         }
         
         })
         
         }
         }
         
         })
         */
        self.storageRef.child(FirebaseDataService.instance.currentUserUid!)
        self.collectionview?.reloadData()
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
            
            
            let date = dateTimeOriginal.components(separatedBy: " ")[0].components(separatedBy: ":")
            for index in 0..<albums.count {
                //print("index : " + String(index))
                
                if Int(date[0]) == albums[index].year && Int(date[1]) == albums[index].month && Int(date[2]) == albums[index].day {
                    albums[index].photo.append(image!)
                    let uploadTask = storageRef.putFile(from: fileUrl as! URL, metadata: nil) { metadata, error in
                        guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        // Metadata contains file metadata such as size, content-type.
                        let size = metadata.size
                        // You can also access to download URL after upload.
                        self.storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                // Uh-oh, an error occurred!
                                return
                            }
                        }
                    }
                self.ralbums.child("A"+date[0]+date[1]+date[2]).child("photo").updateChildValues(["0":image as! String])
                    break
                }
                    
                else if index == albums.count-1 {
                    let pnew : [Any] = [image!]
                    let new = Album(year: Int(date[0])!, month:Int(date[1])!, day:Int(date[2])!, photo: pnew)
                    
                    albums.append(new)
                    
                    ralbums.child("A"+date[0]+date[1]+date[2]).child("year").setValue(Int(date[0])!)
                    ralbums.child("A"+date[0]+date[1]+date[2]).child("month").setValue(Int(date[1])!)
                    ralbums.child("A"+date[0]+date[1]+date[2]).child("day").setValue(Int(date[2])!)
                    ralbums.child("A"+date[0]+date[1]+date[2]).child("photo").setValue(pnew)
                    
                    
                    /*for i in 0...albums.count - 1 {
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
                     }*/
                    //ralbums.queryOrderedByKey()
                    
                    self.collectionview.reloadData()
                    
                    
                }
            }
            if albums.count == 0 {
                let pnew : [Any] = [image!]
                let new = Album(year: Int(date[0])!, month:Int(date[1])!, day:Int(date[2])!, photo: pnew)
                
                //albums.setValue(new, forKey: "A"+date[0]+date[1]+date[2])
                
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
