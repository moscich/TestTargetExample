//
// Created by Marek Mościchowski on 05/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

@protocol FakeWebSocketDelegate

- (void)locateFakeBeacon;

@end

@interface FakeWebSocket : NSObject <SRWebSocketDelegate, NSNetServiceBrowserDelegate>

@property (nonatomic, weak) id <FakeWebSocketDelegate> delegate;

@property(nonatomic, strong) NSNetServiceBrowser *netServiceBrowser;

+ (instancetype)fakeManager;
@end