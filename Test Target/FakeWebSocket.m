//
// Created by Marek Mościchowski on 05/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "FakeWebSocket.h"
#import "SRWebSocket.h"
#include <arpa/inet.h>

@interface FakeWebSocket ()


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

- (void)launchWebSocketsForService:(NSNetService *)service {
  self.fakeWindow = nil;
  NSString *address = [self getStringFromService:service];

  NSString *urlString = [NSString stringWithFormat:@"ws://%@:%d", address, service.port];
  self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
  self.webSocket.delegate = self;
  [self.webSocket open];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
  if (!moreComing) {

    self.netService = aNetService;

    [self.netService setDelegate:self];
    [self.netService resolveWithTimeout:1];
  }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  [self.delegate locateFakeBeacon];
}

- (NSString *)getStringFromService:(NSNetService *)service {

  struct sockaddr_in *socketAddress = nil;
  for(NSData *addressData in service.addresses){
    socketAddress = (struct sockaddr_in *) [addressData bytes];
    NSString *ipString = [NSString stringWithFormat:@"%s",
                                          inet_ntoa(socketAddress->sin_addr)];
    if(![ipString isEqualToString:@"0.0.0.0"]){
      return ipString;
    }

  }

  return nil;
}

@end