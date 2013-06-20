//
//  MDURLConnection.m
//  Mingdao
//
//  Created by Wee Tom on 13-4-26.
//
//

#import "MDURLConnection.h"

@interface MDURLConnection () <NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSURLRequest *req;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *appendingData;
@property (copy,   nonatomic) MDAPINSDataHandler handler;
@property (assign, nonatomic) long long totalLength, currentLength;
@end

@implementation MDURLConnection
- (MDURLConnection *)initWithRequest:(NSURLRequest *)request handler:(MDAPINSDataHandler)handler
{
    self = [super init];
    if (self) {
        self.req = request;
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        self.handler = handler;
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.totalLength = [response expectedContentLength];
    self.currentLength = 0;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.handler(nil, error);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.currentLength += [data length];
    if (self.downloadProgressHandler) {
        self.downloadProgressHandler(self.currentLength/(float)self.totalLength);
    }
    [self.appendingData appendData:data];
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
                                                 totalBytesWritten:(NSInteger)totalBytesWritten
                                         totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.uploadProgressHandler) {
        float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
        float total = [[NSNumber numberWithInteger: totalBytesExpectedToWrite] floatValue];
        self.uploadProgressHandler(progress/total);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.handler(self.appendingData, nil);
}

- (void)start
{
    if (self.connection) {
        NSLog(@"%@", [self.req.URL absoluteString]);
        self.appendingData = [NSMutableData data];
        [self.connection start];
    }
}

- (void)cancel
{
    if (self.connection) {
        [self.connection cancel];
        self.handler = nil;
        self.connection = nil;
        self.appendingData = nil;
    }
}
@end
