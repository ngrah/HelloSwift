//
//  bridging_header.m
//  helloSwift
//
//  Created by Nick Grah on 10/13/17.
//  Copyright © 2017 Nick Grah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>

// Initialize the Amazon Cognito credentials provider

let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
                                                        identityPoolId:"us-east-2:8f6255e6-02ed-499d-a52b-ef7e66208317")

let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)

AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

// Initialize the Cognito Sync client
let syncClient = AWSCognito.defaultCognito()

// Create a record in a dataset and synchronize with the server
var dataset = syncClient.openOrCreateDataset("myDataset")
dataset.setString("myValue", forKey:"myKey")
dataset.synchronize().continueWithBlock {(task: AWSTask!) -> AnyObject! in
    // Your handler code here
    return nil
    
}
