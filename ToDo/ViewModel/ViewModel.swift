//
//  ViewModel.swift
//  ToDo
//
//  Created by Антон on 10.07.2022.
//
import CoreData
import Foundation
import UIKit


//class ViewModel: TableViewViewModelType {
//	
//	
//	func numbersOfRows() -> Int {
//		return CoreDataMethods.shared.coreDataModel.count
//	}
//	
//	func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
////		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////		let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
////		let model = Tasks(entity: entity!, insertInto: context)
//		var mod: [Tasks] = []
//		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//		let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
//		do{
//			 mod = try context.fetch(fetchRequest)
//		} catch let error as NSError {
//			print(error.localizedDescription)
//		}
//		let model = mod[indexPath.row]
//	
//		return TableViewCellViewModel(model: model)
//	}
//}
