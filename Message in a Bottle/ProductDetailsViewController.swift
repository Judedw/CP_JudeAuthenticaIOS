//
//  ProductDetailsViewController.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/19/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit
import Alamofire
import ACProgressHUD_Swift
import Kingfisher

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var imageviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageScrollview: UIScrollView!
    
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var lblProductCode: UILabel!
    @IBOutlet weak var lblProductDesc: UILabel!
    @IBOutlet weak var lblBatchNo: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    //var productDictionary : [String:Any] = [:]
    var productID : String = ""
    var imageHeightArray = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: .clear)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.descTextView.translatesAutoresizingMaskIntoConstraints = false
        self.descTextView.isScrollEnabled = false
        self.descTextView.isEditable = false
        self.descTextView.dataDetectorTypes = .all
        
        self.btnDone.layer.cornerRadius =  10.0
        
        ACProgressHUD.shared.showHUD()
        Alamofire.request("\(NFCConstants.API.BASE_URL)product/api/products/\(productID)").validate(statusCode: 200..<600).responseJSON { response in
            
            ACProgressHUD.shared.hideHUD()
            switch response.result {
            case .success:
                
                if let json = response.result.value as? [String: Any] {
                    print("JSON: \(json)")
                    
                    //self.title =
                    guard let response = json["content"] as? [String: Any] else {
                        return
                    }
                    self.title = response["name"] as? String
                    self.lblProductCode.text = response["code"] as? String
                    //self.lblProductDesc.text = response["description"] as? String
                    self.descTextView.text = response["description"] as? String
                    let fixedWidth = self.descTextView.frame.size.width
                    self.descTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                    let newSize = self.descTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
                    var newFrame = self.descTextView.frame
                    newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                    self.descTextView.frame = newFrame;
                    
                    self.lblBatchNo.text = "\(String(describing: response["batchNumber"] as! NSNumber))"
                    self.lblExpiryDate.text = response["expireDate"] as? String
                    
                    let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
                    dispatchQueue.async{
                        self.setImages(response["imageObjects"] as! [[String : String]])
                    }
                    
                }
            case .failure( _): break
                
                
            }
        }
        
    }
    
    func setImages(_ imagesArr : [[String : String]]){
        
        var position : CGFloat = 0.0
        self.imageHeightArray.removeAll()
        
        for dic in imagesArr{

            let imageID = dic["id"]
            let url = URL(string: "\(NFCConstants.API.BASE_URL)product/downloadFile/\(imageID ?? "")")
            DispatchQueue.main.async {
                let xValuw = position * self.view.frame.width
                let headerImageView = UIImageView(frame: CGRect(x: xValuw , y: 0, width: self.view.frame.width, height: 0))
                
                headerImageView.contentMode = .scaleAspectFit
                self.imageScrollview.addSubview(headerImageView)
                
                headerImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                    
                    let ratio = CGFloat(image!.size.width) / CGFloat(image!.size.height)
                    let newHeight = headerImageView.frame.width / ratio
                    self.imageviewHeightConstraint.constant = newHeight
                    self.view.layoutIfNeeded()
                    self.imageHeightArray.append(newHeight)
                    var rect  = headerImageView.frame
                    rect.size.height = newHeight
                    headerImageView.frame = rect
                    
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + newHeight)
                }
                
                position += 1
                
                self.imageScrollview.isPagingEnabled = true
                self.imageScrollview.contentSize = CGSize(width: position * self.view.frame.width, height: 0)
                
                
            }
            
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: .clear)
    }
    
    @IBAction func doneClicked(_sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//extension ProductDetailsViewController : UIScrollViewDelegate{
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.tag == 1000 {
//
//            let x = scrollView.contentOffset.x
//            let w = scrollView.bounds.size.width
//            let currentIndex = Int(x/w)
//            self.imageScrollview.contentSize = CGSize(width: CGFloat(self.imageHeightArray.count) * self.view.frame.width, height: self.imageHeightArray[currentIndex])
//            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + self.imageHeightArray[currentIndex])
//        }
//    }
//
//}
