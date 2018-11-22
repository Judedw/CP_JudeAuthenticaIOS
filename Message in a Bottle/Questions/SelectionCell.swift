//
//  SelectionCell.swift
//  Message in a Bottle
//
//  Created by Hasitha De Mel on 10/25/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {

    @IBOutlet weak var checkBoxContainer: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    var answrType : String? = nil
    var answrObj : [String : Any]? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(_ answr : [String : Any], _ type : String) {
        
        self.answrType = type
        self.answrObj = answr
        
        let circleBox = Checkbox(frame: self.checkBoxContainer.bounds)
        
        if type == "S" {
            circleBox.borderStyle = .circle
            circleBox.checkmarkStyle = .circle
        }else if type == "M"{
            circleBox.borderStyle = .square
            circleBox.checkmarkStyle = .square
        }
        
        circleBox.borderWidth = 1
        circleBox.uncheckedBorderColor = .lightGray
        circleBox.checkedBorderColor = .gray
        circleBox.checkmarkColor = .gray
        circleBox.checkmarkSize = 0.8
        circleBox.checkmarkColor = .blue
        circleBox.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        checkBoxContainer.addSubview(circleBox)
        //checkBoxContainer.clipsToBounds = true
    }
    
    @objc func checkboxValueChanged(sender: Checkbox) {
        
        if self.answrType == "S" {
            let preAnswer = SurveyManager.shared.preSelectedAnswerRadioButton
            let preAnswrID = SurveyManager.shared.preSelectedRadioAnswerID
            
            if (preAnswer != nil) {
                preAnswer?.isChecked = false
                SurveyManager.shared.preSelectedAnswerRadioButton = sender
                if let index = SurveyManager.shared.tmpAnswerArray.index(of:preAnswrID!) {
                    SurveyManager.shared.tmpAnswerArray.remove(at: index)
                }
            }
            SurveyManager.shared.preSelectedAnswerRadioButton = sender
            SurveyManager.shared.preSelectedRadioAnswerID = self.answrObj?["id"] as? String
            SurveyManager.shared.tmpAnswerArray.append(self.answrObj?["id"] as! String)
            
        }else if self.answrType == "M"{
            
            if sender.isChecked {
                SurveyManager.shared.preSelectedAnswerCheckBoxes.append(sender)
                SurveyManager.shared.tmpAnswerArray.append(self.answrObj?["id"] as! String)
            }else{
                
                if let index = SurveyManager.shared.preSelectedAnswerCheckBoxes.index(of:sender) {
                    SurveyManager.shared.preSelectedAnswerCheckBoxes.remove(at: index)
                }
                
                let answerID = self.answrObj?["id"] as! String
                if let index = SurveyManager.shared.tmpAnswerArray.index(of:answerID) {
                    SurveyManager.shared.tmpAnswerArray.remove(at: index)
                }
            }
            
        }
        
        
        print("checkbox value change: \(sender.isChecked)")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
