//
//  FRPGalleryViewModel.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 6/5/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPGalleryViewModel.h"

//Utilities
#import "FRPPhotoImporter.h"

@interface FRPGalleryViewModel ()

@end

@implementation FRPGalleryViewModel

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    RAC(self, model) = [self importPhotosSignal];

    return self;
}

- (RACSignal *)importPhotosSignal {
    return [[[FRPPhotoImporter importPhotos] logError] catchTo:[RACSignal empty]];
}

@end
