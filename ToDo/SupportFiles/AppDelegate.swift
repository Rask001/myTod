//
//  AppDelegate.swift
//  ToDo
//
//  Created by Антон on 26.03.2022.
//
 
import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	//weak var delegate: ReloadTableViewDelegate?
	var window: UIWindow?
	private let assembly = Assembly()
	private lazy var cootdinator = Coordinator(assembly: assembly)
	//let notificationCenter = UNUserNotificationCenter.current()
	
	 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		 guard let window = window else { return false }
		 cootdinator.start(window: window)
//		 window?.rootViewController = Main()
//		 window?.makeKeyAndVisible()
		 //запрос у пользователя на отправку локал нотификейшн
		 let notificationCenter = UNUserNotificationCenter.current()
		 notificationCenter.delegate = self
		 LocalNotificationRequest.shared.requestAuthorization(notificationCenter: notificationCenter)
		 return true
	 }
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
			return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
	}

	// MARK: - Core Data stack

lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "ToDo")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	
	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
}


//MARK: NOTIFICATION EXTENSION
extension AppDelegate: UNUserNotificationCenterDelegate {
//	func tableViewReload() {
//		if let delegate = delegate {
//			delegate.tableViewReload()
//			print("lol")
//		}
//	}
//

	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.sound, .banner])
		print("уведомление в то время как приложение открыто")
		 
		//deleg()
		//		weak var view: Main?
//		DispatchQueue.main.async {
//			view?.viewModel.reloadTable()
//		}
	NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none) //real time table refresh
		
	}
//	func deleg() {
//		DispatchQueue.global(qos: .userInteractive).async {
//			print("11")
//			self.delegate?.tableViewReload()
//		}
//	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none) //real time table refresh
		print("тут можно что-нибудь сделать когда пользователь нажимает на уведомление")
		//сделать юай алерт с кейсами: выполненно, отсрочка на...
	}
}

//protocol ReloadTableViewDelegate: AnyObject {
//	func tableViewReload()
//}
