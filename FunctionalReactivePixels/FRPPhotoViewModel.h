//
//  FRPPhotoViewModel.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 6/5/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class FRPPhotoModel;

@interface FRPPhotoViewModel : RVMViewModel

@property (nonatomic, readonly) FRPPhotoModel *model;

@property (nonatomic, readonly) UIImage *photoImage;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;

- (NSString *)photoName;

@end
