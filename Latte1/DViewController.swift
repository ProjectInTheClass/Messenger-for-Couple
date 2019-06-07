//
//  DViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 6. 3..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
class DCellView:UICollectionViewCell {    
    @IBOutlet weak var image: UIImageView!
    /*override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                //This block will be executed whenever the cell’s selection state is set to true (i.e For the selected cell)
                self.layer.borderColor = UIColor.brown.cgColor
                self.layer.borderWidth = 1
            }
            else
            {
                //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)
                self.layer.borderColor = nil
                self.layer.borderWidth = 0
                
            }
        }
    }*/
}

class DViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var photos : [Any] = []
    var delete : [UIImage] = []
    var photosHash : [Int] = []
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        DCollectionView.delegate = self
        DCollectionView.dataSource = self
        self.DCollectionView.reloadData()
        if delete.count == 0 {
            doneButton.isEnabled = false
        }
        /*else {
            doneButton.isEnabled = true
        }*/
        //self.collectionview.reloadData()
        // Do any additional setup after loading the view.
    }
    

    
    @IBOutlet weak var doneButton: UIBarButtonItem!

    @IBOutlet weak var DCollectionView: UICollectionView!

    @IBAction func pushDone(_ sender: Any) {
        
        /*let alert = UIAlertController(title: "Really delete seletected photos?", message: "If you push Delete button, can't recover the data", preferredStyle: UIAlertController.Style.alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { (action) in
        
            for i in 0...self.delete.count - 1 {
                for j in 0...self.photosHash.count - 1{
                    if self.delete[i] == self.photosHash[j] {
                        self.photos.remove(at: j)
                        self.photosHash.remove(at: j)
                    }
                }
            }
            self.delete.removeAll()
            self.dismiss(animated: true, completion: nil)

                        /*if self.photos.count != 0 {
                //self.viewDidLoad()
                let storyboard: UIStoryboard = self.storyboard!
                let nextView = storyboard.instantiateViewController(withIdentifier: "Photo")
                self.present(nextView, animated: true, completion: nil)
                
            }
            else {
                /*let nothing = UIAlertController(title: nil, message: "No photo in this day", preferredStyle: UIAlertController.Style.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    (action) in*/
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "Main")
                    self.present(nextView, animated: true, completion: nil)
                    nextView.viewDidLoad()
               // }
                
               // nothing.addAction(ok)
               // present(nothing, animated: true, completion: nil)
            }
        }
             */}
        let defaultAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (action) in
        }
        
        alert.addAction(deleteAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
 */
    }
    
    @IBAction func goTo1(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DCell", for: indexPath) as! DCellView
    
        if type(of: photos[indexPath.item]) == String.self {
            cell.image.image = UIImage(named: photos[indexPath.item] as! String)
            //cell.image.sizeThatFits(cell.frame.size)
            cell.image.frame.size = cell.frame.size
        }
        else if type(of: photos[indexPath.item]) == UIImage.self {
            cell.image.image = photos[indexPath.item] as? UIImage
            cell.image.frame.size = cell.frame.size
        }
    
        photosHash.append(cell.hashValue)
        
       /* if cell.layer.borderWidth == 1 {
            delete.append(self.hashValue)
        }
        else {
            if delete.count > 0 {
                for i in 0...delete.count - 1{
                    if delete[i] == cell.hashValue {
                        delete.remove(at: i)
                        break
                    }
                }
            }
        }*/
        
        
        // Configure the cell
        
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DCellView
        //cell?.layer.borderColor = UIColor.magenta.cgColor
        
        if cell.layer.borderColor != UIColor.brown.cgColor {
            cell.layer.borderColor = UIColor.brown.cgColor
            cell.layer.borderWidth = 3
            doneButton.isEnabled = true
            
            
            delete.append(cell.image!.image!)
        }
        else {
            cell.layer.borderColor = nil
            cell.layer.borderWidth = 0
            if delete.count > 0 {
                for i in 0...delete.count - 1{
                    if delete[i] == cell.image.image {
                        delete.remove(at: i)
                        //doneButton.isEnabled = false
                        break
                    }
                }
                if delete.count == 0 {
                    doneButton.isEnabled = false
                }
                
            }
        }
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
