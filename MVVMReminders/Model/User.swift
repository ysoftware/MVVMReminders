//
//  User.swift
//  MVVMReminders
//
//  Created by ysoftware on 10.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import AuthController

final class User:AuthControllerUser, Codable {

	var id: String = ""

	var email:String = ""
	
	var isProfileComplete:Bool {
		return true
	}
}
