//
// Created by Marek Mościchowski on 05/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@class TestAutoResolver;
@class ResolveTestServerViewController;

@protocol FakeWebSocketDelegate

- (void)locateFakeBeacon;

@end

@interface FakeWebSocket : NSObject <SRWebSocketDelegate, NSNetServiceBrowserDelegate, NSStreamDelegate, NSStreamDelegate, NSNetServiceDelegate>

@property (nonatomic, weak) id <FakeWebSocketDelegate> delegate;

@property(nonatomic, strong) NSNetServiceBrowser *netServiceBrowser;

@property(nonatomic, strong) NSNetService *netService;
@property(nonatomic, assign) Method applicationMethod;
@property(nonatomic, strong) UIWindow *fakeWindow;
@property(nonatomic, strong) SRWebSocket *webSocket;

@property(nonatomic, strong) TestAutoResolver *testAutoResolver;

@property(nonatomic, strong) ResolveTestServerViewController *controller;

+ (instancetype)fakeManager;

- (void)start;

- (void)launchWebSocketsForService:(NSNetService *)service;

@end