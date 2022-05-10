//
//  Tasks+CoreDataProperties.swift
//  ToDo
//
//  Created by Антон on 27.03.2022.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var taskTitle: String
    @NSManaged public var taskTime: String?
    @NSManaged public var timeLabelDate: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var alarmImage: Bool
    @NSManaged public var check: Bool
    @NSManaged public var repeatImage: Bool

}

extension Tasks : Identifiable {
}
