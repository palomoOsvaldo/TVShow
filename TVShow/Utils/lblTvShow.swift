//
//  lblTvShow.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import UIKit

class lblTvShow: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.configLabel()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configLabel()
    }
    
    func configLabel(){
        self.textColor = .fontColor()
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
