//
// Created by Marek Mościchowski on 05/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "FakeWebSocket.h"
#import "TestAutoResolver.h"
#import "ResolveTestServerViewController.h"
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

- (void)start{
  self.testAutoResolver = [TestAutoResolver new];
  void (^success)(NSNetService *) = ^(NSNetService *service) {
      [self launchWebSocketsForService:service];
  };
  [self.testAutoResolver discoverServiceWithCallback:success failure:^{
      [self askUserForTestService:success];
  }];
}

- (void)askUserForTestService:(void (^)(NSNetService *))success {
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  self.controller = [[ResolveTestServerViewController alloc] initWithSuccess:success];
  self.controller.view.frame = window.bounds;
  [window addSubview:self.controller.view];
}

- (void)launchWebSocketsForService:(NSNetService *)service {
  [self.controller.view removeFromSuperview];
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

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{

}

@end