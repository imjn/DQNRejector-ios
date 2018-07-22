//
//  Struct.swift
//  DQNRejector
//
//  Created by Imajin Kawabe on 2018/07/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation

struct Balance: Codable {
    let result : String
}

struct DQNString: Codable {
    let result : String
}

struct DQNUser: Codable {
    let address : String
    let name : String
}

struct CheckAdmin: Codable {
    let result : Bool
}

struct User {
    let address : String
}
