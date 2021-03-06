//
//  SortView.swift
//  be-swift
//
//  Created by Isabella Vieira on 08/10/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//
import Foundation
import UIKit

class SortView: View
{
    
    let view = View(frame: CGRect.zero)
    
    var sortTableView: UITableView!
    let sortViewController = SortViewController()
    var codeToSort: Array<String>!
    var correctAnswer: Array<String>!
    var checkButton: UIButton!
    var tryAgainButton:UIButton!
    var checkButtonFrame: CGRect!
    var tableRowHeight: CGFloat! = 47
    
    let widhtiPhoneSE: CGFloat = 320
    let heightiPhoneSE: CGFloat = 568
    let screenSize = UIScreen.main.bounds
    
    var sizeView: CGFloat!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    }
    
        convenience init (titleText: String, checkButtonAction: Selector, questionText: String, exampleCodeText: String?, options: Array<String>, correctAnswer: Array<String>){
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2000))
        
        self.codeToSort = options
        self.correctAnswer = correctAnswer
        
        let question = view.setQuestion(questionText: questionText)
        let code = view.setExampleCode(exampleCodeText: exampleCodeText!, view: self)
        
        setTableView()
        setCheckButton(checkButtonAction: checkButtonAction)
        let height = sizeView!
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        
        self.addSubview(question)
        self.addSubview(code)
    }
    
    func setTableView()
    {
        let xScale = screenSize.width/widhtiPhoneSE
        let yScale = screenSize.height/heightiPhoneSE
        
        let numberOfLines = self.codeToSort.count
        
        let endOfMainView = self.view.question.frame.origin.y + self.view.question.frame.height + 10*yScale
        
        self.sortTableView = UITableView(frame: CGRect(x: 5*xScale, y: endOfMainView, width: 310*xScale, height: self.tableRowHeight * CGFloat(numberOfLines) * yScale))
        self.sortTableView.separatorStyle = .none
        self.sortTableView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        
        self.addSubview(sortTableView)
        
        let sortFeedbackView = SortFeedbackView()
        sortFeedbackView.getTableViewFrame(tableViewFrame: self.sortTableView.frame)
    }
    
    func setCheckButton(checkButtonAction: Selector)
    {
        let xScale = screenSize.width/widhtiPhoneSE
        let yScale = screenSize.height/heightiPhoneSE
        
        self.checkButton = UIButton(image: "check", frame: CGRect(x: 0, y: 0, width: 288, height: 46), target: self)
        self.checkButton.addTarget(target, action: checkButtonAction, for: UIControlEvents.touchUpInside)
        
        let positionTableView = sortTableView.frame.minY + sortTableView.frame.height
        
        print("POSITION TABLEVIEW ",positionTableView)
        print("MINY TABLEVIEW ",sortTableView.frame.minY)
        print("HEIGHT TABLEVIEW ",sortTableView.frame.height)
        
        if positionTableView < 516*yScale{
            checkButton.frame.origin = CGPoint(x: 16*xScale, y: screenSize.height - 140*yScale)
            sizeView = screenSize.height
        } else {
            checkButton.frame.origin = CGPoint(x: 16*xScale, y: positionTableView + 20*yScale)
            sizeView = checkButton.frame.minY + 140*yScale
        }
        checkButtonFrame = checkButton.frame
        self.addSubview(checkButton)
    }
    
    func setTryAgainButton(tryAgainAction: Selector){
        self.tryAgainButton = UIButton(image: "tryAgain", frame: CGRect(x: 0, y: 0, width: 288, height: 46), target: self)
        self.tryAgainButton.frame = checkButtonFrame
        self.checkButton.removeFromSuperview()
        self.addSubview(tryAgainButton)
        self.tryAgainButton.addTarget(target, action: tryAgainAction, for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
