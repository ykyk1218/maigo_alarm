//
//  CentralManagerModel.swift
//  maigo_alarm
//
//  Created by 小林芳樹 on 2015/11/29.
//  Copyright © 2015年 小林芳樹. All rights reserved.
//

import UIKit
import CoreBluetooth


@objc protocol CentralManagerModelDelegate:NSObjectProtocol {
    //スキャン結果を返すデリゲート
    func centralManagerModelDiscoverPeripheral(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral)
    func centralManagerModelDidConnectPeripheral(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral)
}

class CentralManagerModel: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    //let peripheralModel = PeripheralModel()
    
    var cmModelDelegate: CentralManagerModelDelegate?
    
    override init() {
        super.init()

        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startConnect(peripheral: CBPeripheral) {
        //接続を開始する
        self.centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        //CentralManagerの状態変化を取得
        print("state: \(central.state)")
        
        switch (central.state) {
        case CBCentralManagerState.PoweredOn:
            self.centralManager = central
            self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
        default:
            break
            
        }
        
    }
    
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        //周辺デバイスが見つかると呼ばれる
        print("発見したBLEデバイス： \(peripheral)")
        //self.peripheralModel.peripheral = peripheral
        self.cmModelDelegate?.centralManagerModelDiscoverPeripheral(central, didDiscoverPeripheral: peripheral)
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("接続成功")
        //参照を保持するためにstrongプロパティにセットする
        //そうしないと勝手に解放されて接続が切れる
        //self.peripheralModel.peripheral = peripheral
        self.cmModelDelegate?.centralManagerModelDidConnectPeripheral(central, didConnectPeripheral: peripheral)
    }
    
    /*
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        //周辺デバイスに接続したときに呼ばれる
        print("接続成功！")
        self.stateLbl.text = "接続成功"
        
        //参照を保持するためにstrongプロパティにセットする
        //そうしないと勝手に解放されて接続が切れる
        self.peripheral = peripheral
        
        self.peripheral.delegate = self
        self.peripheral.readRSSI()
        self.peripheral.discoverServices(nil)
        
        self.connectBtn.addTarget(self, action: "killConnect", forControlEvents: .TouchUpInside)
        self.connectBtn.setTitle("接続を切る", forState: UIControlState.Normal)
    }
    */
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        //接続が失敗した時に呼ばれる
        print("接続失敗")
    }
    
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        //接続が切れた時に呼ばれる
        print("接続が切れました")
        print(error)
        
        //self.connectBtn.setTitle("接続する", forState: UIControlState.Normal)
        //self.connectBtn.addTarget(self, action: "startConnect", forControlEvents: .TouchUpInside)
    }
}
