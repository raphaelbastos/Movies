//
//  Genre.swift
//  Movies
//
//  Created by Yves Bastos on 09/07/2018.
//  Copyright © 2018 Yves Bastos. All rights reserved.
//

import ObjectMapper

class Genre: Mappable {
    var id: Int?
    var name: String?
    
    init() { }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
    }
}

