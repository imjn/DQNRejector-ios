//
//  SendDQNViewController.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class SendDQNViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var audioPlayerInstance : AVAudioPlayer! = nil
    var targetAddress = String()
    var targetName = String()
    var dataList = [String]()
    var selectedValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        valueView.Amin()
        
        selectedValue = "1"
        
        for i in 1...101 {
            
            let str = i.description
            dataList.append(str)
            
        }
        
        nameLabel.text = targetName
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let soundFilePath = Bundle.main.path(forResource: "beamgun", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        // AVAudioPlayerのインスタンスを作成
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成失敗")
        }
        // バッファに保持していつでも再生できるようにする
        audioPlayerInstance.prepareToPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendDQN(_ sender: Any) {
        
        sendDQN(UrlStr: "https://us-central1-nishikigoi-5324d.cloudfunctions.net/SendDQN", address: targetAddress, num: selectedValue)
        
        self.audioPlayerInstance.play()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        selectedValue = dataList[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // 表示するラベルを生成する
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70))
        label.textAlignment = .center
        label.text = dataList[row]
        label.font = UIFont(name: "Hiragino Maru Gothic ProN",size:35)
        label.textColor = .white
        return label
    }
    
    func sendDQN(UrlStr: String, address: String, num: String) {
        
        let url = UrlStr
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = [
            "to" : address,
            "value" : num
        ]
        
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
                            
                            let json = response.data
                            
                            if let resultData = try? JSONDecoder().decode(txHash.self, from: json!)
                            {
                                
                                if resultData.txHash.count == 66 {
                                    
                                    print("成功！！！")
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }
                                
                            }
                            
                            print("oooooooops error")
                            debugPrint(response)
        }
        
    }
}
