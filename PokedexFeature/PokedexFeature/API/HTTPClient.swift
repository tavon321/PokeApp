//
//  HTTPClient.swift
//  PokedexFeature
//
//  Created by Gustavo Londono on 9/7/20.
//  Copyright © 2020 Gustavo Londono. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(response: HTTPURLResponse, data: Data), Error>
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
