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
    
    //let serviceUUID = CBUUID(string: NSUUID().UUIDString)
    let serviceUUID = CBUUID(string: "0000")
    let service: CBMutableService!
    
    //let characteristicUUID = CBUUID(string: NSUUID().UUIDString)
    let characteristicUUID = CBUUID(string: "0001")
    let properties: CBCharacteristicProperties!
    let permissions: CBAttributePermissions!
    
    let characteristic: CBMutableCharacteristic!
    
    var isAdvertising = false
    
    override init() {

        //self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        //キャラクタリスティックの作成
        /*
        properties = [CBCharacteristicProperties.Notify,
            CBCharacteristicProperties.Read,
            CBCharacteristicProperties.Write]
        */
        properties = [CBCharacteristicProperties.Read]
        //permissions = [CBAttributePermissions.Readable, CBAttributePermissions.Writeable]
        permissions = [CBAttributePermissions.Readable]
        
        self.characteristic = CBMutableCharacteristic(type: self.characteristicUUID, properties: CBCharacteristicProperties.Read, value: nil, permissions: CBAttributePermissions.Readable)
        
        //サービスの作成
        self.service = CBMutableService(type: self.serviceUUID, primary: true)
        
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        //サービスのキャラクタリスティックを追加
        self.service.characteristics = [self.characteristic]
        
        

    }
    
    func advertising() {
//        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        print("アドバタイズ開始")
        
        
        if (self.peripheralManager.isAdvertising == false) {
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
        let enumName = "CBPeripheralManagerState"
        var valueName = ""
        switch self.peripheralManager.state {
        case .PoweredOff:
            valueName = enumName + "PoweredOff"
        case .PoweredOn:
            valueName = enumName + "PoweredOn"
            
            //このタイミングでペリフェラルにサービスを追加するようにしないと失敗する
            self.peripheralManager.addService(self.service)
            
            
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
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        let services: NSArray = peripheral.services!
        print("サービス発見！\(services)")
        
        for obj in services {
            if let service = obj as? CBService {
                //キャラクタリスティック探索開始
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        let characteristics: NSArray = service.characteristics!
        for obj in characteristics {
            if let characteristic = obj as? CBCharacteristic {
                print(characteristic)
                
                if characteristic.properties == CBCharacteristicProperties.Read {
                    print("呼び出し専用:\(characteristic)")
                    peripheral.readValueForCharacteristic(characteristic)
                }
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: NSError?) {
        print("RSSI: " + String(RSSI))
        if Int(RSSI) < -50 {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        if (error != nil) {
            print("サービスの追加失敗 \(error)")
            return
        }
        print("サービスの追加が成功")
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        print("セントラルからの呼び出し")

    }
}
