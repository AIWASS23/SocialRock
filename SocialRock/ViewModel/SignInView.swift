//
//  SignIn.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 16/08/22.
//

import Foundation
import Combine

final class SignInViewModel: ObservableObject {


    @Published var email = ""
    @Published var password = ""

    @Published var hasError = false
    @Published var isSigningIn = false

    var canSignIn: Bool {
        !email.isEmpty && !password.isEmpty
    }

    func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            return
        }

        var request = URLRequest(url: URL(string: "https://adaspace.local/users/login")!)
        request.httpMethod = "POST"

        let authData = (email + ":" + password).data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")

        isSigningIn = true

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    self?.hasError = true
                } else if let data = data {
                    do {
                        let signInResponse = try JSONDecoder().decode(SignInResponse.self, from: data)

                        print(signInResponse)

                        // TODO: Cache Access Token in Keychain
                    } catch {
                        print("Unable to Decode Response \(error)")
                    }
                }

                self?.isSigningIn = false
            }
        }.resume()
    }

}

fileprivate struct SignInResponse: Decodable {

    // MARK: - Properties

    let accessToken: String

}
