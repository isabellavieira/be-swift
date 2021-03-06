//
//  ViewController.swift
//  be-swift
//
//  Created by Isabella Vieira on 08/10/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol LevelHandler {
    func getLevelData (level: Level, challengesView: CollectionChallengeView)
    func getUserChallengeInfo(userChallengeInfo: [UserChallengeInfo])
}

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, LevelHandler {
    
    var challengesView: CollectionChallengeView!
    var userChallengeInfo: [UserChallengeInfo] = []
    var arrayChallenges = [Challenge]()
    var user: User!
    var cellMenu: [UICollectionViewCell] = []
    var challengeData: [Challenge] = []
    var totalStarsUser: Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("VIEW CONTROLLLER")
        
        let userID : String = (Auth.auth().currentUser?.email)!
        let uid : String = (Auth.auth().currentUser?.uid)!
        
        print ("UID: \(uid)")
        let userDAO = UserDAO()
        userDAO.getChallengeInfoByUser(handler: self, email: userID as String!)
        
        self.challengesView = CollectionChallengeView(numberOfStarsTotal: setStarsNumber(numberOfStarsTotal: self.totalStarsUser!))
        self.view.addSubview(challengesView)
        self.view = self.challengesView
       
        let levelDAO = LevelDAO()
        
        print ("GET CHALLENGES BY LEVEL - VIEW CONTROLLER")
        levelDAO.getChallengesByLevel(handler: self, level: "level-1", challengesView: challengesView)
        
        self.challengesView.collectionChallenges1.dataSource = self
        self.challengesView.collectionChallenges1.delegate = self
        self.challengesView.collectionChallenges1.register(CollectionChallengesCell.self, forCellWithReuseIdentifier: "cell")
        
//        DispatchQueue.main.async {
//            self.challengesView.collectionChallenges1.reloadData()
//        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //challengesView.collectionChallenges1.reloadData()
//        DispatchQueue.main.async {
//            self.challengesView.collectionChallenges1.reloadData()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //challengesView.collectionChallenges1.reloadData()
//        DispatchQueue.main.async {
//            self.challengesView.collectionChallenges1.reloadData()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.challengeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = challengesView.collectionChallenges1.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionChallengesCell
         let isLocked = false
        
        print (">> USER CHALLENGE INFO: \(userChallengeInfo)")
        
        if (!self.challengeData.isEmpty) && (self.userChallengeInfo.count != 0) {
            let challenge = self.challengeData[indexPath.row]
            let object = self.userChallengeInfo.filter({Int($0.idChallenge) == challenge.id}).first
        
            if (object != nil) {
                cell.configureCell(numberOfStars: (object?.starChallenge)!, isLocked: isLocked, iconNumber: challenge.id)
                self.totalStarsUser = self.totalStarsUser! + (object?.starChallenge)!
                print ("TOTAL STARS: \(self.totalStarsUser)")
                self.cellMenu.append(cell)
            } else {
                cell.configureCell(numberOfStars: 0, isLocked: isLocked, iconNumber: challenge.id)
                self.cellMenu.append(cell)
            }
            return cell
        } else if (self.userChallengeInfo.count == 0)  {
             let challenge = self.challengeData[indexPath.row]
            cell.configureCell(numberOfStars: 0, isLocked: isLocked, iconNumber: challenge.id)
        } else {
            print ("IS EMPTY")
        }
       return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedChallenge = self.challengeData[indexPath.row]
        switch selectedChallenge.mechanics{
        case "MultipleChoice":
            let multipleChoiceVC = MultipleChoiceController()
            multipleChoiceVC.challenge = selectedChallenge
            present(multipleChoiceVC, animated: true, completion: nil)
        case "Sort":
            let sortVC = SortViewController()
            sortVC.challenge = selectedChallenge
            present(sortVC, animated: true, completion: nil)
        case "BlankField":
            let blankFieldVC = BlankFieldViewController()
            blankFieldVC.challenge = selectedChallenge
            present(blankFieldVC, animated: true, completion: nil)
        case "DragAndDrop":
            let dragAndDropVC = DragAndDropViewController()
            dragAndDropVC.challenge = selectedChallenge
            present(dragAndDropVC, animated: true, completion: nil)
        default:
            print("No mechanics found!")
        }
    }
    
    // This function gets the return of the Firebase asynchronous call and call the respective view
    func getLevelData(level: Level,  challengesView: CollectionChallengeView) {
        self.challengeData = level.challenge.sorted(by: { $0.id < $1.id})
        print ("CHALLENGE DATA: \(self.challengeData)")
        DispatchQueue.main.async {
            challengesView.collectionChallenges1.reloadData()
        }
    }
    
    func getUserChallengeInfo(userChallengeInfo: [UserChallengeInfo]) {
        print("GET USER CHALLENGE INFO")
        self.userChallengeInfo = userChallengeInfo.sorted(by: {$0.idChallenge < $1.idChallenge})
        DispatchQueue.main.async {
            self.challengesView.collectionChallenges1.reloadData()
        }
    }
    
    func setStarsNumber(numberOfStarsTotal: Int) -> String {
        var starString: String!
        if numberOfStarsTotal < 10 {
            starString = "00" + String(numberOfStarsTotal)
        } else {
            starString = "0" + String(numberOfStarsTotal)
        }
        return starString
    }
    
    @objc func logOut() {
        User.sharedInstance.logout()
        let controller = WelcomeViewController()
        present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

