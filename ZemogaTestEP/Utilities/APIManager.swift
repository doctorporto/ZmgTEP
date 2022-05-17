//
//  PostsManager.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/7/22.
//

import Foundation

class APIManager {
    
    private var dataTask: URLSessionDataTask?
    private var postUserDataTask: URLSessionDataTask?
    private var commentsDataTask: URLSessionDataTask?
    
    //MARK: - Get Posts Data from JSONPlaceHolder
    func getPostsData(completion: @escaping (Result<[Post], Error>) -> Void) {
        let urlString = POSTS_LINK
        guard let url = URL(string: urlString) else { return }
        //Create URL session
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                //Handle empty response
                print("Empty Response")
                return
            }
            print("Posts Response Status Code: \(response.statusCode)")
            guard let data = data else {
                //Handle empty data
                print("Empty Data")
                return
            }
            do {
                //Parse Data
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([Post].self, from: data)
                //Main Thread
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    //MARK: - Get Users Data
    func getPostUserData(completion: @escaping (Result<[PostUser], Error>) -> Void) {
        let urlString = POST_USERS_LINK
        guard let url = URL(string: urlString) else { return }
        //Create URL session
        postUserDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                //Handle empty response
                print("Empty Response")
                return
            }
            print("Post Users Response Status Code: \(response.statusCode)")
            guard let data = data else {
                //Handle empty data
                print("Empty Data")
                return
            }
            do {
                //Parse Data
                let decoder = JSONDecoder()
                let decodedPostUserData = try decoder.decode([PostUser].self, from: data)
                //Main Thread
                DispatchQueue.main.async {
                    completion(.success(decodedPostUserData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        postUserDataTask?.resume()
    }
    
    //MARK: - Get Comments Data
    func getCommentsData(completion: @escaping (Result<[Comments], Error>) -> Void) {
        let urlString = POST_COMMENTS_LINK
        guard let url = URL(string: urlString) else { return }
        //Create URL session
        commentsDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                //Handle empty response
                print("Empty Response")
                return
            }
            print("Comments Response Status Code: \(response.statusCode)")
            guard let data = data else {
                //Handle empty data
                print("Empty Data")
                return
            }
            do {
                //Parse Data
                let decoder = JSONDecoder()
                let decodedCommentsData = try decoder.decode([Comments].self, from: data)
                //Main Thread
                DispatchQueue.main.async {
                    completion(.success(decodedCommentsData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        commentsDataTask?.resume()
    }
    
    
}
