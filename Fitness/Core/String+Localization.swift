//
//  String+Localization.swift
//  Fitness
//
//  Created by Manuel Stampfl on 11.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
