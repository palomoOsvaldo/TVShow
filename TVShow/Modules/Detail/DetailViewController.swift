//
//  DetailViewController.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var tvShow: Result?
    let dbShows = DBShows()
    var barBtn = UIBarButtonItem()
    
    lazy var imgtvShow: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = false
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var lblTitulo: lblTvShow = {
        let lbl = lblTvShow()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var lblDate = lblTvShow()
    var lblRate = lblTvShow()
    var lblPopular = lblTvShow()
    var lblLanguage = lblTvShow()
    
    lazy var lblSummary: lblTvShow = {
        let lbl = lblTvShow()
        lbl.textColor = .white
        lbl.textAlignment = .justified
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var stackV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imgtvShow, lblTitulo, lblDate, lblRate, lblPopular, lblLanguage, lblSummary])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isRegister = self.dbShows.showByName(name: tvShow?.name ?? "")
        if isRegister.count == 0 {
            barBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addOrDelete))
        } else {
            barBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addOrDelete))
        }
        NavigationBarTV.customNavigationBarWith(reference: self, withCentralTitle: "TV tvShow", withTintColor: .fontColor(), leftBarButtonItems: [], rightBarButtonItems: [barBtn])
    }
    
    @objc func addOrDelete() {
        let isRegister = self.dbShows.showByName(name: tvShow?.name ?? "")
        if isRegister.count == 0 {
            self.dbShows.insert(id: 0, name: tvShow?.name ?? "", imgMedium: tvShow?.posterPath ?? "", imgOriginal: tvShow?.backdropPath ?? "", summary: tvShow?.overview ?? "", date: tvShow?.firstAirDate ?? "", rating: String(tvShow?.voteAverage ?? 0) , isFav: true)
            barBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addOrDelete))
            self.navigationItem.rightBarButtonItem = self.barBtn
        } else {
            if self.dbShows.deleteByName(name: tvShow?.name ?? "") {
                let alert = UIAlertController(title: "", message: "successfully erased", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.barBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addOrDelete))
                    self.navigationItem.rightBarButtonItem = self.barBtn
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension DetailViewController {
    
    func configView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        contentView.addSubview(stackV)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50).isActive = true
        
        stackV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
        self.title = tvShow?.name ?? ""
        lblTitulo.text = tvShow?.name ?? ""
        lblDate.text = tvShow?.firstAirDate ?? ""
        lblRate.text = "⭐️ \(tvShow?.voteAverage ?? 0)"
        lblPopular.text = "Popularity: \(tvShow?.popularity ?? 0)"
        lblLanguage.text = "Language: \(tvShow?.originalLanguage ?? "")"
        lblSummary.text = tvShow?.overview
        
        if !(tvShow?.posterPath?.isEmpty ?? true) {
            let urlString = APIClient.hostImage.value + tvShow!.posterPath!
            imgtvShow.sd_setImage(with: URL(string: urlString)) { image, error, cache, url in
                if error == nil {

                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        
    }
}

