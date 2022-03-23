//
//  NavigationBar.swift
//  TVShow
//
//  Created by Osvaldo Salas on 22/03/22.
//

import UIKit

public class NavigationBarTV {
    private static func changeNavigationBarBackgroundColor(reference vc: UIViewController, tint_color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .navigation()
    
        vc.navigationController?.navigationBar.tintColor = tint_color
        vc.navigationController?.navigationBar.standardAppearance = appearance
        vc.navigationController?.navigationBar.compactAppearance = appearance
        vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private static func add(leftBarButtonItems: [UIBarButtonItem]?, rightBarButtonItems: [UIBarButtonItem]?, forReference vc: UIViewController) {
        var left_buttons = [UIBarButtonItem]()
        var right_buttons = [UIBarButtonItem]()
        
        
        if let _leftBarButtonItems = leftBarButtonItems {
            for button in _leftBarButtonItems {
                left_buttons.append(button)
            }
            vc.navigationItem.leftBarButtonItems = left_buttons
        }
        
        if let _rightBarButtonItems = rightBarButtonItems {
            for button in _rightBarButtonItems {
                right_buttons.append(button)
                vc.navigationItem.rightBarButtonItems = right_buttons
            }
        }
    }
    
    public static func customNavigationBarWith(reference vc: UIViewController, withCentralTitle title: String, withTintColor color: UIColor, leftBarButtonItems: [UIBarButtonItem]?, rightBarButtonItems: [UIBarButtonItem]?) {
        
        NavigationBarTV.changeNavigationBarBackgroundColor(reference: vc, tint_color: color)
        
        NavigationBarTV.add(leftBarButtonItems: leftBarButtonItems, rightBarButtonItems: rightBarButtonItems, forReference: vc)
    }
}
