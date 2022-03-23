//
//  TVShowViewController.swift
//  TVShow
//
//  Created Osvaldo Salas on 16/03/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import SDWebImage

class TVShowViewController: UIViewController {

	var presenter: TVShowPresenterProtocol?
    var shows: [Result] = []
    let dbShows = DBShows()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-15, height: UIScreen.main.bounds.width/2-15)
        return layout
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let sg = UISegmentedControl(items: ["Popular", "Top Rated", "OnTV", "Airing Today"])
        sg.backgroundColor = .segmented()
        sg.selectedSegmentTintColor = .segmentedSelected()
        sg.tintColor = .white
        sg.addTarget(self, action: #selector(changeOption(_:)), for: .valueChanged)
        sg.translatesAutoresizingMaskIntoConstraints = false
        return sg
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(TVShowCollectionViewCell.self, forCellWithReuseIdentifier: "showCell")
        cv.backgroundColor = .black
        cv.translatesAutoresizingMaskIntoConstraints = false
       return cv
    }()

	override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.title = "TV Show"
        self.segmentedControl.selectedSegmentIndex = 0
        self.configView()
        Loader.showLoader(referenceView: self.view)
        self.presenter?.createTVShow(selectedOption: .popular)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationBarTV.customNavigationBarWith(reference: self, withCentralTitle: "TV Show", withTintColor: .white, leftBarButtonItems: [], rightBarButtonItems: [])
    }
    
    @objc func changeOption(_ sender: UISegmentedControl) {
        let select = MenuSGV.init(rawValue: sender.selectedSegmentIndex) ?? .popular
        Loader.showLoader(referenceView: self.view)
        self.presenter?.createTVShow(selectedOption: select)
    }

}

extension TVShowViewController: TVShowViewProtocol {
    func succesShows(shows: [Result]) {
        Loader.hide()
        self.shows = shows
        self.collectionView.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        Loader.hide()
        let reintentar = UIAlertAction(title: "Retry", style: .default) { _ in
            Loader.showLoader(referenceView: self.view)
            self.segmentedControl.selectedSegmentIndex = 0
            self.presenter?.createTVShow(selectedOption: .popular)
        }
        self.showAlertWithActionsAndStyle(titulo: title, mensaje: message, actions: [reintentar], style: .alert)
    }
    
    
}

extension TVShowViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentTV = shows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath) as! TVShowCollectionViewCell
        cell.lblTitulo.text = currentTV.name
        cell.lblDate.text = currentTV.firstAirDate
        cell.lblRate.text = "⭐️ \(String(currentTV.voteAverage))"
        cell.lblSummary.text = currentTV.overview
        cell.delegate = self
        cell.currentInfo = currentTV
        let isRegister = self.dbShows.showByName(name: currentTV.name )
        if isRegister.count == 0 {
            cell.btnFav.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            cell.btnFav.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
//        if !(currentTV.posterPath?.isEmpty ?? true) {
//            let urlString = APIClient.hostImage.value + currentTV.posterPath!
//            cell.imgShow.sd_setImage(with: URL(string: urlString)) { image, error, cache, url in
//                if error == nil {
//
//                } else {
//                    print(error!.localizedDescription)
//                }
//            }
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentTV = shows[indexPath.row]
        self.presenter?.selectShow(selectShow: currentTV)
    }
}

extension TVShowViewController: TVShowFav {
    func addFav(tvShow: Result) {
        let isRegister = self.dbShows.showByName(name: tvShow.name)
        if isRegister.count == 0 {
            self.dbShows.insert(id: 0, name: tvShow.name, imgMedium: tvShow.posterPath ?? "", imgOriginal: tvShow.backdropPath ?? "", summary: tvShow.overview, date: tvShow.firstAirDate, rating: String(tvShow.voteAverage) , isFav: true)
        } else {
            if self.dbShows.deleteByName(name: tvShow.name) {
                let alert = UIAlertController(title: "", message: "successfully erased", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.collectionView.reloadData()
    }
}

extension TVShowViewController {
    func configView() {
        
        self.view.addSubview(segmentedControl)
        self.view.addSubview(collectionView)

        segmentedControl.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}
