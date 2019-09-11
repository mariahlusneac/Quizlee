//
//  DogsCorrectTableViewModelTest.swift
//  QuizleeTests
//
//  Created by Maria Hlusneac on 06/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
import CoreData
@testable import Quizlee

// Additional structures and classes
struct MockSubbreed: SubbreedPropertiesContainer {
    var name: String?
    var image: String?
}

struct MockBreed: BreedPropertiesContainer {
    var name: String?
    var image: String?
    var hasModel: Array<SubbreedPropertiesContainer>?
}

class MockImageGetter: ImageGetterProtocol {
    func getRandomImage(withBreed breed: String, withSubbreed subbreed: String, completion: @escaping (Result<DogImage, NetworkError>) -> Void) {
        completion(.success(DogImage(status: "success", imageURL: "https://dog.ceo/api/breed/\(breed)/\(subbreed)/images/random")))
    }
}

// Test class
class DogsCorrectTableViewModelTest: XCTestCase {
    var expectedBreeds: [MockBreed] = []
    var expectedSubbreeds: [MockSubbreed] = []
    
    var expectedImageURL = "https://dog.ceo/api/breed/ridgeback/rhodesian/images/random"
    var requestedImageURL = MockImageGetter()
    var requested: String = ""
    
    var sut: DogsCorrectTableViewModel!
    
    override func setUp() {
        var breed1 = MockBreed(name: "ridgeback", image: "fake image url", hasModel: nil)
        var breed2 = MockBreed(name: "collie", image: "fake image url", hasModel: nil)
        let subbreedBreed1 = MockSubbreed(name: "rhodesian", image: "fake image url")
        let subbreedBreed2 = MockSubbreed(name: "border", image: "fake image url")
        let subbreeds1 = [subbreedBreed1]
        let subbreeds2 = [subbreedBreed2]
        breed1.hasModel = subbreeds1
        breed2.hasModel = subbreeds2
        
        expectedBreeds = [breed1, breed2]
        sut = DogsCorrectTableViewModel(withDogs: expectedBreeds, imageGetter: MockImageGetter())
    }
    
    func test_init() {
        for i in 0..<sut.allDogsObtained.count {
            XCTAssertEqual(sut.allDogsObtained[i].name, expectedBreeds[i].name)
        }
    }
    
    func test_numberOfDogBreeds() {
        XCTAssertEqual(sut.numberOfDogBreeds(), expectedBreeds.count)
    }
    
    func test_numberOfSubbreedsOfBreed() {
        let expectedNumberOfBreeds = expectedBreeds[1].hasModel?.count
        XCTAssertEqual(sut.numberOfSubbreedsOfBreed(atIndex: 1), expectedNumberOfBreeds)
    }
    
    func test_subbreedViewModel() {
        let subbreedIndex = 0
        let breedIndex = 1
        let expectedBreedName = "collie"
        let expectedSubbreedName = "border"
        sut.subbreedViewModel(withIndex: subbreedIndex, andBreedIndex: breedIndex) { (breedName, subbreedName) in
            XCTAssertEqual(breedName, expectedBreedName)
            XCTAssertEqual(subbreedName, expectedSubbreedName)
        }
    }
    
    func test_getImage() {
        sut.getImage(forBreed: "ridgeback", andSubbreed: "rhodesian") { (imageRepresentation) in
            XCTAssertEqual(imageRepresentation.imageURL, self.expectedImageURL)
        }
    }
}
