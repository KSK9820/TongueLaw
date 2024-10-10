//
//  FavoriteContent.swift
//  TongueLaw
//
//  Created by 김수경 on 10/9/24.
//

import Foundation

struct FavoriteContent {
    
    let id: String
    let title: String?
    let image: Data?
    
    init(id: String, title: String?, image: Data?) {
        self.id = id
        self.title = title
        self.image = image
    }
    
    init(entity: FavoriteEntity) {
        self.id = entity.id
        self.title = entity.title
        self.image = entity.image
    }
    
}
