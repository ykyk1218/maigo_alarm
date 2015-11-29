//
//  ViewController.swift
//  maigo_alarm
//
//  Created by 小林芳樹 on 2015/11/29.
//  Copyright © 2015年 小林芳樹. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CentralManagerModelDelegate {
    
    let stateLbl:UILabel = UILabel()
    let advertisBtn:UIButton = UIButton()
    let scanLbl: UILabel = UILabel()
    let deviseNameField:UITextField = UITextField()
    
    let centralManagerModel = CentralManagerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // オブジェクト配置
        //ラベル設定
        self.stateLbl.text = "　未接続　"
        self.stateLbl.backgroundColor = UIColor.redColor()
        self.stateLbl.textColor = UIColor.whiteColor()
        self.stateLbl.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, 200)
        self.stateLbl.sizeToFit()
        
        //デバイス名設定用テキストフィールド
        self.deviseNameField.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, 250)
        
        self.view.addSubview(self.stateLbl)
        self.view.addSubview(self.deviseNameField)
        
        self.centralManagerModel.cmModelDelegate = self
        //
    }
    
    func centralManagerModelDiscoverPeripheral(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral) {
        print("スキャン結果が見つかった時に呼ばれるデリゲートメソッド")
        
        if peripheral.name == "Test Devise" {
            
            let alertController:UIAlertController = UIAlertController(title: "接続確認", message: "\(peripheral.name)と接続します", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: {
                    (action:UIAlertAction!) -> Void in
                    print("接続開始")
                    self.centralManagerModel.startConnect()
            })
            
            let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                style: UIAlertActionStyle.Cancel,
                handler:{
                    (action:UIAlertAction!) -> Void in
                    print("接続Cancel")
            })
            
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func centralManagerModel(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("接続を開始した時に呼ばれるデリゲートメソッド")
        self.stateLbl.text = "接続成功"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

