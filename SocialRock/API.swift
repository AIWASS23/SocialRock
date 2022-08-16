//
//  API.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 10/08/22.
//

import Foundation
import SwiftUI

class API {

    static func getPosts() async -> [Postagem] {
        var urlRequest = URLRequest(url: URL(string: "https://adaspace.local/posts")!)

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let postDecoded = try JSONDecoder().decode([Postagem].self, from: data)

            return postDecoded
        } catch {
            print(error)
        }
        return []
    }

    static func getUsers() async -> [Usuario] {
        var urlRequest = URLRequest(url: URL(string: "https://adaspace.local/users")!)

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let userDecoded = try JSONDecoder().decode([Usuario].self, from: data)

            return userDecoded
        } catch {
            print(error)
        }
        return []
    }
}
