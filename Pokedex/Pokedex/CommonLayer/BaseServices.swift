//
//  BaseServices.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//

import Foundation


class BaseServices {
    var cacheID = "BaseServices"
    
    init() {
        
    }
       
        //dataRequest which sends request to given URL and convert to Decodable Object
        func dataRequest<T: Decodable>(with url: String, objectType: T.Type, httpMethod : httpMethod = .get, parameters : Data? = nil, completion: @escaping (BaseResponse<T>) -> Void) {

            guard let requestURL = URL(string: url) else{
                completion(BaseResponse.failure(CDLErrorType.invalidURLError))
                return
            }
            let session = URLSession.shared

            var request = URLRequest(url: requestURL)
            request.httpMethod = httpMethod.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            
            if let parameters = parameters {
                request.httpBody = parameters
            }
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in

                guard error == nil else {
                    //It's safe to unwrap
                    completion(BaseResponse.failure(CDLErrorType.networkError(error!)))
                    return
                }

                guard let data = data else {
                    completion(BaseResponse.failure(CDLErrorType.noDataError))
                    return
                }

                
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200{
                        if(data.count != 0){
                            do {
                                // try to decode
                                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                                completion(BaseResponse.success(decodedObject))
                                return
                            } catch let error {
                                completion(BaseResponse.failure(CDLErrorType.jsonParsingError(error as! DecodingError)))
                            }
                        }else{
                            //Data is empty
                            completion(BaseResponse.success(nil))
                            return
                        }
                    }else{
                        completion(BaseResponse.failure(CDLErrorType.serverErrorWithStatusCode(httpResponse.statusCode)))
                    }
                }else{
                    completion(BaseResponse.failure(CDLErrorType.noDataError))
                }

            })
            task.resume()
        }
        
        
        func cleanup(subscriberID: String){
            CommonData.shared.unsubcribe(cacheID: cacheID, subscriberID: subscriberID)
        }

    }

    enum CDLErrorType {
        case serverError
        case noDataError
        case networkError(Error)
        case jsonParsingError(Error)
        case invalidURLError
        case invalidParameters
        case serverErrorWithStatusCode(Int)
        
        var description: String {
            switch self {
            case .serverError: return "serverError"
            case .noDataError: return "noDataError"
            case .networkError: return "networkError"
            case .jsonParsingError: return "jsonParsingError"
            case .invalidURLError: return "invalidURLError"
            case .invalidParameters: return "invalidParameters"
            case .serverErrorWithStatusCode: return "serverErrorWithStatusCode"

            }
        }
    }

    enum httpMethod : String{
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        //TODO: Add all httpMethods Here
    }
