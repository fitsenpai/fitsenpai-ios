//
//  DeviceUUID.swift
//  FitSenpai
//
//  Created by Mark Daquis on 4/17/25.
//

import Foundation
import Security

class DeviceUUID {
    static let key = "com.yourapp.deviceUUID"

    static func get() -> String {
        if let uuid = KeychainHelper.shared.read(key: key) {
            return uuid
        } else {
            let newUUID = UUID().uuidString
            KeychainHelper.shared.save(key: key, value: newUUID)
            return newUUID
        }
    }
    
    static func getUUID() -> UUID? {
        return UUID(uuidString: get())
    }
}

class KeychainHelper {

    static let shared = KeychainHelper()
    private init() {}

    func save(key: String, value: String) {
        if let data = value.data(using: .utf8) {
            // Delete any existing item
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key
            ] as CFDictionary
            SecItemDelete(query)

            // Add new item
            let attributes = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data
            ] as CFDictionary

            SecItemAdd(attributes, nil)
        }
    }

    func read(key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }

        return nil
    }

    func delete(key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }
}
