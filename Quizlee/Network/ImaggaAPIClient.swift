//
//  ImaggaAPIClient.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 20/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import Alamofire

enum ImaggaAPI {
    case tags
    case colors
    case postTags
}

extension ImaggaAPI {
    var url: String {
        switch self {
        case .tags:
            return "tags"
        case .postTags:
            return "tags"
        case .colors:
            return "colors"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .tags:
            return .get
        case .colors:
            return .post
        case .postTags:
            return .post
        }
    }
}

class ImaggaAPIClient {
    static let sharedInstance = ImaggaAPIClient(baseURL: "https://api.imagga.com/v2/")
    
    let baseURL: String
    
    let headers: HTTPHeaders = ["Authorization": AuthParameter.basicAuth
    ]
    
    private init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private struct AuthParameter {
        static let basicAuth = "Basic YWNjXzQ0N2IxZmRmMGU0MTM1YTo2YjBkNzRkMWE0MjMyMjQwMTgwNDYyNzBmOWZiZjk1NQ=="
    }
    
    private struct Parameter {
        static let imageUrl = "image_url"
        static let image = "image"
    }
    
    
    
    
    func getTags(for imageURL: String) -> TagsResponse {
        let parameters = [Parameter.imageUrl : imageURL]
        var responseObject: TagsResponse = TagsResponse(result: Tags(tags: []), status: Status(text: "", type: ""))

        request(endpoint: ImaggaAPI.tags, parameters: parameters).responseJSON { response in

            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                if let data = response.data {
                    do {
//                        print(value)
                        responseObject = try JSONDecoder().decode(TagsResponse.self, from: data)

//                        print("\(responseObject) \n\n\n")
                    }
                    catch let error {
                        responseObject = TagsResponse(result: Tags(tags: [Tag(tag: Language(en: "english"), confidence: 50)]), status: Status(text: "statusul meu", type: "tipul meu"))
                        print(error)
                    }
                }
            }
        }
//        print("\(responseObject) \n\n\n")
        return responseObject
    }
    
//    func postTags(with image: UIImage, _ completion: @escaping (Result<[String], Error>) -> Void) {
//
//        let url = "\(baseURL)\(ImaggaAPI.postTags.url)"
//
//        AF.upload(multipartFormData: { (multipartFromData) in
//
//            multipartFromData.append(image.pngData()!, withName: Parameter.image, fileName: "dog.jpg", mimeType: "image/jpg")
//
//        }, to: url, headers: headers).responseJSON { response in
//            switch response.result {
//            case .failure(let error):
//                print(error)
//                completion(.failure(error))
//            case .success(let value):
//                if let data = response.data {
//                    do {
//                        var myResp : [String] = []
//                        let myResponseObject = try JSONDecoder().decode(TagsResponse.self, from: data)
//                        for tag in myResponseObject.result.tags{
//                            myResp.append(tag.tag.en)
//                        }
//                        completion(.success(myResp))
//                    }
//                    catch let error {
//                        print(error)
//                    }
//                }
//            }
//        }
//    }
    
    private func request(endpoint: ImaggaAPI,
                         parameters: Parameters? = nil
        ) -> DataRequest {
        let url = "\(baseURL)\(endpoint.url)"
        return AF.request(url, method: endpoint.method, parameters: parameters, headers: headers)
    }
    
}
