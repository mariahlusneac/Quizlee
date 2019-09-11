//
//  Subbreeds.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

public class Subbreeds {
    let apiClientDog = DogAPIClient.sharedInstance
    var allDogsObtained = [DogBreed]()
    
    init() {
        apiClientDog.request(endpoint: DogAPI.allDogs).responseJSON { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success:
                DispatchQueue.main.async {
                    if let data = response.data {
                        do {
                            var dogs: [DogBreed] = []
                            let allDogs = try JSONDecoder().decode(AllDogsResponse.self, from: data)
                            allDogs.message.forEach({
                                dogs.append(DogBreed(dogBreed: $0.key, dogSubbreeds: $0.value))
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
