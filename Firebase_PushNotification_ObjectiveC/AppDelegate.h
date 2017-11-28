//
//  AppDelegate.h
//  Firebase_PushNotification_ObjectiveC
//
//  Created by Mohit Gorakhiya on 11/28/17.
//  Copyright © 2017 Mohit Gorakhiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) NSString *pushToken;

@end

