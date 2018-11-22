//
//  EnterSurveyViewController.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/19/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit
import Alamofire
import ACProgressHUD_Swift


class EnterSurveyViewController: UIViewController {
 
    var surveryID : String = ""
    var questionsArray = [Any]()
    @IBOutlet weak var btnBegingSurvey: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnBegingSurvey.layer.cornerRadius = 10.0
        self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: .clear)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func beginSurveyClicked(sender: Any){
        
        self.loadQuestions { (status) in
            if status{
                SurveyManager.shared.surveyViewControllers.removeAll()
                for obj in self.questionsArray{
                    
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionsViewController") as! QuestionsViewController
                    controller.questionObj = obj as! [String : Any]
                    SurveyManager.shared.surveyViewControllers.append(controller)
                }
                if SurveyManager.shared.surveyViewControllers.count > 0{
                    let navController = UINavigationController.init(rootViewController: SurveyManager.shared.surveyViewControllers[0])
                    SurveyManager.shared.currentQuestionIndex = 0
                    navController.isNavigationBarHidden = true
                    self.present(navController, animated: true, completion: nil)
                }
            }
        }

    }
    
    func loadQuestions(completion: @escaping (_ status : Bool)  -> Void) {
        
        ACProgressHUD.shared.showHUD()
        Alamofire.request("\(NFCConstants.API.BASE_URL)survey/api/surveys/\(self.surveryID)").validate(statusCode: 200..<600).responseJSON { response in
            
            ACProgressHUD.shared.hideHUD()
            switch response.result {
            case .success:
                
                if let json = response.result.value as? [String: Any] {
                    print("JSON: \(json)")
                    
                    //self.title =
                    guard let response = json["content"] as? [String: Any] else {
                        return
                    }
                    self.questionsArray = response["questions"] as! [Any]
                    completion(true)
                }
            case .failure(let error):
                completion(false)
                
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
