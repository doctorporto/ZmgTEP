//
//  PostDetailsViewController.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/8/22.
//

import UIKit
import CoreData

class PostDetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var favoriteIconButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    //MARK: - Variables
    var userIdReceived: Int64!
    var postBodyReceived: String!
    var postIdReceived: Int64!
    var isFavoriteReceived: Bool!
    var postUserArray = [PostUserEntity]()
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var commentsArray = [CommentsEntity]()
    var postArray = [PostEntity]()
    
    override func viewWillAppear(_ animated: Bool) {
        if postBodyReceived != nil {
            postBodyLabel.text = postBodyReceived
        }
        if isFavoriteReceived != nil {
            if isFavoriteReceived == true {
                navigationItem.rightBarButtonItem?.tintColor = UIColor.yellow
            } else if isFavoriteReceived == false {
                navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            }
        }
        
        loadPostUserInfo()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        loadCommentsFromCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Load post user info function
    private func loadPostUserInfo() {
        postUserArray.removeAll()
        if userIdReceived != nil {
            if let context = self.container?.viewContext {
                let request: NSFetchRequest<PostUserEntity> = PostUserEntity.fetchRequest()
                //Condition userId
                request.predicate = NSPredicate(format: "userId = %d", userIdReceived)
                do {
                    postUserArray = try context.fetch(request)
                    nameLabel.text = postUserArray[0].name
                    emailLabel.text = postUserArray[0].email
                    phoneLabel.text = postUserArray[0].phone
                    websiteLabel.text = postUserArray[0].website
                } catch {
                    print("Error fetching data from context \(error)")
                }
            }
        }
    }
    
    //MARK: - Load Comments from Core Data function
    private func loadCommentsFromCoreData() {
        commentsArray.removeAll()
        commentsTableView.reloadData()
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<CommentsEntity> = CommentsEntity.fetchRequest()
            // Sort comments by id
            request.predicate = NSPredicate(format: "postId = %d", postIdReceived)
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CommentsEntity.commentId), ascending: true)]
            do {
                commentsArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            //print("QQQQQQ: \(commentsArray.count)")
            commentsTableView.reloadData()
        }
    }
    
    //MARK: - Actions
    @IBAction func favoriteIconButtonPressed(_ sender: UIBarButtonItem) {
        if isFavoriteReceived != nil {
            if isFavoriteReceived == true {
                navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                showAlertWith(title: "Post", message: "Post is no longer Favorite.  If you want to set as favorite press Favorite button again.")
                isFavoriteReceived = false
            } else if isFavoriteReceived == false {
                navigationItem.rightBarButtonItem?.tintColor = UIColor.yellow
                showAlertWith(title: "Post", message: "Post was set as Favorite.  If you want unset as favorite press Favorite button again.")
                isFavoriteReceived = true
            }
        }
        if userIdReceived != nil && postIdReceived != nil && isFavoriteReceived != nil {
            selectPostAsFavorite()
        }
    }
    
    //MARK: - Select Post as Favorite function
    private func selectPostAsFavorite() {
        if let context = self.container?.viewContext {
            let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
            request.predicate = NSPredicate(format: "userId = %d", userIdReceived)
            request.predicate = NSPredicate(format: "postId = %d", postIdReceived)
            do {
                postArray = try context.fetch(request)
                if postArray[0].isFavorite == false {
                    postArray[0].isFavorite = true
                    savePosts(context: context)
                } else if postArray[0].isFavorite == true {
                    postArray[0].isFavorite = false
                    savePosts(context: context)
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    }
    
    func savePosts(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error while saving: \(error)")
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
    
}

//MARK: - Extension

//MARK: - Comments Tableview
extension PostDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: POST_DETAILS_TABLEVIEW_CELL, for: indexPath) as! PostDetailsTableViewCell
        let comment = commentsArray[indexPath.row]
        cell.commentBodyLabel.text = comment.commentBody
        return cell
    }
}
