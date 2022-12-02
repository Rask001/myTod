//
//  KeychainManager.swift
//  ToDo
//
//  Created by Антон on 30.11.2022.
//

import Foundation

final class KeychainManager {
    static var shared = KeychainManager()
    private enum KeychainError: Error {
        case noPassword
        case emptyFields
        case unexpectedPasswordData
        case duplicateEntry
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
}

extension KeychainManager {
    
    @inlinable
    func saveAccount(service: String,
                     account: String,
                     password: String) throws {
        
        guard password != "",
              account != "",
              service != "" else {
            throw KeychainError.emptyFields
        }
        guard let passwordData = password.data(using: .utf8) else { throw
            KeychainError.unexpectedPasswordData
        }
        
        //словарь служащий запросом к функции SecItemAdd
        var query = keychainQuery(withService: service, account: account)
        query[kSecValueData as String] = passwordData as AnyObject
        
        //добавляет один или несколько элементов в связку ключей
        let status = SecItemAdd(query as CFDictionary, nil)
        //проверка на дубликаты логина
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        print("account \(account) saved")
    }
    
    @inlinable
    func getPassword(service: String,
                     account: String) throws -> String? {
        //проверяем на пустые значения
        guard account != "",
              service != "" else {
            throw KeychainError.emptyFields
        }
        
        var query = keychainQuery(withService: service, account: account)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var dataPass: AnyObject?
        //находим пароль
        let _ = SecItemCopyMatching(query as CFDictionary, &dataPass)
        //преобразуем в дату
        guard let res = dataPass as? Data else {
            throw KeychainError.unexpectedPasswordData
        }
        //преобразуем в строку
        let stringPass = String(decoding: res, as: UTF8.self)
        return stringPass
    }
    
    @inlinable
    func deleteAccount(service: String,
                       account: String,
                       accessGroup: String? = nil) {
        // Delete the existing item from the keychain.
        
        let query = keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        print("account \(account) has been deleted")
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else {
            print(KeychainError.unhandledError(status: status)); return
        }
    }
    
    @inlinable
    func renameAccount(oldAccountName: String,
                       newAccountName: String,
                       service: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String: AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        
        let query = keychainQuery(withService: service,
                                  account: oldAccountName)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
         print("The \(oldAccountName) account has been renamed to \(newAccountName)")
        // Throw an error if an unexpected status was returned.
        
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    @inlinable
    func savePassword(password: String,
                      service: String,
                      account: String) throws {
       // Encode the password into an Data object.
       let encodedPassword = password.data(using: String.Encoding.utf8)!
       
       do {
           // Check for an existing item in the keychain.
           try _ = getPassword(service: service, account: account)
           
           // Update the existing item with the new password.
           var attributesToUpdate = [String: AnyObject]()
           attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
           
           let query = keychainQuery(withService: service, account: account)
           let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
           print("the password has been changed")
           // Throw an error if an unexpected status was returned.
           guard status == noErr else { throw KeychainError.unhandledError(status: status) }
       } catch KeychainError.noPassword {
           /*
            No password was found in the keychain. Create a dictionary to save
            as a new keychain item.
            */
           var newItem = keychainQuery(withService: service,
                                                            account: account)
           newItem[kSecValueData as String] = encodedPassword as AnyObject?
           
           // Add a the new item to the keychain.
           let status = SecItemAdd(newItem as CFDictionary, nil)
           // Throw an error if an unexpected status was returned.
           guard status == noErr else { throw KeychainError.unhandledError(status: status) }
       }
   }
}
    
    
    
    
    
// MARK: Convenience
extension KeychainManager {
    private func keychainQuery(withService service: String,
                               account: String? = nil,
                               accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }
}
