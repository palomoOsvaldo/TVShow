//
//  ProfileViewController.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var imgProfile: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "person.circle.fill")
        img.tintColor = .fontColor()
        img.clipsToBounds = false
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var lblProfile: lblTvShow = {
        let lbl = lblTvShow()
        lbl.text = "@\(UserDefaults.standard.string(forKey: Constants.user) ?? "")"
        return lbl
    }()
    
    lazy var stackV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [imgProfile, lblProfile])
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var lblFav: lblTvShow = {
        let lbl = lblTvShow()
        lbl.text = "Favorite Shows"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-15, height: 420)
        return layout
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

    var shows: [Result] = []
    let dbShows = DBShows()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fav = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(addFav))
        NavigationBarTV.customNavigationBarWith(reference: self, withCentralTitle: "TV Show", withTintColor: .fontColor(), leftBarButtonItems: [], rightBarButtonItems: [fav])
        shows = dbShows.readAllShows()
        self.collectionView.reloadData()
    }
    
    @objc func addFav() {
        let logout = UIAlertAction(title: "Log out", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: Constants.sessionID)
            UserDefaults.standard.removeObject(forKey: Constants.user)
            let vc = LoginRouter.createModule()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
//            self.logOut()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        self.showAlertWithActionsAndStyle(titulo: "", mensaje: Constants.message, actions: [logout, cancel], style: .actionSheet)
    }
    
    
    func logOut() {
        let req = LogOutAPI()
        APIManager.shared.request(request: req) { result in
            switch result {
            case .success(let data):
                debugPrint("Todo correcto1 \(data)")
                DispatchQueue.main.async {
                    let vc = LoginRouter.createModule()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            case .failure(let error):
                debugPrint(error as Any)
                switch error {
                case .notNetwork:
                    debugPrint("No hubo red")
                    DispatchQueue.main.async {
                        Loader.hide()
                        let cancel = UIAlertAction(title: "ok", style: .default, handler: nil)
                        self.showAlertWithActionsAndStyle(titulo: "", mensaje: "", actions: [cancel], style: .alert)
                    }
                case .unexpectedStatusCode(let status, _):
                    debugPrint("credenciales")
                    DispatchQueue.main.async {
                        Loader.hide()
                    }
                case .timeOut:
                    debugPrint("TimeOut")
                    DispatchQueue.main.async {
                        Loader.hide()
                        let cancel = UIAlertAction(title: "ok", style: .default, handler: nil)
                        self.showAlertWithActionsAndStyle(titulo: "", mensaje: "", actions: [cancel], style: .alert)
                    }
                default:
                    break
                }
            }
        }
    }
}

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentTV = shows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "showCell", for: indexPath) as! TVShowCollectionViewCell
        cell.lblTitulo.text = currentTV.name
        cell.lblDate.text = currentTV.firstAirDate
        cell.lblRate.text = String(currentTV.voteAverage)
        cell.lblSummary.text = currentTV.overview
        let isRegister = self.dbShows.showByName(name: currentTV.name )
        if isRegister.count == 0 {
            cell.btnFav.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            cell.btnFav.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        if !(currentTV.posterPath?.isEmpty ?? true) {
            let urlString = APIClient.hostImage.value + currentTV.posterPath!
            cell.imgShow.sd_setImage(with: URL(string: urlString)) { image, error, cache, url in
                if error == nil {

                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        return cell
    }
}

extension ProfileViewController {
    func configView() {
        self.view.backgroundColor = .black
        self.view.addSubview(stackV)
        self.view.addSubview(lblFav)
        self.view.addSubview(collectionView)
        
        imgProfile.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        stackV.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        stackV.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        stackV.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        
        lblFav.topAnchor.constraint(equalTo: stackV.bottomAnchor, constant: 80).isActive = true
        lblFav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        lblFav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: self.lblFav.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}
