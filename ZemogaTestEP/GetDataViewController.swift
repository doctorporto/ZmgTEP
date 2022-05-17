//
//  GetDataViewController.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/12/22.
//

import UIKit
import CoreData

class GetDataViewController: UIViewController {
    
    private var apiManager = APIManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkDataStored()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func executeJSONDownloads(handleComplete:(()->())) {
        getJSONDataAndSaveToCoreData()
        getJSONDPostUserDataAndSaveToCoreData()
        getJSONDCommentsDataAndSaveToCoreData()
        handleComplete()
    }
    
     private func checkDataStored() {
        let registers = CoreData.sharedInstance.checkRegistersInCoreData()
        if registers == 0 {
            executeJSONDownloads() { () -> () in
                goToPostsView()
            }
        } else if registers != 0 {
            goToPostsView()
        }
    }
    
    private func goToPostsView() {
        self.perform(#selector(self.mainScreen))
    }
    
    //MARK: - Get JSON POST and save it to Core Data
    private func getJSONDataAndSaveToCoreData() {
        //Get posts from JSONPlaceholder:
        apiManager.getPostsData {(result) in
            switch result {
            case .success(let postList):
                //print(result)
                //Save JSON to Core Data
                CoreData.sharedInstance.saveDataOf(posts: postList.self)
            case .failure(let error):
                //Show alert in case of error:
                DispatchQueue.main.async {
                self.showAlertWith(title: "Wrong Connection", message: "Please check your internet connection and try again.")
                print("Error processing JSON data: \(error)")
                }
            }
        }
    }
    
    //MARK: - Get JSON POSTUSER and save it to Core Data
    private func getJSONDPostUserDataAndSaveToCoreData() {
        //Get posts from JSONPlaceholder:
        apiManager.getPostUserData {(result) in
            switch result {
            case .success(let postUserList):
                //Save JSON to Core Data
                CoreData.sharedInstance.savePostUserDataOf(postUser: postUserList.self)
            case .failure(let error):
                //Show alert in case of error:
                DispatchQueue.main.async {
                self.showAlertWith(title: "Wrong Connection", message: "Please check your internet connection and try again.")
                print("Error processing JSON data: \(error)")
                }
            }
        }
    }
    
    //MARK: - Get JSON COMMENTS and save it to Core Data
    private func getJSONDCommentsDataAndSaveToCoreData() {
        //Get posts from JSONPlaceholder:
        apiManager.getCommentsData {(result) in
            switch result {
            case .success(let commentList):
                //Save JSON to Core Data
                CoreData.sharedInstance.saveCommentsDataOf(comment: commentList.self)
            case .failure(let error):
                //Show alert in case of error:
                DispatchQueue.main.async {
                self.showAlertWith(title: "Wrong Connection", message: "Please check your internet connection and try again.")
                print("Error processing JSON data: \(error)")
                }
            }
        }
    }
    
    
    //MARK: - Alert Message
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) {
            (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Move to main screen
    @objc func mainScreen() {
        performSegue(withIdentifier: GO_TO_POSTS, sender: self)
    }
    
}
