//
//  FRPPhotoViewController.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 5/29/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPPhotoViewModel;
@class FRPPhotoModel;

@interface FRPPhotoViewController : UIViewController

- (instancetype)initWithViewModel:(FRPPhotoViewModel *)viewModel index:(NSInteger)photoIndex;

@property (nonatomic, readonly) NSInteger photoIndex;
@property (nonatomic, readonly) FRPPhotoModel *photoModel;

@end
