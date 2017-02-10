//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Gokulsree Yenugadhati on 2/9/17.
//  Copyright © 2017 Gokul Yenugadhati. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var picView: UIImageView!
    var imageTouse: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = imageTouse else{
            return
        }
        
        picView.image = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
