//
//  FRPPhotoViewModel.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 6/5/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPPhotoViewModel.h"

//Utilities
#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@interface FRPPhotoViewModel ()

@property (nonatomic, strong) UIImage *photoImage;
@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@implementation FRPPhotoViewModel

- (instancetype)initWithModel:(FRPPhotoModel *)photoModel {
    self = [super initWithModel:photoModel];
    if (!self) return nil;
    
    @weakify(self);
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        @strongify(self);
        [self downloadPhotoModelDetails];
    }];
    
    RAC(self, photoImage) = [RACObserve(self.model, fullsizedData) map:^id(id value) {
        return [UIImage imageWithData:value];
    }];

    return self;
}

- (void)downloadPhotoModelDetails {
    self.loading = YES;
    [[FRPPhotoImporter fetchPhotoDetails:self.model] subscribeError:^(NSError *error) {
        NSLog(@"Could not fetch photo details %@", error);
    } completed:^{
        self.loading = NO;
        NSLog(@"Fetched photo details.");
    }];
}

- (NSString *)photoName {
    return self.model.photoName;
}

@end
