//
//  AppDelegate.swift
//  MVVMReminders
//
//  Created by ysoftware on 06.07.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Firebase
import FirestoreHelper
import AuthController

let authController = AuthController<User>()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		// Firebase
		FirebaseApp.configure()

		// Firestore
		let settings = FirestoreSettings()
		settings.areTimestampsInSnapshotsEnabled = true
		Firestore.firestore().settings = settings

		// Auth Controller
		let authLogin = WindowLoginPresenter() {
			return UIStoryboard(name: "Main", bundle: .main)
				.instantiateViewController(withIdentifier: "LoginVC")
		}

		authController.configure(networkService: FirestoreAuthService<User>(),
								 loginPresenter: authLogin,
								 editProfilePresenter: self)

		return true
	}
}

extension AppDelegate: AuthEditProfile {
	func present() { } // no-op
}
