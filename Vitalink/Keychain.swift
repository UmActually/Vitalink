//
//  Keychain.swift
//  Vitalink
//
//  Created by Leonardo Corona Garza on 11/22/23.
//

import Foundation

class Keychain {
    static let serviceName = "Vitalink"
    static let accountName = "BearerToken"

    // Save token to Keychain
    static func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else {
            return
        }

        // Create query for saving to Keychain
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecValueData as String: data
        ] as [String: Any]

        // Delete existing token before saving
        SecItemDelete(query as CFDictionary)

        // Add new token to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Failed to save token to Keychain with status: \(status)")
            return
        }
        print("Token saved to Keychain")
    }

    // Load token from Keychain
    static func loadToken() -> String? {
        // Create query for loading from Keychain
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let tokenData = result as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            print("Failed to load token from Keychain with status: \(status)")
            return nil
        }

        print("Token loaded from Keychain")
        return token
    }

    // Delete token from Keychain
    static func deleteToken() {
        // Create query for deleting from Keychain
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: accountName
        ] as [String: Any]

        // Delete token from Keychain
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            print("Failed to delete token from Keychain with status: \(status)")
            return
        }

        print("Token deleted from Keychain")
    }
}
