//
// Created by Marek Mościchowski on 08/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "AppDelegate+TestTarget.h"
#import "FakeWebSocket.h"

@implementation AppDelegate (TestTarget)

+ (void)load{
  [FakeWebSocket fakeManager];
}

@end