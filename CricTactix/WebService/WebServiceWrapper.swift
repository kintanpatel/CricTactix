//
//  WebServiceWrapper.swift
//  CricTactix
//
//  Created by kintan on 04/05/24.
//

import Foundation
struct WebServiceWrapper {
    
    //1 creating the session
    let session: URLSession
    
    private init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    private init() {
        self.init(configuration: .default)
    }
    
    static let shared = WebServiceWrapper()
    
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (Result<JSON>) -> ()
    
    func jsonGetTask(url:URL ,accesToken: String? = "", completionHandler completion: @escaping JSONTaskCompletionHandler) {
        
        var request = URLRequest(url: url)
       
        let headers = [
            "X-RapidAPI-Key": "e8609399d9mshc276febe3987745p174e98jsn84c4980bbb38",
            "X-RapidAPI-Host": "cricket-live-data.p.rapidapi.com"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        self.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session.configuration.urlCache = nil
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.Error(.requestFailed))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                DispatchQueue.main.async {
                                    completion(.Success(json))
                                }
                            }
                        } catch {
                            completion(.Error(.jsonConversionFailure))
                        }
                    } else {
                        completion(.Error(.invalidData))
                    }
                }
                else if httpResponse.statusCode == 400 || httpResponse.statusCode == 401
                {
                    
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                DispatchQueue.main.async {
                                    completion(.ApiError(json as! [String : String]))
                                }
                            }
                        } catch {
                            completion(.Error(.jsonConversionFailure))
                        }
                    } else {
                        completion(.Error(.invalidData))
                    }
                }
                else {
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                                DispatchQueue.main.async {
                                    completion(.ApiError(json as [String : Any]))
                                }
                            }
                        } catch {
                            completion(.Error(.jsonConversionFailure))
                        }
                    } else {
                        completion(.Error(.invalidData))
                    }
                }
            })
        })
        dataTask.resume()
        
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?) -> Void){
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                DispatchQueue.main.async(execute: {
                    if data != nil
                    {
                        if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                        {
                            completion(data)
                        }
                        else
                        {
                            completion(nil)
                        }
                    }
                    else
                    {
                        completion(nil)
                    }
                })
            }.resume()
        }
    }
    
    
}

enum Result<T>{
    case Success(T)
    case Error(ApiResponseError)
    case ApiError([String:Any])
}

enum ApiResponseError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case jsonParsingFailure
    case offline
    
}

