//
//  API.swift
//  SocialRock
//
//  Created by Marcelo De Araújo on 10/08/22.
//

import Foundation

struct API {
    static let domain = "http://adaspace.local/"
    @KeychainStorage("Token") static var mockToken

    static func getLikes(postId: String) async -> [Usuario] {
        var urlRequest = URLRequest(url: URL(string: "http://adaspace.local/likes/liking_users/\(postId)")!)

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let usersDecoded = try JSONDecoder().decode([Usuario].self, from: data)
            return usersDecoded
        } catch {
            print(error)
        }
        return []
    }

    static func getUser(userId: String) async -> Usuario? {
        var urlRequest = URLRequest(url: URL(string: "http://adaspace.local/users/\(userId)")!)

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let userDecoded = try JSONDecoder().decode(Usuario.self, from: data)
            return userDecoded
        } catch {
            print(error)
        }
        return nil
    }

    static func loginUser(model: LoginModel) async -> String?{
        //print(model)
        var urlRequest = URLRequest(url: URL(string: "http://adaspace.local/users/login")!)
        urlRequest.httpMethod = "POST"

        let loginString = "\(model.email):\(model.password)".data(using: .utf8)!.base64EncodedString()

        urlRequest.setValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")

        do {

            //let data = jsonString.data(using: .utf8)!
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    return responseJSON["token"] as? String ?? nil
                }


        } catch {
            print(error)
        }

        return nil

    }

    static func createUser(model: LoginModel) async -> String? {
        var urlRequest = URLRequest(url: URL(string: API.domain + "users")!)
        urlRequest.httpMethod = "POST"

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")


        do {
            urlRequest.httpBody = try JSONEncoder().encode(model)
        }catch let error {
               print(error.localizedDescription)
           }


        do {

            //let data = jsonString.data(using: .utf8)!
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    return responseJSON["token"] as? String ?? nil

                }


        } catch {
            print(error)
        }

        return nil
    }

    static func getPosts() async -> [Postagem] {

        var urlRequest = URLRequest(url: URL(string: API.domain + "posts")!)

        do {

            //let data = jsonString.data(using: .utf8)!
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let postsDecoded = try JSONDecoder().decode([Postagem].self, from: data)
            return postsDecoded
        } catch {
            print(error)
        }
        return []
    }
// estudar
    
    static func createPost(imageData:Data?, content:String) async {

        let boundary = "Boundary-\(UUID().uuidString)"

        var urlRequest = URLRequest(url: URL(string: API.domain + "posts")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue( "Bearer \(mockToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()

        httpBody.appendString(convertFormField(named: "content", value: content, using: boundary))

        if let imageData = imageData {
            httpBody.append(convertFileData(fieldName: "media",
                                            fileName: "imagename.png",
                                            mimeType: "image/png",
                                            fileData: imageData,
                                            using: boundary))
        }


        httpBody.appendString("--\(boundary)--")

        urlRequest.httpBody = httpBody as Data

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            if case (200..<300) = statusCode{
                print("Deu certo")
            }
          // handle the response here
        }.resume()
    }
}

extension API{

    static func convertFormField(named name: String, value: String, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }

    static func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}

