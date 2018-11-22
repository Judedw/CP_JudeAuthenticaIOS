//
//  ViewController.swift
//  Message in a Bottle
//
//  Created by Charles Truluck on 6/19/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import CoreNFC
import Alamofire
import ACProgressHUD_Swift
import AlamofireObjectMapper
import ObjectMapper

class ScanViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    
    
    var nfcSession: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: .clear)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scanPressed(_ sender: Any) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            ACProgressHUD.shared.showHUD()
        }
        
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        result = "8f9dbf0e7e5441df857c1b14625aaabdf4a66c60f36ca8dba1425af080030492c343e368c0572aaceb78b950f716078602008a2f1933c37f0b4094f56fafc150231ac59a1bec"
//        https://productzg4t4ks63a.hana.ondemand.com/product/api/authenticate?authCode=%7BauthCode%7D
        let urlString = "\(NFCConstants.API.BASE_URL)product/api/authenticate?authCode=\(result)"

        ACProgressHUD.shared.showHUD()
        Alamofire.request(urlString).validate(statusCode: 200..<600).responseJSON { response in
        
            DispatchQueue.main.async {
                ACProgressHUD.shared.hideHUD()
            }
            switch response.result {
            case .success:
                
                if let json = response.result.value as? [String: Any] {
                    print("JSON: \(json)")
                    guard let response = json["content"] as? [String: Any] else {
                        return
                    }
                    let title = response["title"] as? String
                    if title == "Sorry;"{
                        
                        let alert = UIAlertController(title: "Sorry", message: "Your authentication code is invalid", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                       return
                    }
                    
                    self.goToScanResultController(response)
                }
            case .failure( _): break
            
            }
        }
        
        }

    
    
    func goToScanResultController(_ respone : [String : Any]) {
        
        SurveyManager.shared.surveyID = respone["serverId"] as? String
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanResponseViewController") as! ScanResponseViewController
        controller.scanResponse = respone
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

