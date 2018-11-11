//
//  StopwatchViewController.swift
//  iSanpo
//
//  Created by hebochans on 2018/11/08.
//  Copyright © 2018 hebochans. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class StopwatchViewController: UIViewController {
    
    // ボタンを押した時に音を出すための再生オブジェクトを格納する。
    var startAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    // メンバー変数でないと動作しない
    var pedometer = CMPedometer()
    var myData:CMPedometerData!
    var durationStr = ""
    
    // backgroundTaskIDの初期値はなんでも良さそうです。とりあえず0を代入しておきます。
    var backgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    // アプリで使用する音の準備
    func setupSound() {
        // ボタンを押した時の音の設定。
        if let sound = Bundle.main.path(forResource: "wanwan", ofType: ".mp3") {
            startAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            startAudioPlayer.prepareToPlay()
        }
    }
    
    // ストップウォッチ
    var countNum = 0
    var timerRunning = false
    var timer = Timer()
    
    @objc func updateDisplay(){
        // ストップウォッチ
        countNum += 1
        let ms = countNum % 100
        let s = (countNum - ms) / 100 % 60
        let m = (countNum - s - ms) / 6000 % 3600
        let hr = (countNum - s - ms - m ) / 6000 / 3600
        
        if countNum < 360000{
            timeDisplay.text = String(format: "%02d:%02d.%02d", m,s,ms)
        } else {
            timeDisplay.text = String(format: "%01d:%02d:%02d.%02d", hr,m,s,ms)
        }
        
    }

    @IBOutlet weak var timeDisplay: UILabel!
    
    
    func longTimeFunction() {
        // 長い時間かかる処理
        // 処理が終わったらコレを書く
        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        
        
        // ストップウォッチをスタート
        if timerRunning == false{
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(StopwatchViewController.updateDisplay), userInfo: nil, repeats: true)
            timerRunning = true
            // ボタンを押した時に音が鳴る
            startAudioPlayer.play()
            
            // CMPedometerが利用できるか確認
            if CMPedometer.isStepCountingAvailable() {
            // 計測開始
            startPedometer()
            }
            // ボタンが押されたら時間のかかる処理をする。
            // 処理中にユーザがアプリを閉じても大丈夫なようにしたい。
            // 中断されたら困る処理の起点にコレを書く
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            self.longTimeFunction()
        }
        
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        // ストップウォッチをストップ
        if timerRunning == true{
            timer.invalidate()
            timerRunning = false
            durationStr = timeDisplay.text!
            // ボタンを押した時に音が鳴る
            startAudioPlayer.play()
            // 歩数計
            self.pedometer.stopUpdates()
            
        }
    }
    
    @IBAction func resultButton(_ sender: Any) {
        //遷移したいタイミングで呼ぶ
//        performSegue(withIdentifier: "nextPage", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 音の準備
        setupSound()
    }
    
    func startPedometer() {
        // 歩数計を生成
        pedometer = CMPedometer()
        
        // 歩数計で計測開始
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let data = pedometerData else {
                return
            }
            print(data.numberOfSteps)
            print(data.distance)
            self.myData = data
        })
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextPage" {
            let pedometerViewController:PedometerViewController = segue.destination as! PedometerViewController
            pedometerViewController.myData = myData
            pedometerViewController.durationStr = durationStr
        }
    }
}
