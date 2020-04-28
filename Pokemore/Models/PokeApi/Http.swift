//
//  Http.swift
//  Pokemore
//
//  Created by Jason Cloete on 2020/04/17.
//  Copyright © 2020 Jason Cloete. All rights reserved.
//

import Foundation

class Http{
    static func Get<T: Decodable>(url: String, onError: @escaping (Error?) -> Void, onResponse: @escaping (T) -> Void ){
        if let url = URL(string: url) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                     if let string = String(bytes: data, encoding: .utf8) {
                        if string == "Not Found" {
                            throw NSError(domain:"", code: 404, userInfo:nil)
                        }
                     }
                     let res = try JSONDecoder().decode(T.self, from: data)
                     onResponse(res)
                  } catch let error {
                     onError(error)
                  }
               }
              else{
                onError(nil)
            }
           }.resume()
        }
    }
     
    static func GetData(from url: String, onError: @escaping (Error?) -> Void, onResponse: @escaping (Data) -> Void ) {
        if let url = URL(string: url) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  onResponse(data)
               }
              else{
                onError(nil)
            }
           }.resume()
        }
    }
}

