//
//  FRPPhotoViewController.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 5/29/17.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPPhotoViewController.h"
#import "FRPPhotoViewModel.h"

//Model
#import "FRPPhotoModel.h"

//Utilities
#import "FRPPhotoImporter.h"
#import <SVProgressHUD.h>

@interface FRPPhotoViewController ()

//Private assignment
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) FRPPhotoModel *photoModel;

//Private properties
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) FRPPhotoViewModel *viewModel;

@end

@implementation FRPPhotoViewController

- (instancetype)initWithViewModel:(FRPPhotoViewModel *)viewModel index:(NSInteger)photoIndex {
    self = [self init];
    if (!self) return nil;
    
    _viewModel = viewModel;
    _photoIndex = photoIndex;
    
    return self;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.viewModel.active = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Configure selfs view
    self.view.backgroundColor = [UIColor blackColor];

    //Configure subviews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    RAC(imageView, image) = RACObserve(self.viewModel, photoImage);
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber *loading) {
        if (loading.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSURLRequest *)photoURLRequest:(FRPPhotoModel *)photoModel {
    return [[PXRequest apiHelper] urlRequestForPhotoID:photoModel.identifier.integerValue];
}

@end
