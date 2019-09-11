//
//  Breeds.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

public class Breeds {
    let apiClientDog = DogAPIClient.sharedInstance
    var allDogsObtained = [String]()
    
    init() {
        apiClientDog.request(endpoint: DogAPI.allDogs).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                DispatchQueue.main.async {
                    if let data = response.data {
                        do {
                            var dogs: [String] = []
                            let allDogs = try JSONDecoder().decode(AllDogsResponse.self, from: data)
                            allDogs.message.forEach({
                                dogs.append($0.key)
                            })
                            self.allDogsObtained = dogs
                        }
                        catch let error {
                            print(error)
                         }
                    }
                }
            }
        }
    }
}
