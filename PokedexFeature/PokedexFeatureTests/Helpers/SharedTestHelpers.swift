//
//  SharedTestHelpers.swift
//  PokedexFeatureTests
//
//  Created by Gustavo Londono on 9/8/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

var anyURL: URL { return URL(string: "https://a-url.com")! }

var anyError: NSError { return NSError(domain: "any error", code: 0) }

var anyData: Data { return Data("any data".utf8) }
