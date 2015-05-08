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
    [self.netServiceBrowser searchForServicesOfType:@"_TestIOSServer._tcp." inDomain:@""];
    
    NSString *urlString = @"ws://192.168.1.156:8001";
    self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    self.webSocket.delegate = self;
    [self.webSocket open];
  }

  return self;
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
  NSLog(@"aNetService = %@", aNetService.name);

  NSInputStream  * inStream;
  NSOutputStream * outStream;
  [aNetService getInputStream:&inStream
             outputStream:&outStream]; // See Technical Q&A QA1546
  inStream.delegate = self;
  outStream.delegate = self;
  [inStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                      forMode:NSDefaultRunLoopMode];
  [outStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
  [inStream open];
  [outStream open];

  NSData *data = [@"Test stream" dataUsingEncoding:NSUTF8StringEncoding];
  uint32_t length = (uint32_t)htonl([data length]);
  [outStream write:[data bytes] maxLength:length];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
  [self.delegate locateFakeBeacon];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{

  NSLog(@"aStream = %@", aStream);
}


@end