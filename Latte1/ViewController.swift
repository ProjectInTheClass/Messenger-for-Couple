//
//  ViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 8..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACell", for: indexPath) as! ACellViewCell
        cell.label.text = albums[indexPath.item].name
        cell.cellImage.image = UIImage(named: albums[indexPath.item].photo[0] as! String)
        
        
        
        // Configure the cell
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "TPhoto_segue",
            let detailVC = segue.destination as? TViewController,
            let cell = sender as? ACellViewCell {
            var selectedPhotos : [Any] = []
            var selectedPhotosName : String = ""
            for index in 0...albums.count - 1 {
                if albums[index].name == cell.label.text {
                    selectedPhotos = albums[index].photo
                    selectedPhotosName = albums[index].name
                }
            }
            detailVC.photo = selectedPhotos
            detailVC.photoName = selectedPhotosName
            //print("test: " + String(detailVC.photo.count))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

