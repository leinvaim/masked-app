//
//  FirstViewController.m
//  masked
//
//  Created by Kelvin Tamzil on 28/08/2014.
//  Copyright (c) 2014 leinvaim. All rights reserved.
//

#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstViewController ()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"first view loaded");
//	// Do any additional setup after loading the view, typically from a nib.
//    
//    NSLog(@"hrllo worl");
//    CIContext *context = [CIContext contextWithOptions:nil];                    // 1
//    
//    NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };      // 2
//    
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
//                            
//                                              context:context
//                            
//                                              options:opts];                    // 3
//    
//    NSString *filePath =
//    [[NSBundle mainBundle] pathForResource:@"image" ofType:@"jpg"];
//    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
//    
//    // 2
//    CIImage *myImage =
//    [CIImage imageWithContentsOfURL:fileNameAndPath];
//    
//    //    opts = @{ CIDetectorImageOrientation : [[myImage properties] valueForKey:kCGImagePropertyOrientation] }; // 4
//    
//    NSArray *features = [detector featuresInImage:myImage options:nil];        // 5
//    
//    for (CIFaceFeature *faceFeature in features){
//        CGRect faceRect = faceFeature.bounds;
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        CGContextSetLineWidth(context, 1.0);
//        
//        CGContextAddRect(context, faceRect);
//        CGContextDrawPath(context, kCGPathStroke);
//    }
//    for (CIFaceFeature *f in features) {
//        NSLog(@"the features are this %@", NSStringFromCGRect(f.bounds));
//        //        NSLog(NSStringFromCGRect(f.bounds));
//        //
//        //        if (f.hasLeftEyePosition) {
//        //            NSLog("Left eye %g %g", f.leftEyePosition.x. f.leftEyePosition.y);
//        //        }
//        //
//        //        if (f.hasRightEyePosition) {
//        //            NSLog("Right eye %g %g", f.rightEyePosition.x. f.rightEyePosition.y);
//        //        }
//        //
//        //        if (f.hasmouthPosition) {
//        //            NSLog("Mouth %g %g", f.mouthPosition.x. f.mouthPosition.y);
//        //        }
//    }
    
    
    // http://maniacdev.com/2011/11/tutorial-easy-face-detection-with-core-image-in-ios-5
    [self faceDetector];
}

-(void)faceDetector
{
    // Load the picture for face detection
    self.imageView = [[UIImageView alloc] initWithImage:
                          [UIImage imageNamed:@"image2.jpg"]];
    
    // Draw the face detection image
    [self.view addSubview:self.imageView];
    
//    CIImage* image = [CIImage imageWithCGImage:self.imageView.image.CGImage];
//
//    CIContext *context = [CIContext contextWithOptions:nil];               // 1
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];           // 3
//    
//    [filter setValue:image forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
//    
//    //[filter setValue:@0.8f forKey:kCIInputIntensityKey];
//    
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
//    
//    CGRect extent = [result extent];
//    
//    CGImageRef cgImage = [context createCGImage:result fromRect:extent];   // 5
//
//    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
//    [self.imageView removeFromSuperview];
//    self.imageView = [[UIImageView alloc] initWithImage:newImage];
//    [self.view addSubview:self.imageView];
//    

    // Execute the method used to markFaces in background
    [self maskFaces:self.imageView];
    
    // flip image on y-axis to match coordinate system used by core image
//    [image setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // flip the entire window to make everything right side up
//    [self.view setTransform:CGAffineTransformMakeScale(1, -1)];
    
}

-(void)maskFaces:(UIImageView *)facePicture
{
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                            
                                              context:nil
                            
                                              options:nil];
    
    NSArray *faceArray = [detector featuresInImage:image options:nil];
    
    // Create a green circle to cover the rects that are returned.
    
    CIImage *maskImage = nil;
    
    for (CIFeature *f in faceArray) {

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
    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithImage:newImage];
//    bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.frame = self.view.frame;

//    [self.imageView resi]
//        self.imageView.bounds.origin.y = 0;
    [self.view addSubview:self.imageView];
    

}
-(void)markFaces:(UIImageView *)facePicture
{
    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
    transform = CGAffineTransformTranslate(transform, 0, 0 - self.imageView.bounds.size.height);
    
    // we'll iterate through every detected face. CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected. Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for(CIFaceFeature* faceFeature in features)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        
        // Get the face rect: Convert CoreImage to UIKit coordinates
        const CGRect faceRect = CGRectApplyAffineTransform(faceFeature.bounds, transform);
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:faceRect];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
        [self.view addSubview:faceView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
