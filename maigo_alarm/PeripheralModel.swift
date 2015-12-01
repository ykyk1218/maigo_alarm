//
//  PeripheralModel.swift
//  maigo_alarm
//
//  Created by 小林芳樹 on 2015/11/29.
//  Copyright © 2015年 小林芳樹. All rights reserved.
//

import UIKit
import CoreBluetooth
import AudioToolbox

class PeripheralModel: NSObject, CBPeripheralManagerDelegate, CBPeripheralDelegate {
    
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!// = CBPeripheralManager(delegate: nil, queue: nil, options: nil)
    var advertisementData: Dictionary = [CBAdvertisementDataLocalNameKey: "iPod touch"]
    var scanName = "iPod touch"
    
    let serviceUUID = CBUUID(string: NSUUID().UUIDString)
    let service: CBMutableService!
    
    let characteristicUUID = CBUUID(string: NSUUID().UUIDString)
    let properties: CBCharacteristicProperties!
    let permissions: CBAttributePermissions!
    
    let characteristic: CBMutableCharacteristic!
    
    var isAdvertising = false
    
    override init() {

        //self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        //キャラクタリスティックの作成
        properties = [CBCharacteristicProperties.Notify,
            CBCharacteristicProperties.Read,
            CBCharacteristicProperties.Write]
        permissions = [CBAttributePermissions.Readable,
            CBAttributePermissions.Writeable]
        
        self.characteristic = CBMutableCharacteristic(type: self.characteristicUUID, properties: properties, value: nil, permissions: permissions)
        
        //サービスの作成
        self.service = CBMutableService(type: self.serviceUUID, primary: true)
        
        //サービスのキャラクタリスティックを追加
        self.service.characteristics = [self.characteristic]
        
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func advertising() {
//        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        print("アドバタイズ開始")
        
        let enumName = "CBPeripheralManagerState"
        var valueName = ""
        switch self.peripheralManager.state {
        case .PoweredOff:
            valueName = enumName + "PoweredOff"
        case .PoweredOn:
            valueName = enumName + "PoweredOn"
        case .Resetting:
            valueName = enumName + "Resetting"
        case .Unauthorized:
            valueName = enumName + "Unauthorized"
        case .Unknown:
            valueName = enumName + "Unknown"
        case .Unsupported:
            valueName = enumName + "Unsupported"
        }
        print(valueName)
        if (self.peripheralManager.isAdvertising == false) {
            //ペリフェラルにサービスを追加
            self.peripheralManager.addService(service)
            self.peripheralManager.startAdvertising(self.advertisementData)
        }
    }
    
    func setAdvertisementDataLocalName(localName: String) {
        self.advertisementData = [CBAdvertisementDataLocalNameKey: localName]

    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        print(error)
        print("アドバタイズ開始のデリゲートメソッド")
    }
    
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
    }
    
    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        print("RSSI: " + String(RSSI))
        if Int(RSSI) < -50 {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
}
