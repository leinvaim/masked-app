//
//  SecondViewController.m
//  masked
//
//  Created by Kelvin Tamzil on 28/08/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "SecondViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;



@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction) showCameraUI {
    NSLog(@"yo yo");
    [self startCameraControllerFromViewController: self usingDelegate:self];
}

- (IBAction) maskIt {
    NSLog(@"start masking");
    [self maskFaces:self.imageView];
//    [self startCameraControllerFromViewController: self usingDelegate:self];
}


//add image to imageview
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSLog(@"I'm here! %@ %@", image, editingInfo);
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self dismissModalViewControllerAnimated:YES];
    
}

    
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller

                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   
                                                   UINavigationControllerDelegate>) delegate {
    
    
    
    if (([UIImagePickerController isSourceTypeAvailable:
          
          UIImagePickerControllerSourceTypeCamera] == NO)
        
        || (delegate == nil)
        
        || (controller == nil))
        
        return NO;
    
    
    
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    
    // Displays a control that allows the user to choose picture or
    
    // movie capture, if both are available:
    
    //cameraUI.mediaTypes =
    
    //[UIImagePickerController availableMediaTypesForSourceType:
     
     //UIImagePickerControllerSourceTypeCamera];
    
    //only allow user to take picture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    
    // Hides the controls for moving & scaling pictures, or for
    
    // trimming movies. To instead show the controls, use YES.
    
    cameraUI.allowsEditing = NO;
    
    
    
    cameraUI.delegate = delegate;
    
    
    
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
    
}



-(void)maskFaces:(UIImageView *)facePicture
{
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyLow };      // 2
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];                    // 3
    
//    opts = @{ CIDetectorImageOrientation :
//                  [[image properties] valueForKey:kCGImagePropertyOrientation] }; // 4
//    NSArray *faceArray = [detector featuresInImage:image options:opts];
//
    
    
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
//                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy]]; /*[CIDetector detectorOfType:CIDetectorTypeFace
//                                              context:nil
//                                              options:nil];*/
    
    
    NSArray *faceArray = [detector featuresInImage:image options:nil];
    
    // Create a green circle to cover the rects that are returned.
    
    CIImage *maskImage = nil;
    
    for (CIFeature *f in faceArray) {
        NSLog(@"Found a face");
        CGFloat centerX = f.bounds.origin.x + f.bounds.size.width / 2.0;
        
        CGFloat centerY = f.bounds.origin.y + f.bounds.size.height / 2.0;
        
        CGFloat radius = MIN(f.bounds.size.width, f.bounds.size.height) / 1.5;
        //http://stackoverflow.com/questions/15057161/trouble-generating-a-mask-image-cisourceovercompositing-not-working-as-expected
        
        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:
                                    @"inputRadius0", @(radius),
                                    @"inputRadius1", @(radius + 1.0f),
                                    @"inputColor0", [CIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                    @"inputColor1", [CIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                                    kCIInputCenterKey, [CIVector vectorWithX:centerX Y:centerY],
                                    nil];
        
        CIImage *circleImage = [radialGradient valueForKey:kCIOutputImageKey];
        
        if (nil == maskImage) {
            NSLog(@"initial mask");
            maskImage = circleImage;
        } else {
            NSLog(@"compositing mask");
            maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:
                          kCIInputImageKey, circleImage,
                          kCIInputBackgroundImageKey, maskImage,
                          nil] valueForKey:kCIOutputImageKey];
        }
        
    }
    
    
    
    // BLurred image
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];           // 3
    
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    
    CIImage *blurryImage = [filter valueForKey:kCIOutputImageKey];
    
    CIFilter *maskedThingy = [CIFilter filterWithName:@"CIBlendWithMask" keysAndValues:
                              
                              @"inputImage", blurryImage,
                              
                              @"inputBackgroundImage", image,
                              
                              @"inputMaskImage", maskImage,
                              nil];
    
    CIImage *result = [maskedThingy valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];   // 5
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
//    [self.imageView removeFromSuperview];
    self.imageView2 = [[UIImageView alloc] initWithImage:newImage];
    //    bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    //    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView2.frame = self.view.frame;
    
    //    [self.imageView resi]
    //        self.imageView.bounds.origin.y = 0;
    [self.view addSubview:self.imageView2];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
