//
//  DogsCorrectTableViewController.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

typealias VoidBlock = () -> Void

class WorkGroup {
    private var numberOfJobs = 0
    private var completion: VoidBlock?
    var lock = NSLock()
    
    func increaseJobs() {
        lock.lock()
        numberOfJobs += 1
        lock.unlock()
    }
    
    func decreaseJobs() {
        lock.lock()
        numberOfJobs -= 1
        if numberOfJobs == 0 {
            completion?()
        }
        lock.unlock()
    }
    
    init(notifier: VoidBlock?) {
        completion = notifier
    }
}

class DogsCorrectTableViewController: UITableViewController {
    var activityIndicator = UIActivityIndicatorView()
    let dogReuseIdentifier = "DogTableViewCell"
    
    let apiClientDog = DogAPIClient.sharedInstance
    let apiClientImagga = ImaggaAPIClient.sharedInstance
    
    private var sectionTitles = [String]()
    var imagesDictionary: Dictionary<IndexPath, String> = [:]
    var cellDictionary: Dictionary<IndexPath, DogTableViewCell> = [:]
    
    var allDogsObtained = [DogBreed]()
    var dogSubbreeds = [String]()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchRC: NSFetchedResultsController<Breed>!
    private var query = ""
    
    var viewmodel: DogsCorrectTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell(dogReuseIdentifier)
        tableView.separatorColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 39, left: 120, bottom: 39, right: 0)
        tableView.rowHeight = 72
        
        configActivityIndicator()
        
        testNetworkCalls()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
//        tableView.reloadData()
    }
    
    private func refresh() {
        let request = Breed.fetchRequest() as NSFetchRequest<Breed>
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        let sort = NSSortDescriptor(key: #keyPath(Breed.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]
        do {
            fetchRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: #keyPath(Breed.name), cacheName: nil)
            try fetchRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    public func testNetworkCalls() {
        showActivityIndicatory()
        apiClientDog.getAllDogs { result in
            switch result {
            case .success(let allBreeds):
                var subbreedList: [String] = []
                self.viewmodel = DogsCorrectTableViewModel(withDogs: allBreeds, imageGetter: DogAPIClient(baseURL: URL(string: "https://dog.ceo/api/")!))
                for breed in allBreeds {
                    self.sectionTitles.append(breed.name!)
                    if breed.has?.count != 0 {
                        for subbreed in breed.has! {
                            let subbreedCasted = subbreed as! Subbreed
                            subbreedList.append(subbreedCasted.name!)
                        }
                    }
                    self.allDogsObtained.append(DogBreed(dogBreed: breed.name!, dogSubbreeds: subbreedList))
                    
                    subbreedList.removeAll()
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.appDelegate.saveContext()
            case .failure(let error):
                print(error)
            }
            self.hideActivityIndicatory()
        }
    }
    
    func configActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
    }
    
    func showActivityIndicatory() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicatory() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension DogsCorrectTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewmodel == nil ? 0 : viewmodel.numberOfDogBreeds()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.numberOfSubbreedsOfBreed(atIndex: section)
    }
    
    // Cell registering
    fileprivate func registerCell(_ reuseId: String) {
        let nib = UINib(nibName: reuseId, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: reuseId)
    }
    
    // Cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        for dog in allDogsObtained {
            if dog.dogSubbreeds.count > 0 {
                for dogSubbreed in dog.dogSubbreeds {
                    dogSubbreeds.append(dogSubbreed)
                }
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: dogReuseIdentifier, for: indexPath) as! DogTableViewCell

        self.viewmodel.subbreedViewModel(withIndex: indexPath.row, andBreedIndex: indexPath.section) {
            (breedName, subbreedName) in
            self.viewmodel.getImage(forBreed: breedName, andSubbreed: subbreedName) { image in
                cell.viewmodel = DogTableViewCellViewModel(withDog: DogTab2(image: image, name: subbreedName))
            }
        }
        
        cellDictionary[indexPath] = cell
        return cell
    }
    
    
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200))
//        print(sectionTitles)
        let sectionTitle = sectionTitles[section]
        
        let workGroup = DispatchGroup()
        
        for dog in allDogsObtained {
            if dog.dogBreed == sectionTitle {
                apiClientDog.getRandomImage(withBreed: "\(sectionTitle)") { result in
                    switch result {
                    case .success(let image):
                        let imageUrl = image.imageURL
                        workGroup.enter()
                        DispatchQueue.global(qos: .background).async {
                            let data = try? Data(contentsOf: URL(string: imageUrl)!)
                            DispatchQueue.main.async {
                                let imageView = UIImageView(frame: CGRect(x: 35, y: 25, width: 40, height: 40))
                                imageView.image = UIImage(data: data!)
                                sectionHeader.addSubview(imageView)
                                workGroup.leave()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                    self.hideActivityIndicatory()
                }
            }
        }
        
        workGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
            
        }))
        
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
        cell.contentView.backgroundColor = .blue
        guard let url = imagesDictionary[indexPath] else { return }
        let tags = self.apiClientImagga.getTags(for: url)
        //        print("\\\\\\\\ \(tags)")
        for tag in tags.result.tags {
            if cell.breedLabel.text == tag.tag.en {
                print("ImaggaAPI recognized the breed well")
            }
            else {
                print("ImaggaAPI knows nothing")
            }
        }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let newViewController = (storyboard.instantiateViewController(withIdentifier: "BreedDetailsVC") as? BreedDetailsViewController)!
        navigationController?.pushViewController(newViewController, animated: true)
        
        var myCell: DogTableViewCell
        myCell = cell
        
        for cell in cellDictionary {
            if indexPath.section == cell.key.section && indexPath.row == cell.key.row {
                myCell = cell.value
            }
        }
        newViewController.navigationItem.title = myCell.breedLabel.text?.capitalized
    }
}
