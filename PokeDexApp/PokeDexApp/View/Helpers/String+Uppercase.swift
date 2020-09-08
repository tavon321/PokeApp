//
//  String+Uppercase.swift
//  PokeDexApp
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
}
