//
//  AppDelegate.h
//  TestTargetExample
//
//  Created by Marek Mościchowski on 08/05/15.
//  Copyright (c) 2015 Miquido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;


@property(nonatomic, strong) CLLocationManager *manager;
@end

