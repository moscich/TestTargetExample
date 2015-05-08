//
// Created by Marek Mościchowski on 08/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "ResolveTestServerViewController.h"
#import "FakeWebSocket.h"

@interface ResolveTestServerViewController ()

@property(nonatomic, strong) NSMutableArray *discoveredServices;

@end

@implementation ResolveTestServerViewController {

}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.discoveredServices = [NSMutableArray new];

  self.tableView = [UITableView new];
  self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.view addSubview:self.tableView];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(40)-[_tableView]-(40)-|" options:nil metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_tableView]-|" options:nil metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
  self.view.backgroundColor = [UIColor greenColor];

  self.netServiceBrowser = [[NSNetServiceBrowser alloc] init];
  [self.netServiceBrowser setDelegate:self];
  [self.netServiceBrowser searchForServicesOfType:@"_TestIOSServer._tcp." inDomain:@""];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
  [self addToDiscoveredIfNotExistAlready:aNetService];
  if (!moreComing) {
    [self.tableView reloadData];
  }
}

- (void)addToDiscoveredIfNotExistAlready:(NSNetService *)newService {
  BOOL exists = NO;
  for (NSNetService *service in self.discoveredServices) {
    if ([service.name isEqualToString:newService.name] &&
            [service.type isEqualToString:newService.type] &&
            [service.domain isEqualToString:newService.domain]) {
      exists = YES;
    }
  }
  if (!exists) {
    [self.discoveredServices addObject:newService];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.discoveredServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [UITableViewCell new];
  cell.textLabel.text = ((NSNetService *) self.discoveredServices[(NSUInteger) indexPath.row]).name;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNetService *netService = self.discoveredServices[(NSUInteger) indexPath.row];

  [netService setDelegate:self];
  [netService resolveWithTimeout:1];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
  [[FakeWebSocket fakeManager] launchWebSocketsForService:sender];
}

@end