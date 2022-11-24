//
//  post.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 10/08/22.
//

import Foundation

struct Postagem {

    var content:String?
    var media: URL?
    var likes: [Usuario]
    var userId: String
    var user: Usuario?
    var isLikedByUser: Bool
    var id: String
    var createdAt: Date
    var updatedAt: Date

}

extension Postagem {
    func hast (into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Postagem: Decodable {
    enum CodingKeys: String, CodingKey {
        case media
        case userId = "user_id"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case content
        case user
        case likes
        case isLikeByUser
    }

    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        content = try values.decode(String.self, forKey: .content)

        if let mediaString = try? values.decode(String.self, forKey: .media) {
            media = URL(string: API.domain + mediaString)
        }

        userId = try values.decode(String.self, forKey: .userId)
        id = try values.decode(String.self, forKey: .id)
        let dateFormatter = ISO8601DateFormatter()
        let createdAtString = try values.decode(String.self, forKey: .createdAt)
        createdAt = dateFormatter.date(from: createdAtString)!
        let updatedAtString = try values.decode(String.self, forKey: .updatedAt)
        updatedAt = dateFormatter.date(from: updatedAtString)!

        user = nil
        likes = []
        isLikedByUser = false
    }

    
}
