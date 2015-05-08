//
// Created by Marek Mościchowski on 08/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "AppDelegate+TestTarget.h"
#import "FakeWebSocket.h"
#import "ResolveTestServerViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation AppDelegate (TestTarget)

+ (void)load {
  Method original = class_getInstanceMethod(self, @selector(application:didFinishLaunchingWithOptions:));
  Method custom = class_getInstanceMethod(self, @selector(fakeApplication:didFinishLaunchingWithOptions:));
  [FakeWebSocket fakeManager].applicationMethod = original;
  method_exchangeImplementations(original, custom);
}

- (BOOL)fakeApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  Method original = [FakeWebSocket fakeManager].applicationMethod;
  Method custom = class_getInstanceMethod(self.class, @selector(fakeApplication:didFinishLaunchingWithOptions:));
  method_exchangeImplementations(custom, original);
  BOOL result = [self application:application didFinishLaunchingWithOptions:launchOptions];
  NSLog(@"Fake");

  [FakeWebSocket fakeManager].fakeWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [FakeWebSocket fakeManager].fakeWindow.rootViewController = [ResolveTestServerViewController new];
  [FakeWebSocket fakeManager].fakeWindow.windowLevel = UIWindowLevelAlert;
  [[FakeWebSocket fakeManager].fakeWindow makeKeyAndVisible];
  return result;
}

@end