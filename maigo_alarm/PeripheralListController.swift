//
//  PeripheralListController.swift
//  maigo_alarm
//
//  Created by 小林芳樹 on 2015/12/06.
//  Copyright © 2015年 小林芳樹. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralListController: UIViewController, CentralManagerModelDelegate, UITableViewDelegate, UITableViewDataSource, PeripheralModelDelegate {
    private var peripheralList:[Dictionary<String,NSObject>] = []
    
    private let centralManagerModel = CentralManagerModel()
    private let peripheralModel = PeripheralModel()
    
    private let table: UITableViewController = UITableViewController()
    private let advertiseBtn: UIButton = UIButton()
    
    private let peripheralDetailView = PeripheralDetailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        self.advertiseBtn.frame = CGRectMake(0,0,200,30)
        self.advertiseBtn.center = CGPointMake(self.view.bounds.width/2, navBarHeight! + 50)
        self.advertiseBtn.setTitle("アドバタイズを開始する", forState: .Normal)
        self.advertiseBtn.addTarget(self.peripheralModel, action: "advertising", forControlEvents: .TouchUpInside)
        self.advertiseBtn.backgroundColor = UIColor.blueColor()
        
        self.table.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        //self.table.view.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height)
        self.table.view.frame = CGRectMake(0, navBarHeight! + 100, self.view.bounds.width, self.view.bounds.height)
        self.table.tableView.delegate = self
        self.table.tableView.dataSource = self
                
        self.view.backgroundColor = UIColor.whiteColor()

        self.view.addSubview(table.view)
        self.view.addSubview(advertiseBtn)
        
        self.centralManagerModel.cmModelDelegate = self
        self.peripheralModel.prModelDelegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //周辺デバイスを発見
    func centralManagerModelDiscoverPeripheral(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral) {
        if peripheral.name != nil {
            self.peripheralModel.peripheral = peripheral
            let data = ["name": peripheral.name!, "peripheral":self.peripheralModel.peripheral]
            
            //ペリフェラルの重複を防ぐ
            for(var i=0; i<self.peripheralList.count; i++) {
                if self.peripheralList[i]["name"] == data["name"] {
                    return;
                }
            }
            self.peripheralList.append(data)
        
            dispatch_async(dispatch_get_main_queue(), {
                self.table.tableView.reloadData()
                self.table.refreshControl?.endRefreshing()
            })
        }
    }
    
    func centralManagerModelDidConnectPeripheral(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("接続を開始した時に呼ばれるデリゲートメソッド \(peripheral))")
        self.peripheralModel.peripheral = peripheral
        self.peripheralDetailView.peripheralModel = self.peripheralModel
        self.peripheralDetailView.peripheralModel.peripheral = self.peripheralModel.peripheral
        self.navigationController?.pushViewController(self.peripheralDetailView, animated: true)
     
    }
    
    func peripheralModelManagerDidStartAdvertising(peripheral: CBPeripheralManager) {
        print("アドバタイズ開始時のデリゲートメソッド")
        self.advertiseBtn.setTitle("アドバイズを停止する", forState: .Normal)
        self.advertiseBtn.addTarget(self.peripheralModel, action: "stopAdvertising", forControlEvents: .TouchUpInside)
        self.advertiseBtn.backgroundColor = UIColor.redColor()
    }
    
    func peripheralModelManagerDidStopAdvertising(peripheral: CBPeripheralManager) {
        print("アドバタイズ停止時のデリゲートメソッド")
        self.advertiseBtn.setTitle("アドバタイズを開始する", forState: .Normal)
        self.advertiseBtn.addTarget(self.peripheralModel, action: "advertiging", forControlEvents: .TouchUpInside)
        self.advertiseBtn.backgroundColor = UIColor.blueColor()
    }
    
    /* Cellが選択された際に呼び出されるデリゲートメソッド. */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //接続を開始する
        self.centralManagerModel.startConnect((self.peripheralList[indexPath.row]["peripheral"] as? CBPeripheral)!)
        
    }
    
    /* Cellの総数を返すデータソースメソッド. (実装必須)
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralList.count
    }
    
    /* Cellに値を設定するデータソースメソッド. (実装必須) */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell { // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) // Cellに値を設定する.
        cell.textLabel!.text = self.peripheralList[indexPath.row]["name"] as? String
        return cell
    }
    
}
