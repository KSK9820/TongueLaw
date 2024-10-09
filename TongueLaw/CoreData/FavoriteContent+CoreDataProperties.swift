//
//  FavoriteContent+CoreDataProperties.swift
//  TongueLaw
//
//  Created by 김수경 on 10/9/24.
//
//

import Foundation
import CoreData


extension FavoriteContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteContent> {
        return NSFetchRequest<FavoriteContent>(entityName: "FavoriteContent")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var image: Data?

}

extension FavoriteContent : Identifiable {

}
