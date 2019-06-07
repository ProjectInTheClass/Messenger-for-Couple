//
//  ViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 8..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
        cell.label.text = String(albums[indexPath.item].year) + "/" + String(albums[indexPath.item].month) + "/" + String(albums[indexPath.item].day)
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
        self.label?.text = "No Album. Make your albums"
        picker.delegate = self
        if albums.count == 0 {
            self.label?.isEnabled = true
        }
        else {
            self.label?.isEnabled = false
            
        }
        //self.collectionview?.reloadData()
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
 
            let image = info[UIImagePickerController.InfoKey.originalImage]
            let imageSource = CGImageSourceCreateWithURL(fileUrl as! CFURL, nil)
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil)! as NSDictionary
            let exifDict = imageProperties.value(forKey: "{Exif}")  as! NSDictionary
            let dateTimeOriginal = exifDict.value(forKey: "DateTimeOriginal") as! String
            
        
            let date = dateTimeOriginal.components(separatedBy: " ")[0].components(separatedBy: ":")
            for index in 0...albums.count - 1 {
                //print("index : " + String(index))
                
                if Int(date[0]) == albums[index].year && Int(date[1]) == albums[index].month && Int(date[2]) == albums[index].day {
                    albums[index].photo.append(image!)

                    break
                }
                
                else if index == albums.count-1 {
                    let pnew : [Any] = [image!]
                    let new = Album(year: Int(date[0])!, month:Int(date[1])!, day:Int(date[2])!, photo: pnew)
    
                    albums.append(new)
                    
                    
                    for i in 0...albums.count - 1 {
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
                
                
                }
            }

        }
        dismiss(animated: true, completion: nil)
    }
}
