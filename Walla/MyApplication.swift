//
//  MyApplication.swift
//  Walla
//
//  Created by Timothy Choh on 6/25/16.
//  Copyright © 2016 GenieUs. All rights reserved.
//

import UIKit
import SimpleKeychain
import Lock
import LockFacebook

class MyApplication: NSObject {
	
	static let sharedInstance = MyApplication()
	
	let keychain: A0SimpleKeychain
	let lock: A0Lock
	
	private override init() {
		keychain = A0SimpleKeychain(service: "Auth0")
		lock = A0Lock.newLock()
		let facebook = A0FacebookAuthenticator.newAuthenticatorWithDefaultPermissions()
		lock.registerAuthenticators([facebook])
	}
}