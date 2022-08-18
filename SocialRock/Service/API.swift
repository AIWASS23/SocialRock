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
        let urlRequest = URLRequest(url: URL(string: "http://adaspace.local/likes/liking_users/\(postId)")!)

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
        let urlRequest = URLRequest(url: URL(string: "http://adaspace.local/users/\(userId)")!)

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let userDecoded = try JSONDecoder().decode(Usuario.self, from: data)
            return userDecoded
        } catch {
            print(error)
        }
        return nil
    }
    
    static func createUser(name: String, email: String, password: String) async -> Session? {
        

        var urlRequest = URLRequest(url: URL(string: API.domain + "users")!)
        
        let body: [String:Any] = ["name": name,
                                  "email": email,
                                  "password": password
        ]
        
        urlRequest.httpMethod = "POST"
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)

        urlRequest.httpBody = jsonBody
        urlRequest.allHTTPHeaderFields = [
            "Content-Type": "application/json"
        ]


        do {
            let (data,_) = try await URLSession.shared.data(for: urlRequest)
                    let userData = try JSONDecoder().decode(Session.self, from: data)
                    return userData
                }catch {
                    print(error)
                }
                return nil
                
            }

    static func loginUser(username: String, password: String) async -> Session? {
        
        let login: String = "\(username):\(password)"
        let loginData = login.data(using: String.Encoding.utf8)!
        let base64 = loginData.base64EncodedString()
        print(base64)
        
        var request = URLRequest(url:URL(string:"http://adaspace.local/users/login")!)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        do {
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let session = try JSONDecoder().decode(Session.self, from: data)
            
            return session
                }
        
        catch {
            print(error)
        }

        return nil

    }

    static func getPosts() async -> [Postagem] {

        let urlRequest = URLRequest(url: URL(string: API.domain + "posts")!)

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
    
    static func createpost(token: String, content: String) async -> Postagem? {
        
        print(token)
        
        var urlRequest = URLRequest (url: URL(string: API.domain + "posts")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
        let data = content.data(using: .utf8)!
        urlRequest.httpBody = data as Data
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
            
            decoder.dateDecodingStrategy = .custom({ decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                if let date = formatter.date(from: dateString){
                    return date
                }
                
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
            })
            
            do {
                let (data, response) = try await URLSession.shared.data(for: urlRequest)
                print((response as! HTTPURLResponse).statusCode)
                print(data)
                let post = try decoder.decode(Postagem.self, from: data)
                return post
                
            }
            catch {
                print(error)
                
            }
            return nil
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




