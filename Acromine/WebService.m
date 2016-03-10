//
//  WebService.m
//  Acromine
//
//  Created by Swapnil Ratnaparkhi on 2016-03-09.
//  Copyright © 2016 Swapnil Ratnaparkhi. All rights reserved.
//

#import "WebService.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"

@interface WebService ()
@property (nonatomic, retain) AFHTTPSessionManager *afSessionManager;
@end

@implementation WebService

static NSString *BASE_URL = @"http://www.nactem.ac.uk/software/acromine/";


+ (WebService *)shared {
    static WebService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)acronymInformation:(NSString*) searchAcroym
            successHandler:(void (^)(NSArray* results))successHandler
            failureHandler:(void (^)(NSError *internalError))failureHandler {
        self.afSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: BASE_URL]];
        self.afSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.afSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain"]];
        NSDictionary *parameters = @{@"sf": searchAcroym, @"lf": @""};
    
        [self.afSessionManager GET:@"dictionary.py" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if(((NSArray*)responseObject).count > 0) {
                NSDictionary *resultsDictionary = [[NSDictionary alloc]initWithDictionary:responseObject[0]][@"lfs"];
                NSArray *fullForm = [resultsDictionary valueForKey:@"lf"];
                successHandler(fullForm);
            } else {
                successHandler((NSArray*)responseObject);
            }
    
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureHandler(error);
        }];

}



@end
