//
//  DetailViewController.h
//  Acromine
//
//  Created by Swapnil Ratnaparkhi on 2016-03-10.
//  Copyright © 2016 Swapnil Ratnaparkhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *acronymsArray;
@property (nonatomic, strong) NSString *acroymnDetailName;
@property (nonatomic, strong) NSString *acroymnFrequency;
@property (nonatomic, strong) NSString *acroymnYear;

@end
