//
//  AppDelegate.m
//  Firebase_PushNotification_ObjectiveC
//
//  Created by Mohit Gorakhiya on 11/28/17.
//  Copyright © 2017 Mohit Gorakhiya. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize pushToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max)
    {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        if(@available(iOS 10.0, *))
        {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
        }
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        
#endif
    }
    [application registerForRemoteNotifications];
    
    if ([FIRMessaging messaging].FCMToken != nil)
    {
        self.pushToken = [FIRMessaging messaging].FCMToken;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Errro in Registration :%@",error.description);
}
- (void)application:(UIApplication* )app didRegisterForRemoteNotificationsWithDeviceToken:(NSData* )deviceToken
{
    //    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"content---%@", token);
    
    //    self.deviceToken = token;
    //    if (self.deviceToken == nil) {
    //        self.deviceToken=@"";
    //    }
    [FIRMessaging messaging].APNSToken = deviceToken;
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"didReceiveRemoteNotification");
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    //NSLog(@" Notification %@",userInfo);
    if(application.applicationState == UIApplicationStateActive)
    {
        //    NSLog(@" UIApplicationStateActive %@",userInfo);
        //app is currently active, can update badges count here
    }
    else if(application.applicationState == UIApplicationStateBackground)
    {
        //  NSLog(@" UIApplicationStateBackground %@",userInfo);
        //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
        
    }
    else if(application.applicationState == UIApplicationStateInactive)
    {
        //    NSLog(@" UIApplicationStateInactive %@",userInfo);
        //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    // When Notification will arrives, this method will be called
    if (@available(iOS 10.0, *))
    {
        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    }
    else
    {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *))
    {
        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    }
    else
    {
        // Fallback on earlier versions
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    // Click on the notification it will redirect here
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}


- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken
{
    // This method will be called first time when Push Registration finish and Token Arrives
    // This method will not call every time app opens, it will only call when Push Token Refreshed
    NSLog(@"FCM registration token: %@", fcmToken);
    self.pushToken = fcmToken;
}
@end
