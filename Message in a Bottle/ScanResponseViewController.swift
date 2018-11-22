//
//  ScanResponseViewController.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/19/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class ScanResponseViewController: UIViewController {

    var scanResponse : [String : Any] = [:]
    @IBOutlet weak var btnProductDetails: UIButton!
    @IBOutlet weak var btnSurvey: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: .clear)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnProductDetails.layer.cornerRadius = 10.0
        self.btnProductDetails.layer.borderWidth = 1.0
        
        self.btnSurvey.layer.cornerRadius = 10.0
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToProductDetails(sender: Any){
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        //controller.productDictionary = [String : Any]
        controller.productID = scanResponse["productId"] as! String//"9d0fe08395fbd9add6cfb1b66505fbf9"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func startSurvey(sender: Any){
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterSurveyViewController") as! EnterSurveyViewController
        controller.surveryID = scanResponse["serverId"] as! String//"faa6643aca8c5318a9583178795542cf"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
