//
//  PedometerViewController.swift
//  iSanpo
//
//  Created by hebochans on 2018/11/08.
//  Copyright © 2018 hebochans. All rights reserved.
//

import UIKit
import CoreMotion
import Photos

class PedometerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var label: UILabel!
    var durationStr = ""
    var pedometer:String = ""
    var myData:CMPedometerData!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(myData)
        label.text = "\(durationStr)\n\(myData.numberOfSteps) STEPS\n\(round(Double(truncating: myData.distance!))) FEET"

        // ラベルに枠を表示させるため
        self.label.layer.borderColor = UIColor(red: 63/255.0, green: 243/255.0, blue: 54/255.0, alpha: 1.0).cgColor
        

        //       ユーザーの許可
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized:
                print("authorized")
            case .notDetermined:
                print("otDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            }
        }
    }
    
    
    @IBAction func cameraButton(_ sender: UIButton) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func albumButton(_ sender: UIButton) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let picker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = picker
            
            UIImageWriteToSavedPhotosAlbum(picker, self, nil, nil)
            
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)//戻る時の処理
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        
        //写真をシェア
        if let sharedImage = imageView.image {
            let sharedItems = [sharedImage]
            let controller = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
            present(controller, animated: true,completion: nil)
        }
        
        // 共有する項目l
        let shareText = "今日のさんぽ行ってきたよ~"
//        let shareWebsite = NSURL(string: "https://hebochans.github.io/")!
        
        let activityItems = [shareText] as [Any]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        
        // 使用しないアクティビティタイプ
//        let excludedActivityTypes = [
//            UIActivity.ActivityType.postToFacebook,
//            UIActivity.ActivityType.postToTwitter,
//            UIActivity.ActivityType.message,
//            UIActivity.ActivityType.saveToCameraRoll,
//            UIActivity.ActivityType.print
//        ]
        
//        activityVC.excludedActivityTypes = excludedActivityTypes
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
        
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
