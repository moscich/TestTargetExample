//
// Created by Marek Mościchowski on 08/05/15.
// Copyright (c) 2015 Miquido. All rights reserved.
//

#import "ResolveTestServerViewController.h"

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

- (id)initWithSuccess:(void (^)(NSNetService *))success {
  self = [super init];
  if (self) {
    self.success = success;
  }

  return self;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
  [self addToDiscoveredIfNotExistAlready:aNetService];
  if (!moreComing) {
    [self.tableView reloadData];
  }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
  int index = [self indexOfService:aNetService];
  if(index != NSNotFound)
    [self.discoveredServices removeObject:aNetService];
  if (!moreComing) {
    [self.tableView reloadData];
  }
}

- (void)addToDiscoveredIfNotExistAlready:(NSNetService *)newService {
  if (![self indexOfService:newService] != NSNotFound) {
    [self.discoveredServices addObject:newService];
  }
}

- (int)indexOfService:(NSNetService *)newService {
  for (int i = 0; i < self.discoveredServices.count; i++) {
    NSNetService *service = self.discoveredServices[(NSUInteger) i];
    if ([service.name isEqualToString:newService.name] &&
            [service.type isEqualToString:newService.type] &&
            [service.domain isEqualToString:newService.domain]) {
      return i;
    }
  }
  return NSNotFound;
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
  [[NSUserDefaults standardUserDefaults] setObject:sender.name forKey:@"TestServiceName"];
  [[NSUserDefaults standardUserDefaults] setObject:sender.type forKey:@"TestServiceType"];
  [[NSUserDefaults standardUserDefaults] setObject:sender.domain forKey:@"TestServiceDomain"];

  [[NSUserDefaults standardUserDefaults] synchronize];

  [self.netServiceBrowser stop];

  self.success(sender);
}

@end