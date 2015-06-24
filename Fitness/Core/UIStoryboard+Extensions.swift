//
//  UIStoryboard+Extensions.swift
//  Fitness
//
//  Created by Manuel Stampfl on 24.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateNavigationControllerAndTopControllerWithIdentifier<T>(identifier: String) -> (UINavigationController, T)? {
        if let navigation = self.instantiateViewControllerWithIdentifier(identifier) as? UINavigationController {
            if let subView = navigation.topViewController as? T {
                return (navigation, subView)
            }
        }
        return nil
    }
}
