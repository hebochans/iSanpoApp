//
//  PedometerViewController.swift
//  iSanpo
//
//  Created by hebochans on 2018/11/08.
//  Copyright © 2018 hebochans. All rights reserved.
//

import UIKit

class PedometerViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var pedometer:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = pedometer

        // ラベルに円を表示させるため
//        self.label.layer.borderColor = UIColor(red: 63/255.0, green: 243/255.0, blue: 54/255.0, alpha: 1.0).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
