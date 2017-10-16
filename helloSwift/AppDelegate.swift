//
//  AppDelegate.swift
//  helloSwift
//
//  Created by Nick Grah on 10/13/17.
//  Copyright © 2017 Nick Grah. All rights reserved.
//

import UIKit
import AWSCore
import AWSCognito
import AWSS3
import AWSCognitoIdentityProvider



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
       
       
        // setup service configuration
        let CognitoIdentityUserPoolRegion: AWSRegionType = .USEast2
        
        let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
        
        let AWSCognitoUserPoolsSignInProviderKey = "UserPool"
        
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(
            clientId: "4103usiq281ti7e7453tmtt42b",
            clientSecret: "1898q5jv3dnhit3tcj1ku8ss9ihq7m47vtrpl44q776qvq3346k2",
            poolId: "us-east-2_sInIjuon4")
        
    
        // initialize user pool client
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        // fetch the user pool client we initialized in above step
        let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
       // self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        pool.delegate = self
        
        
        
        
        /*
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
                                                                identityPoolId:"us-east-2_IPFBn3CPp")
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        let cognitoId = credentialsProvider.identityId
        // Initialize the Cognito Sync client
        let syncClient = AWSCognito.default()
        let dataset = syncClient.openOrCreateDataset("user_data")
        dataset.setString("testUser", forKey:"username")
        dataset.setString("testPass", forKey:"password")
        dataset.synchronize().continueWith {(task) -> AnyObject! in
            
            if task.isCancelled {
                // Task cancelled.
            } else if task.error != nil {
                // Error while executing task
            } else {
                // Task succeeded. The data was saved in the sync store.
            }
            return nil
        }
        */
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //  Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler:@escaping () -> Void) {
        // Store the completion handler.
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }

}


extension AppDelegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
}




