//
//  DogsTableViewController.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogsTableViewController: UITableViewController {

    let dogReuseIdentifier = "DogTableViewCell"
    private var allDogBreeds = DogRepository.getAllDogs()
    var allDogBreedsDict = DogRepository.getAllDogsDict()
    var dogBreedsWithoutSubbreeds = [String]()
    var allDogsSubbreeds = [String]()
    private var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell(dogReuseIdentifier)
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 39, left: 120, bottom: 39, right: 0)
        tableView.rowHeight = 72
        
        for dogBreed in allDogBreeds {
            if dogBreed.dogSubbreeds.count == 0 {
                dogBreedsWithoutSubbreeds.append(dogBreed.dogBreed)
            }
        }

        for i in 0..<allDogBreeds.count {
            sectionTitles.append(allDogBreeds[i].dogBreed)
        }
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allDogBreeds.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDogBreeds[section].dogSubbreeds.count
    }
    
    
    // Header
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200))
        
        if allDogBreedsDict[sectionTitles[section]]!.count == 0 {
            var randomImageNumber = Int.random(in: 0...22)
            let imageView = UIImageView(frame: CGRect(x: 35, y: 25, width: 40, height: 40))
            imageView.image = UIImage(named: "\(randomImageNumber)")
            sectionHeader.addSubview(imageView)
        }
        
        let titleLabel = UILabel(frame: CGRect(x: 89, y: 30, width: 200, height: 30))
        titleLabel.numberOfLines = 0
        titleLabel.text = sectionTitles[section].uppercased()
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font.withSize(CGFloat(integerLiteral: 18))
        sectionHeader.addSubview(titleLabel)
        sectionHeader.layer.backgroundColor = UIColor.white.cgColor
        
        return sectionHeader
    }
    
    
    // Cell config
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        for dogBreed in allDogBreedsDict {
            if dogBreed.value.count > 0 {
                for dogSubbreed in dogBreed.value {
                    allDogsSubbreeds.append(dogSubbreed)
                }
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: dogReuseIdentifier, for: indexPath) as! DogTableViewCell
        let sectionKey = sectionTitles[indexPath.section]
        var dogSubbreed = allDogBreedsDict[sectionKey]?[indexPath.row]
        
        if let unwrDogSubbreed = dogSubbreed {
//            cell.config(withDogBreed: unwrDogSubbreed)
            cell.breedLabel.text = "\(unwrDogSubbreed)"
        }

        var randomImageNumber = Int.random(in: 0...22)
        cell.breedImage.image = UIImage(named: "\(randomImageNumber)")
    

        
        return cell
    }
    
    
    // Footer
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFooter = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 2))
        sectionFooter.backgroundColor = .clear
        let sectionFooterView = UIView(frame: CGRect(x: 89, y: 0, width: sectionFooter.frame.size.width - 89, height: 2))
        sectionFooterView.backgroundColor = UIColor(red: 240.0 / 255.0, green: 244.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
        sectionFooter.addSubview(sectionFooterView)
        return sectionFooter
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: dogReuseIdentifier, for: indexPath) as! DogTableViewCell
        cell.backgroundColor = .white
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: dogReuseIdentifier, for: indexPath) as! DogTableViewCell
        cell.backgroundColor = .blue
    }
    
    
    // Cell registering
    
    fileprivate func registerCell(_ reuseId: String) {
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: reuseId)
    }
}
