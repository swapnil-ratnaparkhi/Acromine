//
//  WebService.h
//  Acromine
//
//  Created by Swapnil Ratnaparkhi on 2016-03-09.
//  Copyright © 2016 Swapnil Ratnaparkhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebService : NSObject

+ (WebService *)shared;
- (void)acronymInformation:(NSString*) searchAcroym
                successHandler:(void (^)(NSArray* results))successHandler
                 failureHandler:(void (^)(NSError *internalError))failureHandler;


@end
