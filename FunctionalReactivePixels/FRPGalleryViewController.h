//
//  FRPGalleryViewController.h
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 29/04/2017.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPGalleryViewModel;

@interface FRPGalleryViewController : UICollectionViewController

@property (nonatomic, strong) FRPGalleryViewModel *viewModel;

@end
