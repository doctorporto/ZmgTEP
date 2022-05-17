//
//  PostUser.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/10/22.
//

import Foundation

struct PostUser: Codable {
    let id: Int64?
    let name: String?
    let username: String?
    let email: String?
    let address: Address
    let phone: String?
    let website: String?
    let company: Company
    
    private enum CodingKeys: String, CodingKey {
        case id, name, username, email, address, phone, website, company
    }
}

struct Address: Codable {
    let street: String?
    let suite: String?
    let city: String?
    let zipcode: String?
    let geo: Geo
    
    private enum CodingKeys: String, CodingKey {
        case street, suite, city, zipcode, geo
    }
}
    
struct Geo: Codable {
    let lat: String?
    let lng: String?
    
    private enum CodingKeys: String, CodingKey {
        case lat, lng
    }
}

struct Company: Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, catchPhrase, bs
    }
}

