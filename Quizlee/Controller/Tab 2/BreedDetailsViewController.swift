//
//  BreedDetailViewController.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 04/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedDetailsViewController: UIViewController {
    @IBOutlet weak var DetailCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let apiClient = DogAPIClient.sharedInstance
    var dogName: String?
    var imgNumber: String!
    var myFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.title = dogName!.uppercased()
        navigationController?.isNavigationBarHidden = false
        DetailCollectionView.delegate = self as? UICollectionViewDelegate
        DetailCollectionView.dataSource = self
        DetailCollectionView.register(BreedDetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        setupPageControl()
    }
}

extension BreedDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! BreedDetailCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: collectionView.frame.width * 2, height: collectionView.frame.height * 2)
        return cellSize
    }
    
    func setupPageControl() {
        apiClient.getRandomImage(withNoImages: 5) { result in
            switch result {
            case .success(let myArray):
                var imgArr: [UIView] = []
                let workGroup = DispatchGroup()
                DispatchQueue.main.sync {
                    self.pageControl.numberOfPages = myArray.count
                }
                for index in 0..<myArray.count{
                    workGroup.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
                        for img in imgArr{
                            self.DetailCollectionView.addSubview(img)
                        }
                    }))
                    workGroup.enter()
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            self.myFrame.origin.x = self.DetailCollectionView.frame.size.width * CGFloat(index)
                            self.myFrame.size = self.DetailCollectionView.frame.size
                            let imgView = UIImageView(frame: self.myFrame)
                            imgView.image = myArray[index]
                            imgArr.append(imgView)
                            workGroup.leave()
                        }
                    }
                }
            case .failure(let error) :
                print (error)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}
