//
//  ViewController.swift
//  maigo_alarm
//
//  Created by 小林芳樹 on 2015/11/29.
//  Copyright © 2015年 小林芳樹. All rights reserved.
//

import UIKit

class RegistViewController: UIViewController, UITextFieldDelegate {
    
    let stateLbl:UILabel = UILabel()
    let registBtn:UIButton = UIButton()
    let scanLbl: UILabel = UILabel()
    let deviseNameField:UITextField = UITextField()
    let scanNameField:UITextField = UITextField()
    
    let centralManagerModel = CentralManagerModel()
    let peripheralModel = PeripheralModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // オブジェクト配置
        //ラベル設定
        self.stateLbl.text = "端末名"
        self.stateLbl.frame = CGRectMake(0, 0, 200, 30)
        self.stateLbl.numberOfLines = 0
        self.stateLbl.sizeToFit()
        self.stateLbl.center = CGPointMake(self.view.bounds.width/2, 200)
        
        //デバイス名設定用テキストフィールド
        self.deviseNameField.frame = CGRectMake(0,0,200,30)
        self.deviseNameField.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, 230)
        self.deviseNameField.borderStyle = UITextBorderStyle.RoundedRect
        
        //スキャンラベル
        self.scanLbl.text = "スキャン対象名"
        self.scanLbl.frame = CGRectMake(0, 0, 200, 30)
        self.scanLbl.sizeToFit()
        self.scanLbl.center = CGPointMake(self.view.bounds.width/2, 300)
        
        //スキャン対象名設定用テキストフィールド
        self.scanNameField.frame = CGRectMake(0, 0, 200, 30)
        self.scanNameField.center = CGPointMake(self.view.bounds.width/2, 330)
        self.scanNameField.borderStyle = UITextBorderStyle.RoundedRect
        
        //登録ボタン
        self.registBtn.frame = CGRectMake(0,0,200,30)
        self.registBtn.center = CGPointMake(self.view.bounds.width/2, 400)
        self.registBtn.setTitle("登録", forState: .Normal)
        self.registBtn.layer.masksToBounds = true
        self.registBtn.layer.cornerRadius = 10
        self.registBtn.backgroundColor = UIColor.blueColor()
        self.registBtn.addTarget(self, action: "registDeviseName", forControlEvents: .TouchUpInside)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.stateLbl)
        self.view.addSubview(self.deviseNameField)
        self.view.addSubview(self.scanLbl)
        self.view.addSubview(self.scanNameField)
        self.view.addSubview(self.registBtn)
        
        self.deviseNameField.delegate = self
        self.scanNameField.delegate = self
    }
    
    func registDeviseName() {
        //if (self.deviseNameField.text?.characters.count > 0) {
            //ペリフェラルとしての名前を登録
            self.peripheralModel.setAdvertisementDataLocalName(String(self.deviseNameField.text))
            
            //スキャン対象名を登録
            self.peripheralModel.scanName = String(self.scanNameField.text)
            
            self.navigationController?.pushViewController(ScanViewController(), animated: true)
            
        //}else{
        //    print("文字を入力してください")
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //テキストフィールドでリターンを押した時のデリゲートメソッド
        //フォーカスを外して、キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }

}

