//
//  SurveyManager.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/24/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class SurveyManager: NSObject {
    
    static let shared = SurveyManager()
    var currentQuestionIndex : Int = 0
    var surveyID : String? = nil
    var surveyAnswers =  [[String : Any]]()
    var surveyViewControllers = [QuestionsViewController]()
    
    var tmpAnswerArray = [String]()
    var preSelectedAnswerRadioButton : Checkbox? = nil
    var preSelectedRadioAnswerID : String? = nil
    
    var preSelectedAnswerCheckBoxes = [Checkbox]()
    
    private override init() {
        
    }
    
}
