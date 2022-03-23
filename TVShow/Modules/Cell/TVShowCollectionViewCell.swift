//
//  TVShowCollectionViewCell.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import UIKit

protocol TVShowFav {
    func addFav(tvShow: Result)
}

class TVShowCollectionViewCell: UICollectionViewCell {
    
    lazy var imgShow: UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = false
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var lblTitulo = lblTvShow()
    var lblDate = lblTvShow()
    var lblRate = lblTvShow()
    
    lazy var stackV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [lblDate, lblRate])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var lblSummary: lblTvShow = {
        let lbl = lblTvShow()
        lbl.textColor = .white
        lbl.numberOfLines = 4
        lbl.textAlignment = .justified
        return lbl
    }()
    
    lazy var btnFav: UIButton = {
        let btn = UIButton()
        btn.tintColor = .fontColor()
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(addFavs(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var delegate: TVShowFav?
    var currentInfo: Result?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .backgoundCell()
        contentView.addSubview(imgShow)
        contentView.addSubview(lblTitulo)
        contentView.addSubview(stackV)
        contentView.addSubview(lblSummary)
        contentView.addSubview(btnFav)
        
        imgShow.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imgShow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imgShow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imgShow.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        btnFav.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        btnFav.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        btnFav.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btnFav.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        lblTitulo.topAnchor.constraint(equalTo: imgShow.bottomAnchor, constant: 20).isActive = true
        lblTitulo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        lblTitulo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        stackV.topAnchor.constraint(equalTo: lblTitulo.bottomAnchor, constant: 10).isActive = true
        stackV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        stackV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        lblSummary.topAnchor.constraint(equalTo: stackV.bottomAnchor, constant: 10).isActive = true
        lblSummary.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        lblSummary.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: lblSummary.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addFavs(_ sender: UIButton) {
        delegate?.addFav(tvShow: currentInfo ?? Result(posterPath: "", popularity: 0, id: 0, backdropPath: "", voteAverage: 0, overview: "", firstAirDate: "", originCountry: [], genreIDS: [], originalLanguage: "", voteCount: 0, name: "", originalName: ""))
    }
}
