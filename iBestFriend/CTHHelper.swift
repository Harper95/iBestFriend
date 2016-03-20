

import Foundation           // for NSString
import UIKit                // For UIImage stuff
import MobileCoreServices   // For kUTTypeImage

//MARK: Array Extensions
extension Array where Element: Equatable {
    mutating public func removeObject(object:Element) {
        if let index = self.indexOf(object){
            self.removeAtIndex(index)
        }
    }
    
    mutating public func removeObjects(array:[Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

//MARK: Numeric Extensions
extension Int {
    /**
     formats value w/ printf style format string
     
     - Parameters:
     - f: format string.  10 w/ format '0.4' would pad two zeros left: "0010"
     - Returns: number as a string with given format
     */
    public func format(f: String) -> String {
        return NSString(format: "%\(f)d", self) as String
    }
}

extension Double {
    /**
     formats value w/ printf style format string
     
     - Parameters:
     - f: format string.  0.333 w/ format '0.2' would yield 0.33
     - Returns: number as a string with given format
     */
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension Float {
    /**
    formats value w/ printf style format string
     
     - Parameters:
        - f: format string.  0.333 w/ format '0.2' would yield 0.33
     - Returns: number as a string with given format
    */
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

//MARK: String extenstions

extension String {
	func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
		return emailTest.evaluateWithObject(self)
	}
}

//MARK: UIImage extensions
extension UIImage {
    /// Creates an image that will fit inside the given rectangle (won't work in Playground)
    public func scaledInside(maxSize:CGSize) -> UIImage? {
        
        let cgImage = self.CGImage
        
        let aspectWidth:CGFloat  = maxSize.width / self.size.width;
        let aspectHeight:CGFloat = maxSize.height / self.size.height;
        let aspectRatio:CGFloat  = min( aspectWidth, aspectHeight );
        
        let width:Int = Int(self.size.width * aspectRatio);
        let height:Int = Int(self.size.height * aspectRatio);
        
        let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
        let bytesPerRow = CGImageGetBytesPerRow(cgImage)
        let colorSpace = CGImageGetColorSpace(cgImage)
        let bitmapInfo = CGImageGetBitmapInfo(cgImage)
        
        let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        CGContextSetInterpolationQuality(context, .High)
        
        CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
        
        let scaledImage = CGBitmapContextCreateImage(context).flatMap { UIImage(CGImage: $0) }
        return scaledImage
        
    }
    
    /// Helper that is sometimes needed when pulling assets from camera roll to make sure orientation is set correctly  (won't work in Playground)
    public func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImageOrientation.Up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.drawInRect(rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
}

//MARK: Image Capture Helpers

/// When on device, prompts user to choose between camera roll and photos.  On simulartor, just goes to photos.
public func CTHPresentImageCapture<T: UIViewController where T:UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(controller:T, title:String, message:String) {
    if UIImagePickerController.isSourceTypeAvailable(.Camera)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default) { (_) in
            let picker = UIImagePickerController()
            picker.mediaTypes = [kUTTypeImage as String]
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.allowsEditing = false;
            picker.delegate = controller;
            controller.presentViewController(picker, animated: true, completion: nil)
        }
        
        let rollAction = UIAlertAction(title: "Camera Roll", style: .Default) { (_) in
            let picker = UIImagePickerController()
            picker.allowsEditing = false;
            picker.delegate = controller;
            controller.presentViewController(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addAction(cameraAction)
        alertController.addAction(rollAction)
        alertController.addAction(cancelAction)
        controller.presentViewController(alertController, animated: true) {}
    } else {
        let picker = UIImagePickerController()
        picker.allowsEditing = false;
        picker.delegate = controller;
        controller.presentViewController(picker, animated: true, completion: nil)
    }
}

/// When on device, goes straight to the camera.  On simulartor, goes to photos.
public func CTHPresentCamera<T: UIViewController where T:UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(controller:T) {
    if UIImagePickerController.isSourceTypeAvailable(.Camera)
    {
        let picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.allowsEditing = false;
        picker.delegate = controller;
        controller.presentViewController(picker, animated: true, completion: nil)
    } else {
        let picker = UIImagePickerController()
        picker.allowsEditing = false;
        picker.delegate = controller;
        controller.presentViewController(picker, animated: true, completion: nil)
    }
}


//MARK: UIAlertController conveniences

/// Creates simple alert controller with ok and cancel callbacks
public func CTHAlertTextFor(controller:UIViewController, title:String, message:String, placeholder:String, okCallback:((string:String)->Void), cancelCallback:(()->Void)?) {
    let alertController = UIAlertController(title:title, message:message, preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        if let callback = cancelCallback {
            callback()
        }
    }
    alertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        let textField = alertController.textFields![0] as UITextField
        okCallback(string: textField.text!)
    }
    alertController.addAction(OKAction)
    
    alertController.addTextFieldWithConfigurationHandler { (textField) in
        textField.placeholder = placeholder
    }
    
    controller.presentViewController(alertController, animated: true, completion:nil)
}

//MARK: Animation conveniences

/// Apples formula for rounded corners
extension CALayer {
	func setIdealCornerRadius() {
		self.cornerRadius = (10/57) * min(self.frame.size.height, self.frame.size.width)
	}
}

/// Creates a delay with a trailing closure
// http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
func delay(delay: Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}

