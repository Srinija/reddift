//
//  OAuth2TokenRepository.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public let OAuth2TokenRepositoryDidSaveToken = "OAuth2TokenRepositoryDidSaveToken"

/**
Repository to contain OAuth2 tokens for reddit.com based on "KeychanAccess".
You can manage mulitple accounts using this class.
OAuth2TokenRepository, is utility class, has only class method.
*/
public class OAuth2TokenRepository {
    public class func restoreFromKeychainWithName(name:String) -> Result<OAuth2Token> {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        if let data = keychain.getData(name) {
            if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? OAuth2Token {
                return Result(value:token)
            }
        }
        return Result(error:ReddiftError.TokenNotfound.error)
    }
    
    public class func savedNamesInKeychain() -> [String] {
        var keys:[String] = []
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }
    
    public class func saveIntoKeychainToken(token:OAuth2Token) {
        if count(token.name) > 0 {
            // save
            if let data = token.json() {
                let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
                keychain.set(data, key:token.name)
                NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil)
            }
        }
        else {
            println("Error:name property is empty.")
        }
    }
    
    public class func saveIntoKeychainToken(token:OAuth2Token, name:String) {
        if count(name) > 0 {
            // save
            if let data = token.json() {
                let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
                keychain.set(data, key:name)
                NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil);
            }
        }
        else {
            println("Error:name property is empty.")
        }
    }
    
    public class func removeFromKeychainTokenWithName(name:String) {
        if count(name) > 0 {
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            keychain.remove(name);
        }
        else {
            println("Error:name property is empty.")
        }
    }
}
