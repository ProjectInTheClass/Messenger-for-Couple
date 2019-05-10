//
//  TViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 10..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit


class TViewController: UIViewController, UICollectionViewDataSource {
    var photo : [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TCell", for: indexPath) as! TCellViewCell
        print(photo[indexPath.item])
        cell.image.image = UIImage(named: photo[indexPath.item])
        
        
        // Configure the cell
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
