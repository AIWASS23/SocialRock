//
//  post.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 10/08/22.
//

import Foundation
import SwiftUI

struct Postagem: Decodable{

    var countCurtida: UInt
    var media: String
    var usuarioId: String
    var id: String
    var createdAt: Date
    var updatedAt: Date
}

extension Postagem {

    enum CodingKeys: String, CodingKey {
           case countCurtida = "like_count"
           case media
           case usuarioId = "user_id"
           case id
           case createdAt = "created_at"
           case updatedAt = "updated_at"

    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        countCurtida = try values.decode(UInt.self, forKey: .countCurtida)
        media = try values.decode(String.self, forKey: .media)
        usuarioId = try values.decode(String.self, forKey: .usuarioId)
        id = try values.decode(String.self, forKey: .id)

        let dateFormatter = ISO8601DateFormatter()

        let createdAtString = try values.decode(String.self, forKey: .createdAt)
        createdAt = dateFormatter.date(from: createdAtString)!

        let updatedAtString = try values.decode(String.self, forKey: .updatedAt)
        updatedAt = dateFormatter.date(from: updatedAtString ?? "")!

    }
}

extension Postagem: Equatable{
    static func == (lhs: Postagem, rhs: Postagem) -> Bool{
        return lhs.id == rhs.id
    }
}
