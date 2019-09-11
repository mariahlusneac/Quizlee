//
//  DogsCorrectTableViewModel.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

protocol ImageGetterProtocol {
    func getRandomImage(withBreed breed: String, withSubbreed subbreed: String, completion: @escaping (Result<DogImage, NetworkError>) -> Void)
}

struct DogsCorrectTableViewModel {
    var allDogsObtained: [BreedPropertiesContainer]
    var viewmodel: DogTableViewCellViewModel!
    var imageGetter: ImageGetterProtocol
    
    init(withDogs dogs: [BreedPropertiesContainer], imageGetter: ImageGetterProtocol) {
        allDogsObtained = dogs
        self.imageGetter = imageGetter
    }
    
    func numberOfDogBreeds() -> Int {
        return allDogsObtained.count
    }
    
    func numberOfSubbreedsOfBreed(atIndex index: Int) -> Int {
        return allDogsObtained[index].hasModel?.count ?? 0
    }
    
    func subbreedViewModel(withIndex subbreedIndex: Int, andBreedIndex breedIndex: Int, completion: ((String, String) -> Void)) {
        var subbreeds: [SubbreedPropertiesContainer] = []
        print(allDogsObtained)
        for subbreed in allDogsObtained[breedIndex].hasModel! {
            
//            let subbreedCasted = subbreed as! SubbreedPropertiesContainer
            subbreeds.append(subbreed)
        }
        completion(self.allDogsObtained[breedIndex].name!, subbreeds[subbreedIndex].name ?? "no name dog")
    }
    
    func getImage(forBreed breed: String?, andSubbreed subbreed: String, completion: ((DogImage) -> (Void))?) {
        imageGetter.getRandomImage(withBreed: breed ?? "no name breed", withSubbreed: subbreed, completion: { result in
            switch result {
            case .success(let image):
                completion?(image)
                print("Arrived in getRandomImage's completion 2")
            case .failure(let error):
                print(error)
            }
        })
    }
}
