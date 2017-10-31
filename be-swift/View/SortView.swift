//
//  SortView.swift
//  be-swift
//
//  Created by Isabella Vieira on 08/10/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//

import Foundation
import UIKit

class SortView: View {
    
    var view = View(frame: CGRect.zero)
    
    var sortTableView: UITableView!
    var background: UIImageView!
    var sortViewController = SortViewController()
    var codeToSort: Array<String>!
    var correctAnswer: Array<String>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)

    }
    
    convenience init (frame: CGRect, titleText: String, dismissButtonAction: Selector, helpButtonAction: Selector, questionText: String, exampleCodeText: String?, options: Array<String>, correctAnswer: Array<String>)
    {
        self.init(frame: frame)
        
        self.codeToSort = options
        self.correctAnswer = correctAnswer
        
        let rectangle = view.setTopBar()
        let title = view.setTitle(title: titleText)
        let dismissButton = view.setdismissButton(dismissButtonAction: dismissButtonAction)
        let helpButton = view.setHelpButton(helpButtonAction: helpButtonAction)
        let question = view.setQuestion(questionText: questionText)
        let code = view.setExempleCode(exampleCodeText: exampleCodeText!, view: self)
        
        self.layer.addSublayer(rectangle)
        self.addSubview(title)
        self.addSubview(dismissButton)
        self.addSubview(helpButton)
        self.addSubview(question)
        self.addSubview(code)
        
        let tableView = self.setTableView()

    }
    
    func setTableView()
    {
        var numberOfLines = self.codeToSort.count
        
        var endOfMainView = self.view.question.frame.origin.y + self.view.frame.height + 25
        
        self.sortTableView = UITableView(frame: CGRect(x: 5, y: endOfMainView, width: 310, height: 44 * CGFloat(numberOfLines)))
        self.sortTableView.separatorStyle = .none
        self.sortTableView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        
        self.addSubview(sortTableView)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
