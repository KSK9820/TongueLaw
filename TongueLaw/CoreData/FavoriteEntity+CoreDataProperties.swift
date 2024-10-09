//
//  FavoriteEntity+CoreDataProperties.swift
//  TongueLaw
//
//  Created by 김수경 on 10/9/24.
//
//

import Foundation
import CoreData


extension FavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
        return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var image: Data?
    @NSManaged public var title: String?

}

extension FavoriteEntity : Identifiable {

}
