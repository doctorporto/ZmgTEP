//
//  PostsList.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/8/22.
//

import Foundation

struct Post: Codable {
    let userId: Int64?
    let id: Int64?
    let title: String?
    let body: String?
    
    private enum CodingKeys: String, CodingKey {
        case userId, id, title, body
    }
}
