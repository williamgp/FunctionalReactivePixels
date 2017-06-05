//
//  FRPFullSizedPhotoViewModel.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 6/5/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class FRPPhotoModel;

@interface FRPFullSizedPhotoViewModel : RVMViewModel

- (instancetype)initWithPhotoArray:(NSArray *)photoArray
                 initialPhotoIndex:(NSInteger)initialPhotoIndex;

- (FRPPhotoModel *)photoModelAtIndex:(NSInteger)index;

@property (nonatomic, readonly, strong) NSArray *model;
@property (nonatomic, readonly) NSInteger initialPhotoIndex;

@property (nonatomic, readonly) NSString *initialPhotoName;

@end
