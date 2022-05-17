//
//  CoreData.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/10/22.
//

import UIKit
import CoreData

class CoreData {
    
    private var apiManager = APIManager()
    var postUsersFromCoreData = [PostUserEntity]()
    
    static let sharedInstance = CoreData()
    private init(){}
    
    private let container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    private var fetchedResultsController: NSFetchedResultsController<PostEntity>?
    
    private let postFetchRequest = NSFetchRequest<PostEntity>(entityName: POST_ENTITY)
    private let postUserFetchRequest = NSFetchRequest<PostUserEntity>(entityName: POST_USER_ENTITY)
    private let commentsFetchRequest = NSFetchRequest<CommentsEntity>(entityName: COMMENTS_ENTITY)
    private let addressFetchRequest = NSFetchRequest<AddressEntity>(entityName: ADDRESS_ENTITY)
    private let companyFetchRequest = NSFetchRequest<CompanyEntity>(entityName: COMPANY_ENTITY)
    private let geoFetchRequest = NSFetchRequest<GeoEntity>(entityName: GEO_ENTITY)
    
    
    //MARK: - Save POSTS data from JSON to Core Data
    func saveDataOf(posts: [Post]) {
        //Updates CoreData with new data from JSON - Off the main thread
        self.container?.performBackgroundTask{ [weak self] (context) in
            self?.deleteObjectsFromCoreData(context: context)
            self?.saveJSONToCoreData(posts: posts, context: context)
        }
    }
    
    private func saveJSONToCoreData(posts: [Post], context: NSManagedObjectContext) {
        context.perform {
            for post in posts {
                let postEntity = PostEntity(context: context)
                postEntity.postId = Int64(post.id!)
                postEntity.userId = Int64(post.userId!)
                postEntity.title = post.title
                postEntity.body = post.body
                postEntity.isFavorite = false
                postEntity.isReaded = false
            }
            //Save Data
            do {
                try context.save()
            } catch {
                fatalError("Fail to save context: \(error)")
            }
        }
    }
    
    //MARK: - Delete Core Data POST objects before saving new data
    private func deleteObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            //Fetch data
            let objects = try context.fetch(postFetchRequest)
            //Delete data
            _ = objects.map({context.delete($0)})
            //Save data
            try context.save()
        } catch {
            print("Error while deleting: \(error)")
        }
    }
    
    
    //MARK: - Save POSTUSER data from JSON to Core Data
    func savePostUserDataOf(postUser: [PostUser]) {
        //Updates CoreData with new data from JSON - Off the main thread
        self.container?.performBackgroundTask{ [weak self] (context) in
            self?.deletePostUserObjectsFromCoreData(context: context)
            self?.deletePostUserAddressObjectsFromCoreData(context: context)
            self?.deletePostUserAddressGeoObjectsFromCoreData(context: context)
            self?.deletePostUserCompanyObjectsFromCoreData(context: context)
            self?.saveJSONPostUserToCoreData(postsUser: postUser, context: context)
        }
    }
    
    private func saveJSONPostUserToCoreData(postsUser: [PostUser], context: NSManagedObjectContext) {
        context.perform {
            for postUser in postsUser {
                let postUserEntity = PostUserEntity(context: context)
                let addressEntity = AddressEntity(context: context)
                let companyEntity = CompanyEntity(context: context)
                let geoEntity = GeoEntity(context: context)
                postUserEntity.userId = Int64(postUser.id!)
                postUserEntity.name = postUser.name
                postUserEntity.username = postUser.username
                postUserEntity.email = postUser.email
                postUserEntity.phone = postUser.phone
                postUserEntity.website = postUser.website
                companyEntity.companyName = postUser.company.name
                companyEntity.business = postUser.company.bs
                companyEntity.catchPhrase = postUser.company.catchPhrase
                addressEntity.city = postUser.address.city
                addressEntity.suite = postUser.address.suite
                addressEntity.street = postUser.address.street
                addressEntity.zipcode = postUser.address.zipcode
                geoEntity.lat = postUser.address.geo.lat
                geoEntity.lng = postUser.address.geo.lng
            }
            //Save Data
            do {
                try context.save()
            } catch {
                fatalError("Fail to save context: \(error)")
            }
        }
    }
    
    //MARK: - Delete Core Data POSTUSER objects before saving new data
    private func deletePostUserObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            //Fetch data
            let objects = try context.fetch(postUserFetchRequest)
            //Delete data
            _ = objects.map({context.delete($0)})
            //Save data
            try context.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
    
    private func deletePostUserAddressObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            //Fetch data
            let objects = try context.fetch(addressFetchRequest
            )
            //Delete data
            _ = objects.map({context.delete($0)})
            //Save data
            try context.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
    
    private func deletePostUserAddressGeoObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            //Fetch data
            let objects = try context.fetch(geoFetchRequest
            )
            //Delete data
            _ = objects.map({context.delete($0)})
            //Save data
            try context.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
    
    private func deletePostUserCompanyObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            //Fetch data
            let objects = try context.fetch(companyFetchRequest
            )
            //Delete data
            _ = objects.map({context.delete($0)})
            //Save data
            try context.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
    
    
    //MARK: - Save COMMENTS data from JSON to Core Data
    func saveCommentsDataOf(comment: [Comments]) {
        //Updates CoreData with new data from JSON - Off the main thread
        self.container?.performBackgroundTask{ [weak self] (context) in
            self?.deleteCommentsObjectsFromCoreData(context: context)
            self?.saveJSONCommentsToCoreData(comments: comment, context: context)
        }
    }
    
    private func saveJSONCommentsToCoreData(comments: [Comments], context: NSManagedObjectContext) {
        context.perform {
            for comment in comments {
                let commentsEntity = CommentsEntity(context: context)
                commentsEntity.postId = Int64(comment.postId!)
                commentsEntity.commentId = Int64(comment.id!)
                commentsEntity.name = comment.name
                commentsEntity.email = comment.email
                commentsEntity.commentBody = comment.body
            }
            //Save Data
            do {
                try context.save()
            } catch {
                fatalError("Fail to save context: \(error)")
            }
        }
    }
    
    //MARK: - Delete Core Data COMMENTS objects before saving new data
    private func deleteCommentsObjectsFromCoreData(context: NSManagedObjectContext) {
        do {
            //Fetch data
            let objects = try context.fetch(commentsFetchRequest)
            //Delete data
            _ = objects.map({context.delete($0)})
            //Save data
            try context.save()
        } catch {
            print("Error deleting: \(error)")
        }
    }
    
    
    //MARK: - Delete ALL ENTITIES from Core Data
    func deleteDataOf() {
        self.container?.performBackgroundTask{ [weak self] (context) in
            self?.deleteObjectsFromCoreData(context: context)
            self?.deletePostUserObjectsFromCoreData(context: context)
            self?.deletePostUserAddressObjectsFromCoreData(context: context)
            self?.deletePostUserAddressGeoObjectsFromCoreData(context: context)
            self?.deletePostUserCompanyObjectsFromCoreData(context: context)
            self?.deleteCommentsObjectsFromCoreData(context: context)
        }
    }
    
    //MARK: - Check if CoreData is already loaded
    func checkRegistersInCoreData() -> Int {
        var registerCount: Int!
        let context = self.container?.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: POST_ENTITY)
        do {
            registerCount = try context!.count(for: fetchRequest)
            return registerCount
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    
}

