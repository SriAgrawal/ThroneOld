//
//  ServiceHelper.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 20/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ServiceHelper.h"
#import "Macro.h"

//TODO:- // Note:- Implement delegates if required for your requirement. PUT and Delete are not tested; May requires improvement

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> APIs Constants Start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

static double timeoutInterval = 45.0;

// Local
//static NSString *baseURL = @"";

// Staging
static NSString *baseURL = @"http://throne-demo.herokuapp.com/api/v1/";

// Production
//static NSString *baseURL = @"";


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> APIs Constants Start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@interface ServiceHelper()

@end

@implementation ServiceHelper

+ (ServiceHelper *)helper {
    
    static ServiceHelper *_manager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _manager = [[ServiceHelper alloc] init];
    });
    return _manager;
}

#pragma mark - Public methods

- (void)request:(NSMutableDictionary *)parameterDict apiName:(NSString *)name withToken:(BOOL)isToken method:(Method)methodType onViewController:(UIViewController *)controller completionBlock:(void (^)(id result, NSError *error))handler {
    
    if (![APPDELEGATE isReachable]) {
        
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        
        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
        
        handler(nil,error);
        return ;
    }
    
    NSURL *requestURL = [self requestURL:parameterDict apiName:name method:methodType];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:[self methodName:methodType]];
    
    if ((methodType == POST) || (methodType == PATCH)  || (methodType == DELETE) || (methodType == PUT)) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [request setHTTPBody:[self body:parameterDict method:methodType]];
    [request setTimeoutInterval:timeoutInterval];
    
    LogInfo(@"\n\n Request URL  >>>>>>  %@",requestURL);
    LogInfo(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);

    if (isToken) {
        [request setValue:[NSUSERDEFAULT valueForKey:pSpreeApiKey] forHTTPHeaderField:@"X-Spree-Token"];
    }
    
    if ([name isEqualToString:kProvidersAuth]) {
        [request setValue:@"db17e7d1d63aae5262971e2b39ad6f9db157d15d1504889a4996ad4092cccea93c079ed75db728af908a8476bd405c0d4e6f02dbfb6b0064b606ed4d5f3938ff" forHTTPHeaderField:@"Spree-Api-Key"];
    }
    
    [self progressHud:YES];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        [self progressHud:NO];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [httpResponse statusCode];
        
        LogInfo("\n\n Response Code >>>>>> \n%ld",(long)responseCode);
        
        //NSDictionary *responseHeader = [httpResponse allHeaderFields];
        //LogInfo("\n\n Response Header >>>>>> \n%ld",responseHeader)

        if (error != nil) {
            LogInfo(@"\n\n error  >>>>>>  %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, error);
            });
        } else {
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            
            LogInfo("\n\nResponse String>>>> \n%@",responseString);
            
            if ((responseCode == 200) || (responseCode == 201)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(result, nil);
                });
            }
            else{
                
                [AlertController message:[self parseAnErrorMessageWithInfo:result] onViewController:controller];
            }
        }
    }];
    
    [dataTask resume];
}

- (void)multiPartRequest:(NSMutableDictionary *)parameterDict images:(NSArray *)images apiName:(NSString *)name withToken:(BOOL)isToken onViewController:(UIViewController *)controller completionBlock:(void (^)(id result, NSError *error))handler {
    
    if (![APPDELEGATE isReachable]) {
        
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        
        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
        
        handler(nil,error);
        return ;
    }
    
    //NSURL *requestURL = [NSURL URLWithString:@"http://172.16.0.9/PROJECTS/MICOLUMBIA/trunk/api_v3/version_v3/create_post"];//[self requestURL:parameterDict apiName:name method:POST];
    NSURL *requestURL = [self requestURL:parameterDict apiName:name method:POST];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:[self methodName:POST]];
    
    NSString *boundary = [self generateBoundaryString]; //unique-consistent-string

    // create body
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:parameterDict images:images];

    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setHTTPBody:httpBody];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:timeoutInterval];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[httpBody length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    LogInfo(@"\n\n Request URL  >>>>>>  %@",requestURL);
    //LogInfo(@"\n\n Request Header  >>>>>>  %@",request.allHTTPHeaderFields);
    LogInfo(@"\n\n Request Body  >>>>>>  %@",request.HTTPBody);
    LogInfo(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);
    
    if ([self isTokenRequiredForApi:name]) {
        [request setValue:[NSUSERDEFAULT valueForKey:pSpreeApiKey] forHTTPHeaderField:@"X-Spree-Token"];
    }
    
    [self progressHud:YES];
    
    NSURLSession *session = [NSURLSession sharedSession]; // use sharedSession or create your own

    request.HTTPBody = httpBody;
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self progressHud:NO];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [httpResponse statusCode];
        
        LogInfo("\n\n Response Code >>>>>> \n%ld",(long)responseCode);
        
        //NSDictionary *responseHeader = [httpResponse allHeaderFields];
        //LogInfo("\n\n Response Header >>>>>> \n%ld",responseHeader)
        
        if (error != nil) {
            LogInfo(@"\n\n error  >>>>>>  %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, error);
            });
        } else {
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            
            LogInfo("\n\nResponse String>>>> \n%@",responseString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(result, nil);
            });
        }
        
//        if (error) {
//            NSLog(@"error = %@", error);
//            return;
//        }
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        LogInfo(@"result = %@", result);
    }];
    
    [dataTask resume];
}

#pragma mark - Private methods

- (BOOL)isTokenRequiredForApi:(NSString *)name {
    
    BOOL required = NO;
    
    if ([name isEqualToString:kVendors_Apply]) {
       required = YES;
    }
    else if ([name isEqualToString:kOrders_Current]) {
        required = YES;
    }
    else if ([name isEqualToString:kProduct_Likes]) {
        required = YES;
    }
    
    return required;
}

- (NSString *)methodName:(Method)methodType {
    
    switch (methodType) {
            
        case GET: return @"GET";
            
        case POST: return @"POST";
            
        case DELETE: return @"DELETE";
            
        case PUT: return @"PUT";
            
        case PATCH: return @"PATCH";

            
    }
}

- (NSData *)body:(NSMutableDictionary *)parameterDict method:(Method)methodType {
    
    switch (methodType) {
            
        case GET: return [NSData data];
            
        case POST: return [parameterDict toNSData];
            
        case DELETE: return [NSData data];
            
        case PUT: return [parameterDict toNSData]; // depends on server requirement
            
        case PATCH: return [parameterDict toNSData]; // depends on server requirement
            
    }
}

- (NSURL *)formattedURL:(NSMutableDictionary *)parameterDict apiName:(NSString *)name {
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", baseURL, name];
    BOOL isFirst = YES;
    
    for (NSString *key in [parameterDict allKeys]) {
        
        id object = parameterDict[key];
        if ([object isKindOfClass:[NSArray class]]) {
            
            for (id eachObject in object) {
                
                [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                isFirst = NO;
            }
        } else {
            [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
        }
        
        isFirst = NO;
    }
    
    NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:encodedString];
}

- (NSURL *)requestURL:(NSMutableDictionary *)parameterDict apiName:(NSString *)name method:(Method)methodType {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,name];
    
    switch (methodType) {
            
        case GET: return [self formattedURL:parameterDict apiName:name];
            
        case POST:return [NSURL URLWithString:urlString];
            
        default: return [NSURL URLWithString:urlString];
    }
}

- (NSTimeInterval )currentTimeStamp {
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    return timeInSeconds;
}

- (NSString *)randomGlobalUniqueString {
    NSString *randomString = [NSString stringWithFormat:@"%@%.0f", [[[NSProcessInfo processInfo] globallyUniqueString] stringByReplacingOccurrencesOfString:@"-" withString:@""], [[NSDate date] timeIntervalSince1970]];
    
    return randomString;
}

- (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    // if supporting iOS versions prior to 6.0, you do something like:
    //
    // // generate boundary string
    // //
    // adapted from http://developer.apple.com/library/ios/#samplecode/SimpleURLConnections
    //
    // CFUUIDRef  uuid;
    // NSString  *uuidStr;
    //
    // uuid = CFUUIDCreate(NULL);
    // assert(uuid != NULL);
    //
    // uuidStr = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    // assert(uuidStr != NULL);
    //
    // CFRelease(uuid);
    //
    // return uuidStr;
}

// This is the method used above to build the body of the request:

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                            images:(NSArray *)images
/*paths:(NSArray *)paths
 fieldName:(NSString *)fieldName*/ {
     
     NSMutableData *httpBody = [NSMutableData data];
     
     //NSString *keyForImages = @"mediaFiles";
     
     // add params (all params are strings)
     
     [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
         [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
     }];
     
     
     // add image data
     
     int counter = 1;
     
     for (UIImage *image in images) {
         NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
         
         [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         //[httpBody appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[NSString stringWithFormat:@"file_%d_%f",counter,[self currentTimeStamp]],keyForImages]] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"photo"] dataUsingEncoding:NSUTF8StringEncoding]];
         //[httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=\"%@\r\n", keyForImages,[NSString stringWithFormat:@"file_%d_%f",counter,[self currentTimeStamp]]] dataUsingEncoding:NSUTF8StringEncoding]];


         [httpBody appendData:[@"Content-Type:application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:imageData];
         [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         counter++;
     }
     
     
     //    for (NSString *path in paths) {
     //        NSString *filename  = [path lastPathComponent];
     //        NSData   *data      = [NSData dataWithContentsOfFile:path];
     //        NSString *mimetype  = [self mimeTypeForPath:path];
     //
     //        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     //        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
     //
     //        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
     //        [httpBody appendData:data];
     //        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     //    }
     
     [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
     return httpBody;
 }

//- (NSString *)mimeTypeForPath:(NSString *)path {
//    // get a mime type for an extension using MobileCoreServices.framework
//
//    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
//    assert(UTI != NULL);
//
//    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
//    assert(mimetype != NULL);
//    
//    CFRelease(UTI);
//    
//    return mimetype;
//}

- (void)progressHud:(BOOL)status {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:[APPDELEGATE window]];

        if (status) {
            if (hud == nil) {
                hud = [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] animated:YES];
            }
            [hud.layer setCornerRadius:8.0];
            [hud.bezelView setColor:RGBCOLOR(0, 0, 0, 1.0)];
            [hud setMargin:12];
            [[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil] setColor:[UIColor whiteColor]];
            
        } else {
            
            [hud hideAnimated:true afterDelay:0.1];
        }
    });
}

-(NSString *)parseAnErrorMessageWithInfo:(NSDictionary *)dict{
    
    NSArray * keysArray = dict.allKeys;
    for (NSString * key in keysArray) {
        if ([keysArray containsObject:@"error"]) {
            return [dict objectForKeyNotNull:@"error" expectedObj:@""];
        }
        NSArray * errorMessage = [dict objectForKeyNotNull:key expectedObj:[NSArray array]];
        if (errorMessage.count) {
            return [NSString stringWithFormat:@"%@ %@.", [self capitalizedFirstLetter:key], [errorMessage objectAtIndex:0]];
        }
    }
    return @"";
}

- (NSString *) capitalizedFirstLetter:(NSString *)string {
    NSString *txt = string;
    txt = [txt stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[txt substringToIndex:1] uppercaseString]];
    return txt;
}


@end

// See for multi part request
// http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession
// https://gist.github.com/mombrea/8467128
// http://stackoverflow.com/questions/8564833/ios-upload-image-and-text-using-http-post
// http://stackoverflow.com/questions/24250475/post-multipart-form-data-with-objective-c
/*
 
 // http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
 
 if status == 400 { description = "Bad Request" }
 
 if status == 401 { description = "Unauthorized" }
 
 if status == 402 { description = "Payment Required" }
 
 if status == 403 { description = "Forbidden" }
 
 if status == 404 { description = "Not Found" }
 
 if status == 405 { description = "Method Not Allowed" }
 
 if status == 406 { description = "Not Acceptable" }
 
 if status == 407 { description = "Proxy Authentication Required" }
 
 if status == 408 { description = "Request Timeout" }
 
 if status == 409 { description = "Conflict" }
 
 if status == 410 { description = "Gone" }
 
 if status == 411 { description = "Length Required" }
 
 if status == 412 { description = "Precondition Failed" }
 
 if status == 413 { description = "Payload Too Large" }
 
 if status == 414 { description = "URI Too Long" }
 
 if status == 415 { description = "Unsupported Media Type" }
 
 if status == 416 { description = "Requested Range Not Satisfiable" }
 
 if status == 417 { description = "Expectation Failed" }
 
 if status == 422 { description = "Unprocessable Entity" }
 
 if status == 423 { description = "Locked" }
 
 if status == 424 { description = "Failed Dependency" }
 
 if status == 425 { description = "Unassigned" }
 
 if status == 426 { description = "Upgrade Required" }
 
 if status == 427 { description = "Unassigned" }
 
 if status == 428 { description = "Precondition Required" }
 
 if status == 429 { description = "Too Many Requests" }
 
 if status == 430 { description = "Unassigned" }
 
 if status == 431 { description = "Request Header Fields Too Large" }
 
 if status == 432 { description = "Unassigned" }
 
 if status == 500 { description = "Internal Server Error" }
 
 if status == 501 { description = "Not Implemented" }
 
 if status == 502 { description = "Bad Gateway" }
 
 if status == 503 { description = "Service Unavailable" }
 
 if status == 504 { description = "Gateway Timeout" }
 
 if status == 505 { description = "HTTP Version Not Supported" }
 
 if status == 506 { description = "Variant Also Negotiates" }
 
 if status == 507 { description = "Insufficient Storage" }
 
 if status == 508 { description = "Loop Detected" }
 
 if status == 509 { description = "Unassigned" }
 
 if status == 510 { description = "Not Extended" }
 
 if status == 511 { description = "Network Authentication Required" }
 
 */
