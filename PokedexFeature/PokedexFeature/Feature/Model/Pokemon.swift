//
//  Pokemon.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public struct Pokemon: Hashable {
    public var name: String
    public var url: URL
    
    public init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
