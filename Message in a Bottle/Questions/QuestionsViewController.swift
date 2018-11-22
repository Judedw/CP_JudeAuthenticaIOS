//
//  QuestionsViewController.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/22/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit
import Alamofire
import ACProgressHUD_Swift

class QuestionsViewController: UIViewController {

    let kCellIdentifierSelectionCell = "SelectionCell"
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblQuestionNo: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var answrContainerView: UIView!
    @IBOutlet weak var txtViewContainer: UIView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var answrTableView: UITableView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    var questionObj : [String:Any] = [:]
    
    var answrType : String? = nil
    var answrsArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibs()
        
        self.btnNext.layer.cornerRadius = 10
        self.btnCancel.layer.cornerRadius = 10
        
        let nextIndex = SurveyManager.shared.currentQuestionIndex + 1
        if nextIndex == SurveyManager.shared.surveyViewControllers.count{
            self.btnNext.setTitle("Done", for: .normal)
        }
        self.lblQuestion.text = questionObj["name"] as? String
        self.lblQuestionNo.text = "\(SurveyManager.shared.currentQuestionIndex) of \(SurveyManager.shared.surveyViewControllers.count)"
        self.loadAnswers { (status, type) in
            if status{
                self.answrType = type
                self.answrTableView.reloadData()
                
                if type == "F" {
                    self.txtViewContainer.frame = self.answrContainerView.bounds
                    self.answrContainerView.addSubview(self.txtViewContainer)
                    self.containerViewHeight.constant = 100.0
                }else{
                    self.answrTableView.frame = self.answrContainerView.bounds
                    self.answrContainerView.addSubview(self.answrTableView)
                    self.containerViewHeight.constant = 300.0
                }
            }
        }
    }

    
    func loadAnswers(completion: @escaping (_ status : Bool, _ type : String )  -> Void) {
        
        let answerObj = questionObj["answerTemplate"] as! [String : Any]
        let answrID = answerObj["id"] as! String
        
        ACProgressHUD.shared.showHUD()
        Alamofire.request("\(NFCConstants.API.BASE_URL)survey/api/answer-templates/\(answrID)").validate(statusCode: 200..<600).responseJSON { response in
            
            ACProgressHUD.shared.hideHUD()
            switch response.result {
            case .success:
                
                if let json = response.result.value as? [String: Any] {
                    print("JSON: \(json)")
                    
                    //self.title =
                    guard let response = json["content"] as? [String: Any] else {
                        return
                    }
                    self.answrsArray = response["answers"] as! [Any]
                    completion(true, response["answerTemplateType"] as! String)
                }
            case .failure(_):
                completion(false, "")
                
            }
        }
        
    }
    
    
    @IBAction func nextClicked(_ sender: Any) {
        
        let nextIndex = SurveyManager.shared.currentQuestionIndex + 1
        
        if nextIndex < SurveyManager.shared.surveyViewControllers.count {
            SurveyManager.shared.currentQuestionIndex = nextIndex
            
            self.addAnswrsToArray()
            
            self.navigationController?
                .pushViewController(SurveyManager.shared.surveyViewControllers[nextIndex], animated: true)
        }else{
      
            self.addAnswrsToArray()
            let arry = SurveyManager.shared.surveyAnswers
            var dic : [String : Any] = ["questions" : arry]
            dic["surveyId"] = SurveyManager.shared.surveyID
            
            self.sendAnswersToTheServer(dic)
            //let dictionary = ["aKey": "aValue", "anotherKey": "anotherValue"]
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: dic,
                options: .prettyPrinted
                ),
                let theJSONText = String(data: theJSONData,
                                         encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
            }
        
            //print("add")
        }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func addAnswrsToArray(){
        
        if answrType == "F"{
            var params:[String : Any] = [String : Any]()
            params["id"] = questionObj["id"]
            params["freeText"] = self.txtView.text
            SurveyManager.shared.surveyAnswers.append(params)
            
        }else{
            
            var params:[String : Any] = [String : Any]()
            params["id"] = questionObj["id"]
            
            var answrArray = [[String : Any]]()
            for answrID in SurveyManager.shared.tmpAnswerArray {
                
                var tmpAnswers:[String : Any] = [String : Any]()
                tmpAnswers["id"] = answrID
                answrArray.append(tmpAnswers)
            }
            params["answers"] = answrArray
            
            SurveyManager.shared.surveyAnswers.append(params)
            SurveyManager.shared.preSelectedAnswerRadioButton = nil
            SurveyManager.shared.preSelectedRadioAnswerID = nil
            SurveyManager.shared.tmpAnswerArray.removeAll()
            
        }
    }
    
    
    func sendAnswersToTheServer(_ params : [String : Any]){
        
        ACProgressHUD.shared.showHUD()
        let urlString = "\(NFCConstants.API.BASE_URL)survey/api/survey/questions/answers"
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Content-Type"] = "application/json"
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            ACProgressHUD.shared.hideHUD()
            switch response.result {
            case .success:
                print(response)
                self.dismiss(animated: true, completion: nil)
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
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

extension QuestionsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func registerNibs() {
        
        let adCellNib = UINib(nibName: kCellIdentifierSelectionCell, bundle: nil)
        self.answrTableView.register(adCellNib, forCellReuseIdentifier: kCellIdentifierSelectionCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answrsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SelectionCell = self.answrTableView.dequeueReusableCell(withIdentifier: kCellIdentifierSelectionCell, for: indexPath) as! SelectionCell
        let answrObj : [String : Any] = self.answrsArray[indexPath.row] as! [String : Any]
        cell.answerLabel.text = answrObj["lable"] as? String
        cell.setupCell(answrObj, answrType!)
        cell.selectionStyle = .none
        return cell
    }
}

extension QuestionsViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1 && resultRange != nil {
            textView.resignFirstResponder()
            // Do any additional stuff here
            return false
        }
        return true
    }
    
}

