//
// Created by Marek Mościchowski on 08/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "TestAutoResolver.h"
#import "FakeWebSocket.h"


@implementation TestAutoResolver {

}

- (void)discoverServiceWithCallback:(void (^)(NSNetService *))success failure:(void (^)())failure {
  self.callback = success;
  self.failure = failure;
  self.testServiceName = [[NSUserDefaults standardUserDefaults] stringForKey:@"TestServiceName"];
  self.testServiceType = [[NSUserDefaults standardUserDefaults] stringForKey:@"TestServiceType"];
  self.testServiceDomain = [[NSUserDefaults standardUserDefaults] stringForKey:@"TestServiceDomain"];

  self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
  [self.netServiceBrowser setDelegate:self];
  [self.netServiceBrowser searchForServicesOfType:@"_TestIOSServer._tcp." inDomain:@""];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {

  self.service = aNetService;
  if ([self.service.name isEqualToString:self.testServiceName] &&
          [self.service.type isEqualToString:self.testServiceType] &&
          [self.service.domain isEqualToString:self.testServiceDomain]) {
    [self.service setDelegate:self];
    [self.service resolveWithTimeout:10];
    return;
  }
  if(!moreComing){
    self.failure();
  }
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
  self.callback(sender);
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{

}

- (void)dealloc{

}

@end