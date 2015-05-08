//
// Created by Marek Mościchowski on 08/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResolveTestServerViewController : UIViewController <UITableViewDataSource, NSNetServiceBrowserDelegate, UITableViewDelegate, NSNetServiceDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSNetServiceBrowser *netServiceBrowser;

@property(nonatomic, copy) void (^success)(NSNetService *);

- (id)initWithSuccess:(void (^)(NSNetService *))pFunction;
@end