//
//  ViewController.swift
//  be-swift
//
//  Created by Isabella Vieira on 08/10/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var inicialView: View!
    var blankField: BlankFieldView!
    var multipleChoice: MultipleChoiceView!
    var multipleChoiceController: MultipleChoiceController!
    var sortView: SortView!
    var sortController: SortViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        inicialView = View(frame: CGRect.zero, titleText: "Constants", dismissButtonAction: #selector(ViewController.dismissButton(_:)), helpButtonAction: #selector(ViewController.helpButton(_:)), questionText: "Once this code is executed, how \nmany items will numbers contain? \nmany items will numbers contain?", haveExampleCode: true, exampleCodeText: "if (age>60 || age<10) { \nvalue = price - (price * \ndiscount) \n} else { \nvalue = price \n} \nreturn value")
        
//        blankField = BlankFieldView(frame: CGRect.zero, questionText: "Once this code is executed, how \nmany items will numbers contain?")
        
        var screenHeight = UIScreen.main.bounds.height
        
        
        //TODO: AJUSTAR FRAMES
        sortView = SortView(frame: CGRect(x: 0, y: 64, width: 321, height: screenHeight - 64 ))
        
//        multipleChoice = MultipleChoiceView(frame: CGRect(x: 0, y: 315, width: 321, height: 300 ))
        
//        self.view.addSubview(blankField)
//        self.view.addSubview(inicialView)
//        self.view.addSubview(sortView)
//        self.view.addSubview(multipleChoice)

        }
    
    override func viewDidAppear(_ animated: Bool) {
        let controller = MultipleChoiceController()
        present(controller, animated: false, completion: nil)
    }

    @objc func dismissButton(_ sender: Any){
        //mandar para a home
    }
    
    @objc func helpButton(_ sender: Any){
        //mandar para doc apple
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

