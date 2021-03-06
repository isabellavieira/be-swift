//
//  BlankFieldViewController.swift
//  be-swift
//
//  Created by Mariana Meireles on 25/10/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//

import Foundation
import UIKit

class BlankFieldViewController: UIViewController, UITextFieldDelegate {
    
    var blankField: BlankFieldView!
    var topView: TopView!
    var scrollView: UIScrollView!
    var challenge: Challenge!
    var answerIsRight: Bool!
    var userAnswer: String!
    var correctAnswer: String!
    var numberOfTries = 0
    var textFieldInput: String!
    var userDAO: UserDAO!

    
    let progressView = UIProgressView(progressViewStyle: .bar)
    var time = 0.0
    var timer = Timer()
    
    var numberOfStars: Int!
    var timeSolved: Double!
    var timeTo2Stars: Double! = nil
    var timeTo3Stars: Double! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.correctAnswer = self.challenge.correctAnswer[0] as! String
        
        topView = TopView(titleText: self.challenge.tags[0] as! String, dismissButtonAction: #selector(BlankFieldViewController.dismissButton(_:)), helpButtonAction: #selector(BlankFieldViewController.helpButton(_:)))
        self.view.addSubview(topView)
        
        blankField = BlankFieldView(dismissButtonAction: #selector(BlankFieldViewController.dismissButton(_:)), helpButtonAction: #selector(BlankFieldViewController.helpButton(_:)), questionText: self.challenge.question, exampleCodeText: self.challenge.exampleCode, checkButtonAction:#selector(BlankFieldViewController.checkButton(_:)), currentView: self)
        
        let yPosition = topView.yPosition
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: yPosition!, width: self.view.frame.size.width, height: self.view.frame.size.height))
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: blankField.frame.height)
        
        self.view.addSubview(topView)
        self.view.addSubview(scrollView)
        scrollView.addSubview(blankField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(startTime), userInfo: nil, repeats: true)
        
        //Set time required to get x stars
        self.timeTo3Stars = self.challenge.estimatedTime
        self.timeTo2Stars = timeTo3Stars*2
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: TimeInterval(self.challenge.estimatedTime), animations: { () -> Void in
            self.progressView.setProgress(0.0, animated: true)
        })
    }
    
    @objc func startTime(){
        time += 0.2
    }
    
    @objc func dismissButton(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func helpButton(_ sender: Any){
        let webView = WebDocumentationViewController()
        webView.url = URL(string: self.challenge.resource_link)!
        present(webView, animated: false, completion: nil)
    }
    
    @objc func checkButton(_ sender: Any){
        self.blankField.blankField.isUserInteractionEnabled = false

        if textFieldInput == nil{
            let alert = UIAlertController(title: "Ops!", message: "Complete the blank field", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.blankField.blankField.isUserInteractionEnabled = true
        }else{

            timer.invalidate()
            print("TIME", time)
            self.timeSolved = time
            time = 0.0
            
            self.userAnswer = textFieldInput
            
            if userAnswer.lowercased() == self.correctAnswer.lowercased() {
                print("CORRECT ANSWER")
                
                self.answerIsRight = true
                
                //Definir número de estrelas de acordo com o tempo
                if timeSolved <= timeTo3Stars {
                    self.numberOfStars = 3
                } else if timeSolved <= timeTo2Stars && timeSolved > timeTo3Stars {
                    self.numberOfStars = 2
                } else {
                    self.numberOfStars = 1
                }
                
                showFeedback()
            }else{
                print("WRONG ANSWER")
                
                self.answerIsRight = false
                self.numberOfTries += 1
                print("TRIES: ", numberOfTries)
                
                if self.numberOfTries < 2 {
                    UIView.animate(withDuration: TimeInterval(0), animations: { () -> Void in
                        self.progressView.setProgress(1.0, animated: true)
                    })
                    self.blankField.setTryAgainButton(tryAgainAction: #selector(setNextTry))
                
                }else{
                    self.numberOfStars = 0
                    showFeedback()
                }
            }
        }
    }
    
    func showFeedback(){
        self.numberOfTries = 0
        
        let feedbackController = MultipleChoiceFeedbackViewController()
        feedbackController.getVariables(challenge: self.challenge, userAnswer: self.userAnswer, correctAnswer: self.correctAnswer, answerIsRight: self.answerIsRight, numberOfStars: self.numberOfStars, timeSolved: self.timeSolved)
        
//        print (">> SORT FEEDBACK VIEW\n")
//        print (">> Usuario: \(String(describing: User.sharedInstance.email))")
//        print (">> challenge ID: \(self.challenge.id)")
//        print (">> stars: \(self.numberOfStars)")
//        print (">> timeSolved: \(self.timeSolved)")
//        
//        if (User.sharedInstance.email != nil) && (self.numberOfStars != nil) && (self.timeSolved != nil) {
//            userDAO.saveChallengeData(email: String(describing: User.sharedInstance.email), challenge_id: self.challenge.id, stars: self.numberOfStars, time: self.timeSolved)
//            print ("Salvou no banco")
//        } else {
//            print ("Nao salvou no banco")
//        }
        
        present(feedbackController, animated: false, completion: nil)
    }
    
    @objc func setNextTry(){
        
        UIView.animate(withDuration: TimeInterval(self.challenge.estimatedTime), animations: { () -> Void in
            self.progressView.setProgress(0.0, animated: true)
        })
        
        //change buttons
        self.blankField.tryAgainButton.removeFromSuperview()
        self.blankField.addSubview(self.blankField.checkButton)

        //erase previous answer and let user edit blank field
        self.blankField.blankField.text = ""
        self.blankField.blankField.isUserInteractionEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(startTime), userInfo: nil, repeats: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        let heightiPhoneSE: CGFloat = 568
        let screenSize = UIScreen.main.bounds
        let yScale = screenSize.height/heightiPhoneSE
        if textField.frame.minY + textField.frame.height > self.view.frame.height/2{
            scrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.minY - 250*yScale), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - self.view.frame.height), animated: true)
        if !(textField.text?.isEmpty)!{
            textFieldInput = textField.text
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

