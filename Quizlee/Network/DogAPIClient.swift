//
//  DogAPIClient.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

enum DogAPI {
    case allDogs
    case randomImage
    case image(breed: String)
    case imageSubbreed(breed: String, subbreed: String)
    case randomImageNumber(nr: Int)

}

extension DogAPI {
    var endpoint: String {
        switch self {
        case .allDogs:
            return "breeds/list/all"
        case .randomImage:
            return "breeds/image/random"
        case .image(let breed):
            return "breed/\(breed)/images/random"
        case .imageSubbreed(let breed, let subbreed):
            return "breed/\(breed)/\(subbreed)/images/random"
        case .randomImageNumber(let nr):
            return "breeds/image/random/\(nr)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .allDogs:
            return .get
        case .randomImage:
            return .get
        case .image( _):
            return .get
        case .imageSubbreed( _, _):
            return .get
        case .randomImageNumber( _):
            return .get
        }
    }
    
}

class DogAPIClient: ImageGetterProtocol {
    let baseURL: URL
    
    static let sharedInstance = DogAPIClient(baseURL: URL(string: "https://dog.ceo/api/")!)
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getAllDogs(_ completion: @escaping (Result<[Breed], NetworkError>) -> Void) {
        let url = URL(string: "\(baseURL)\(DogAPI.allDogs.endpoint)")!
        let networkManager = NetworkManager(url: url)
        
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let allDogs = try JSONDecoder().decode(AllDogsResponse.self, from: data)
                    allDogs.message.forEach({
                        let breedNameRequest = Breed.fetchRequest() as NSFetchRequest<Breed>
                        breedNameRequest.predicate = NSPredicate(format: "name = %@", $0.key)
                        do {
                            let breedNameResult = try self.context.fetch(breedNameRequest).first
                            if breedNameResult == nil {
                                let dogBreed = Breed(entity: Breed.entity(), insertInto: self.context)
                                dogBreed.name = $0.key
                                for item in $0.value {
                                    let dogSubbreed = Subbreed(entity: Subbreed.entity(), insertInto: self.context)
                                    dogSubbreed.name = item
                                    dogSubbreed.owner = dogBreed
                                    dogBreed.addToHas(dogSubbreed)
                                }
                            }
                        }
                        catch {
                            print("error fetching breed: \($0.key)")
                        }
                    })
                    DispatchQueue.main.async {
                        self.appDelegate.saveContext()
                    }
                    
                    let allBreedsRequest = NSFetchRequest<Breed>(entityName: "Breed")
                    do {
                        let allBreeds = try self.context.fetch(allBreedsRequest)
                        completion(.success(allBreeds))
                    }
                    catch {
                        print("error")
                    }
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }

    
    func getRandomImage(withBreed breed: String, completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.image(breed: breed).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImage.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                    
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getRandomImage(withBreed breed: String, withSubbreed subbreed: String, completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.imageSubbreed(breed: breed, subbreed: subbreed).endpoint)")!
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(DogImage.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                    print("Arrived in getRandomImage function 1")
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func getRandomImage(withNoImages nr: Int,_ completion: @escaping (Result<[UIImage], NetworkError>) -> Void) {
        let url =  URL(string: "\(baseURL)\(DogAPI.randomImageNumber(nr: nr).endpoint)")!
        print ("url",url)
        let networkManager = NetworkManager(url: url)
        networkManager.getJSON { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let reply = try JSONDecoder().decode(DogImagesReply.self, from: data)
                    var images = [UIImage]()
                    for item in reply.message {
                        let url = URL(string: item)!
                        let data = try Data(contentsOf: URL(resolvingAliasFileAt: url))
                        images.append(UIImage(data: data)!)
                    }
                    DispatchQueue.main.async {
                        completion(.success(images))
                    }
                    
                }
                catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }
    
    func request(endpoint: DogAPI) -> DataRequest {
        let url = "\(baseURL)\(endpoint.endpoint)"
        return AF.request(url, method: endpoint.method)
    }
}

