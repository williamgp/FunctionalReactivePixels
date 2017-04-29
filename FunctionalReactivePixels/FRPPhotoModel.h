//
//  FRPPhotoModel.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 29/04/2017.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRPPhotoModel : NSObject

@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, strong) NSString *photographerName;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *fullsizedURL;

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSNumber *rating;

@property (nonatomic, strong) NSData *thumbnailData;
@property (nonatomic, strong) NSData *fullsizedData;

@end
