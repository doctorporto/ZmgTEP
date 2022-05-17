//
//  PostsViewController.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/7/22.
//

import UIKit
import CoreData


class PostsViewController: UIViewController {

    @IBOutlet weak var postsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var postsTableView: UITableView!
    
    //MARK: Variables:
    var userIdToSend: Int?
    var postBodyToSend: String?
    var postIdToSend: Int?
    
    var postsArray = [PostEntity]()
    var commentsArray = [CommentsEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var apiManager = APIManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.setHidesBackButton(true, animated: true)
        configurePostsSegmentedControl()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 24)!]
        postsTableView.dataSource = self
        postsTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInitialSegmentedControl()
        }

    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.setHidesBackButton(false, animated: true)
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - Initial data load related to Segmented Control
    private func loadInitialSegmentedControl() {
        if postsSegmentedControl.selectedSegmentIndex == 0 {
            setupTypeOfPosts(selectedTypeOfPosts: 0)
        } else if postsSegmentedControl.selectedSegmentIndex == 1 {
            setupTypeOfPosts(selectedTypeOfPosts: 1)
        }
    }
    
    //MARK: - Segmented Control Configuration
    func configurePostsSegmentedControl() {
        postsSegmentedControl.layer.borderWidth = 1.0
        postsSegmentedControl.layer.cornerRadius = 5.0
        postsSegmentedControl.layer.borderColor = UIColor.systemGreen.cgColor
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        postsSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        let titleTextAttributesSecond = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
        postsSegmentedControl.setTitleTextAttributes(titleTextAttributesSecond, for: .normal)
    }

    
    //MARK: - Load All Posts from Core Data
    private func loadPostFromCoreData() {
        postsArray.removeAll()
        postsTableView.reloadData()
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        // Sort posts by id
        let firstSort = NSSortDescriptor(key: #keyPath(PostEntity.isFavorite), ascending: false)
        let secondSort = NSSortDescriptor(key: #keyPath(PostEntity.postId), ascending: true)
        request.sortDescriptors = [firstSort, secondSort]
        do {
            postsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        //print("QQQQQQ: \(postsArray.count)")
        postsTableView.reloadData()
    }
    
    //MARK: - Load Favorite Posts from Core Data
    private func loadFavoritePostFromCoreData() {
        postsArray.removeAll()
        postsTableView.reloadData()
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        // Sort posts by id
        request.predicate = NSPredicate(format: "isFavorite = %d", true)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(PostEntity.postId), ascending: true)]
        do {
            postsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        postsTableView.reloadData()
    }
    
    //MARK: - Posts Segmented Control
    @IBAction func postsSegmentedControlActionPressed(_ sender: UISegmentedControl) {
        let selectedTypeOfPosts = sender.selectedSegmentIndex
        setupTypeOfPosts(selectedTypeOfPosts: selectedTypeOfPosts)
    }
    
    func setupTypeOfPosts(selectedTypeOfPosts: Int) {
        if selectedTypeOfPosts == 0 {
            //print("Select ALL")
            loadPostFromCoreData()
            
        } else if selectedTypeOfPosts == 1 {
            //print("Select FAVORITES")
            loadFavoritePostFromCoreData()
        }
    }
    
    @IBAction func getJSONDataToCoreDataAndLoadPostButtonPressed(_ sender: UIBarButtonItem) {
        checkDataStored()
    }
    
    //MARK: - Check if Core Data is empty and Dowonload data from JSONPlaceHolder
    private func checkDataStored() {
        let registers = CoreData.sharedInstance.checkRegistersInCoreData()
        if registers == 0 {
            getJSONDataAndSaveToCoreData()
            getJSONDPostUserDataAndSaveToCoreData()
            getJSONDCommentsDataAndSaveToCoreData()
            loadInitialSegmentedControl()
            postsTableView.reloadData()
        } else if registers != 0 {
            showAlertWith(title: "Alert", message: "You can reload all data from JSONPlaceHolder if you press Delete All files button")
        }
    }
    
    //MARK: - Delete Core Data Action Button
    @IBAction func deletePostsFromCoreDataButtonPressed(_ sender: UIButton) {
        //Delete Posts, PostUser, Address, Company, Geo and Comments Entities Data of Core Data
        showDeleteAllActionSheet()
    }
    
    
    
    //MARK: - Get JSON POST and save it to Core Data
    private func getJSONDataAndSaveToCoreData() {
        //Get posts from JSONPlaceholder:
        apiManager.getPostsData {(result) in
            switch result {
            case .success(let listOf):
                //Save JSON to Core Data
                CoreData.sharedInstance.saveDataOf(posts: listOf.self)
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
            case .success(let listOf):
                //Save JSON to Core Data
                CoreData.sharedInstance.savePostUserDataOf(postUser: listOf.self)
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
            case .success(let listOf):
                //Save JSON to Core Data
                CoreData.sharedInstance.saveCommentsDataOf(comment: listOf.self)
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
    
    //MARK: - Action Sheet for Deleting All Data
    func showDeleteAllActionSheet() {
        let actionSheet = UIAlertController(title: "Delete All Core Data", message: "Are you sure you want to delete all Core Data?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.deleteCoreData()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            //print("Tapped Cancel")
        }))
        present(actionSheet, animated: true)
    }
    
    //MARK: - Delete Core Data
    private func deleteCoreData() {
        CoreData.sharedInstance.deleteDataOf()
        postsArray.removeAll()
        postsTableView.reloadData()
    }
}

//MARK: - Extension

//MARK: - Post List Tableview
extension PostsViewController: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: POSTS_TABLEVIEW_CELL, for: indexPath) as! PostsTableViewCell
        let post = postsArray[indexPath.row]
        cell.postTitleLabel.text = post.title
        if post.isReaded == true {
            cell.isReadedButton.isHidden = true
        } else if post.isReaded == false {
            cell.isReadedButton.isHidden = false
        }
        if post.isFavorite == true {
            cell.favoriteImage.isHidden = false
        } else if post.isFavorite == false {
            cell.favoriteImage.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let post = postsArray[indexPath.row]
        post.setValue(true, forKey: "isReaded")
        savePosts()
        
        //Show PostDetailsViewController
        let postDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "postDetailsView") as! PostDetailsViewController
        postDetailsVC.userIdReceived = post.userId
        postDetailsVC.postBodyReceived = post.body
        postDetailsVC.postIdReceived = post.postId
        postDetailsVC.isFavoriteReceived = post.isFavorite
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let postId = self.postsArray[indexPath.row].postId
            self.loadAndDeleteCommentsFromCoreDataOfPostToDelete(postId: postId)
            self.context.delete(self.postsArray[indexPath.row])
            self.postsArray.remove(at: indexPath.row)
            self.savePosts()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func loadAndDeleteCommentsFromCoreDataOfPostToDelete(postId: Int64) {
        commentsArray.removeAll()
        let request: NSFetchRequest<CommentsEntity> = CommentsEntity.fetchRequest()
        //Filter comments by postId received
        request.predicate = NSPredicate(format: "postId = %d", postId)
        do {
            commentsArray = try context.fetch(request)
            for comment in commentsArray {
                //print("Comment to Delete: \(comment.commentId)")
                context.delete(comment)
            }
            savePosts()
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
    func savePosts() {
        do {
            try context.save()
        } catch {
            print("Error while saving: \(error)")
        }
        self.postsTableView.reloadData()
    }
    

}
