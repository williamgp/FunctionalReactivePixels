//
//  FRPFullSizePhotoViewModel.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 6/5/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPFullSizePhotoViewModel.h"

//Model
#import "FRPPhotoModel.h"

@interface FRPFullSizePhotoViewModel ()

//Private access
@property (nonatomic, assign) NSInteger initialPhotoIndex;

@end

@implementation FRPFullSizePhotoViewModel

- (instancetype)initWithPhotoArray:(NSArray *)photoArray initialPhotoIndex:(NSInteger)initialPhotoIndex {
    
    self = [self initWithModel:photoArray];
    if (!self) return nil;
    
    self.initialPhotoIndex = initialPhotoIndex;
    
    return self;
}

- (NSString *)initialPhotoName {
    FRPPhotoModel *photoModel = [self initialPhotoModel];
    return [photoModel photoName];
}

- (FRPPhotoModel *)initialPhotoModel {
    return [self photoModelAtIndex:_initialPhotoIndex];
}

- (FRPPhotoModel *)photoModelAtIndex:(NSInteger)index {
    if (index < 0 || index > self.model.count - 1) {
        //Index was out of bounds return nil
        return nil;
    } else {
        return self.model[index];
    }
}

@end
