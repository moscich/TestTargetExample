//
// Created by Marek Mościchowski on 08/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestAutoResolver : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate>
@property(nonatomic, strong) NSNetServiceBrowser *netServiceBrowser;
@property(nonatomic, copy) NSString *testServiceName;
@property(nonatomic, copy) NSString *testServiceType;
@property(nonatomic, copy) NSString *testServiceDomain;
@property(nonatomic, copy) void (^callback)(NSNetService *);

@property(nonatomic, copy) void (^failure)();

@property(nonatomic, strong) NSNetService *service;

- (void)discoverServiceWithCallback:(void (^)(NSNetService *))success failure:(void (^)())failure;
@end