//
//  FRPCell.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 5/29/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPCell.h"
#import "FRPPhotoModel.h"

@interface FRPCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation FRPCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    //Configure self
    self.backgroundColor = [UIColor darkGrayColor];
    
    //Configure subviews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    RAC(self.imageView, image) = [[RACObserve(self, photoModel.thumbnailData) ignore:nil] map:^(NSData *data) {
        return [UIImage imageWithData:data];
    }];
    
    return self;
}

@end
