//
//  SessionModel.swift
//  SocialRock
//
//  Created by Nicolas Barbosa on 18/08/22.
//

import Foundation

struct Session: Decodable {
    
    var token: String
    var user: Usuario
    
}
