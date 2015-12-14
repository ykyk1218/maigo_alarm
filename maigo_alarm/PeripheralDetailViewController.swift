//
//  PeripheralDetailViewController.swift
//  maigo_alarm
//
//  Created by 小林芳樹 on 2015/12/15.
//  Copyright © 2015年 小林芳樹. All rights reserved.
//

import UIKit
import CoreLocation

class PeripheralDetailViewController: UIViewController, PeripheralModelRSSIDelegate, CLLocationManagerDelegate {
    var peripheralModel: PeripheralModel!
    
    private let lblPeripheralName: UILabel = UILabel()
    private let lblConnectStatus: UILabel = UILabel()
    private let lblRSSI: UILabel = UILabel()
    
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peripheralModel.prRSSIDelegate = self
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        lblPeripheralName.frame = CGRectMake(0,0,200,30)
        lblPeripheralName.center = CGPointMake(self.view.bounds.width/2, navBarHeight!+50)
        lblPeripheralName.text = self.peripheralModel.peripheral.name
        
        lblRSSI.frame  = CGRectMake(0,0,200,30)
        lblRSSI.center = CGPointMake(self.view.bounds.width/2, navBarHeight! + 200)
        lblRSSI.text = "距離が表示される"
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(lblPeripheralName)
        self.view.addSubview(lblRSSI)

        self.locationManager.startUpdatingHeading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralRSSI(didReadRSSI RSSI: NSNumber) {
        
        lblRSSI.text = String(RSSI)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //コンパス機能を使って方位を変更すると同時にrssiを取得するようにする
        if self.peripheralModel.peripheral != nil{
            self.peripheralModel.peripheral.readRSSI()
        }
    }

    
}
