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
//@property (nonatomic, strong) RACDisposable *subscription;

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

//Abstracting
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    
//    [self.subscription dispose], self.subscription = nil;
//}

//Abstracting
//-(void)setPhotoModel:(FRPPhotoModel *)photoModel {
//    
//    //because of this subscriptoin, thumbnailData can be set later, and the cells imageView will update automatically
//    self.subscription = [[[RACObserve(photoModel, thumbnailData) filter:^BOOL(id value) {
//        return value != nil;
//    }] map:^id(id value) {  //Ideally you would catch these images if they are large images (otherwise can have peformance here with the mapping data to UIImage)
//        
//        return [UIImage imageWithData:value];
//    }] setKeyPath:@keypath(self.imageView, image)
//                         onObject:self.imageView];
//}


@end
