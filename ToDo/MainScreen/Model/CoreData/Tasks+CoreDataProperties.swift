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

    @NSManaged public var textTask: String?
    @NSManaged public var timeLabel: String?
    @NSManaged public var timeLabelDate: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var alarmLabel: Bool
    @NSManaged public var completed: Bool
    @NSManaged public var repeatLabel: Bool

}

extension Tasks : Identifiable {

}
