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
    
	///key to enable and disable password in userDefaults
    static var passStatusKey = "password"
    
	var window: UIWindow?
	private let builder = Builder()
	private lazy var cootdinator = Coordinator(builder: builder)
	
	 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		 guard let window = window else { return false }
		 cootdinator.start(window: window)
		 
		 //запрос у пользователя на отправку локал нотификейшн
		 let notificationCenter = UNUserNotificationCenter.current()
		 notificationCenter.delegate = self
		 LocalNotificationRequest.shared.requestAuthorization(notificationCenter: notificationCenter)
		 return true
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		print("applicationWillEnterForeground")
		}
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
			return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
	}

	// MARK: - Core Data stack

lazy var persistentContainer: NSPersistentContainer = {
	    let container = NSPersistentContainer(name: "ToDo")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
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
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
}



//MARK: NOTIFICATION EXTENSION
extension AppDelegate: UNUserNotificationCenterDelegate {

	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		
			completionHandler([.sound, .banner])
		
		if Counter.count == 0 {
			NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none) //real time table refresh
		} else { return }
		Counter.count += 1
		print(#function)
		DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
			Counter.count = 0
		}
	}
	
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		NotificationCenter.default.post(name: Notification.Name("TableViewReloadData"), object: .none) //real time table refresh
		print("тут можно что-нибудь сделать когда пользователь нажимает на уведомление")
		//сделать юай алерт с кейсами: выполненно, отсрочка на...
	}
}
