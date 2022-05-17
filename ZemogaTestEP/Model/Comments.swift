//
//  Comments.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/12/22.
//

import Foundation

struct Comments: Codable {
    let postId: Int64?
    let id: Int64?
    let name: String?
    let email: String?
    let body: String?
    
    private enum CodingKeys: String, CodingKey {
        case postId, id, name, email, body
    }
}
