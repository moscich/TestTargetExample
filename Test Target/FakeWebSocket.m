//
// Created by Marek Mościchowski on 05/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "FakeWebSocket.h"

@interface FakeWebSocket ()

@property(nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation FakeWebSocket {

}

+ (instancetype)fakeManager {
  static FakeWebSocket *fakeWebSocket = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
      fakeWebSocket = [[self alloc] init];
  });
  return fakeWebSocket;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

- (instancetype)init {
  self = [super init];
  if (self) {

    self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
    [self.netServiceBrowser setDelegate:self];
    [self.netServiceBrowser searchForServicesOfType:@"_http._tcp." inDomain:@""];
    
    NSString *urlString = @"ws://192.168.1.156:8001";
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    self.webSocket.delegate = self;
    [self.webSocket open];
  }

  return self;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
  NSLog(@"aNetService = %@", aNetService.name);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  [self.delegate locateFakeBeacon];
}

@end