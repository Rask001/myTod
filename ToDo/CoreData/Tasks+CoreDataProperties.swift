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
	  @NSManaged public var taskDate: String?
	  @NSManaged public var taskDateDate: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var alarmImage: Bool
	  @NSManaged public var repeatImage: Bool
    @NSManaged public var check: Bool
	  @NSManaged public var timeInterval: String?
  	@NSManaged public var type: String
}

extension Tasks : Identifiable {
}
