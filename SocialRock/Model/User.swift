//
//  User.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 10/08/22.
//

import Foundation

struct Usuario: Decodable {
    
    var nome: String
    var email: String
    var id: String

    enum CodingKeys: String, CodingKey {
        case nome
        case email
        case id
    }
}

extension Usuario {

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nome = try values.decode(String.self, forKey: .nome)
        email = try values.decode(String.self, forKey: .email)
        id = try values.decode(String.self, forKey: .id)
    }
}

extension Usuario: Equatable{
    static func == (lhs: Usuario, rhs: Usuario) -> Bool{
        return lhs.id == rhs.id
    }
}
