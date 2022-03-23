//
//  Loader.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import UIKit

class Loader: UIView {
    private static var background: UIView?
    
    static func showLoader(referenceView: UIView) {
        background = UIView(frame: UIScreen.main.bounds)
        background?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        referenceView.addSubview(background!)
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.center = background!.center
        activity.color = .fontColor()
        background?.addSubview(activity)
        activity.startAnimating()
    }
    
    static func hide() {
        background?.removeFromSuperview()
    }
}

extension UIViewController {
    func showAlertWithActionsAndStyle(titulo: String, mensaje: String, actions:[UIAlertAction], style: UIAlertController.Style){
        let alertController = UIAlertController(title: titulo, message: mensaje , preferredStyle: style)
        for action in actions {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
