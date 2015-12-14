//
//  ScanViewController.swift
//  maigo_alarm
//
//  Created by 小林芳樹 on 2015/11/30.
//  Copyright © 2015年 小林芳樹. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ScanViewController: UITableViewController, CentralManagerModelDelegate, CLLocationManagerDelegate {
    
    let scanLbl: UILabel = UILabel()
    let advertiseBtn: UIButton = UIButton()
    
    let centralManagerModel = CentralManagerModel()
    let peripheralModel = PeripheralModel()
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanLbl.text = "スキャン中です..."
        self.scanLbl.frame = CGRectMake(0,0,200,30)
        self.scanLbl.center = CGPointMake(self.view.bounds.width/2, 200)
        self.scanLbl.sizeToFit()
        
        self.advertiseBtn.frame = CGRectMake(0,0,200,30)
        self.advertiseBtn.center = CGPointMake(self.view.bounds.width/2, 250)
        self.advertiseBtn.setTitle("アドバタイズ開始", forState: .Normal)
        self.advertiseBtn.addTarget(peripheralModel, action: "advertising", forControlEvents: .TouchUpInside)
        self.advertiseBtn.backgroundColor = UIColor.blueColor()
        
        
        self.view.addSubview(self.scanLbl)
        self.view.addSubview(self.advertiseBtn)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        //スキャンとアドバタイズを開始        
        self.peripheralModel.advertising()
        
        self.centralManagerModel.cmModelDelegate = self
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingHeading()
    }

    func centralManagerModelDiscoverPeripheral(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral) {
        print("スキャン結果が見つかった時に呼ばれるデリゲートメソッド")
        print(peripheral.name)
        print(self.peripheralModel.scanName)
        
        if peripheral.name != nil {
            self.scanLbl.text = peripheral.name! + " : " + self.peripheralModel.scanName
            self.scanLbl.sizeToFit()
        }
    
        if peripheral.name == self.peripheralModel.scanName {
            
            let alertController:UIAlertController = UIAlertController(title: "接続確認", message: "\(peripheral.name)と接続します", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                handler: {
                    (action:UIAlertAction!) -> Void in
                    print("接続開始")
                    //スキャンによって発見したperipheralオブジェクトを
                    self.peripheralModel.peripheral = peripheral
                    
                    self.centralManagerModel.startConnect(peripheral)
                    
                    //スキャンを停止する
                    //アドバタイズを停止する
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
    
    func centralManagerModelDidConnectPeripheral(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("接続を開始した時に呼ばれるデリゲートメソッド \(peripheral))")
        self.peripheralModel.peripheral = peripheral
        self.peripheralModel.peripheral.delegate = self.peripheralModel
        
        //ペリフェラルに登録してあるサービスを探す
        //今回いらないはず...
        self.peripheralModel.peripheral.discoverServices(nil)

        self.scanLbl.text = "接続成功しました"
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //コンパス機能を使って方位を変更すると同時にrssiを取得するようにする
        if self.peripheralModel.peripheral != nil{
            self.peripheralModel.peripheral.readRSSI()
        }
    }

}
