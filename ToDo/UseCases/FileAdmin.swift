//
//  FileAdmin.swift
//  ToDo
//
//  Created by Антон on 20.09.2022.
//

import Foundation

class FileAdmin {
	
	class func createFolder(name: String) {
		let manager = FileManager.default
		guard let url = manager.urls(for: .documentDirectory,
																 in: .userDomainMask).first else { return }
		let newFolderUrl = url.appendingPathComponent(name)
		do {
			try manager.createDirectory(at: newFolderUrl,
															withIntermediateDirectories: true,
															attributes: [:])
		} catch {
			print(error.localizedDescription)
		}
	}
	
	class func getFolderURL(name: String) -> URL? {
		let manager = FileManager.default
		guard let url = manager.urls(for: .documentDirectory,
																 in: .userDomainMask).first else { return nil }
		let newFolderUrl = url.appendingPathComponent(name)
		return newFolderUrl
	}
	
	class func deleteFolder(name: String) {
		let manager = FileManager.default
		guard let url = manager.urls(for: .documentDirectory,
																 in: .userDomainMask).first else { return }
		let fileURL = url.appendingPathComponent(name)
		if manager.fileExists(atPath: fileURL.path) {
			do {
				try manager.removeItem(at: fileURL)
				print("file\(name) is removed")
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
	class func createFile(nameFolder: String, name: String, contents: Data?) -> URL? {
		let manager = FileManager.default
		guard let url = manager.urls(for: .documentDirectory,
																 in: .userDomainMask).first else { return nil }
		//Дата заполняться примеро так
		//let data = "my text data. Inside file".data(using: .utf8)
		let newFolderUrl = url.appendingPathComponent(nameFolder)
		let fileURL = newFolderUrl.appendingPathComponent(name)
			
		manager.createFile(atPath: fileURL.path,
												 contents: contents,
												 attributes: [FileAttributeKey.creationDate : Date()])
		return fileURL
	}
	
	class func getFileUrl(nameFolder: String, name: String) -> URL? {
		let manager = FileManager.default
		guard let url = manager.urls(for: .documentDirectory,
																 in: .userDomainMask).first else { return nil }
		let newFolderUrl = url.appendingPathComponent(nameFolder)
		let fileURL = newFolderUrl.appendingPathComponent(name)
		return fileURL
	}
	
	
	class func deleteFile(name: String, fromFolder: String) {
		let manager = FileManager.default
		guard let url = manager.urls(for: .documentDirectory,
																 in: .userDomainMask).first else { return }
		let folderURL = url.appendingPathComponent(fromFolder)
		let fileURL = folderURL.appendingPathComponent(name)
		if manager.fileExists(atPath: fileURL.path) {
			do {
				try manager.removeItem(at: fileURL)
				print("file\(name) is removed")
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}
