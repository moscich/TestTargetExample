//
//  AppDelegate.m
//  TestTargetExample
//
//  Created by Marek Mościchowski on 08/05/15.
//  Copyright (c) 2015 Miquido. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"Normal App delegate");
  self.manager = [[CLLocationManager alloc] init];
  self.manager.delegate = self;
  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"87654321-1234-4321-0987-098765432109"];
  CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.miquido.Protuction-Target"];
  [self.manager requestAlwaysAuthorization];
  [self.manager startRangingBeaconsInRegion:beaconRegion];
  return YES;
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  NSLog(@"beacons = %@", beacons);
}

@end
