#import <XCTest/XCTestLog.h>
#import <XCTest/XCTestSuiteRun.h>
#import <XCTest/XCTest.h>

// This class enables Code Coverage gcov file generation for the XCode 5 Unit Tests.
// Workaround for XCode 5 bug where __gcov_flush is not called properly when Test Coverage flags are set

@interface VATestObserver : XCTestLog
@end


static NSUInteger sTestCounter = 0;
static id mainSuite = nil;

@implementation VATestObserver

+ (void)initialize {
    [[NSUserDefaults standardUserDefaults] setValue:@"VATestObserver"
                                             forKey:XCTestObserverClassKey];
    [super initialize];
}

- (void)testSuiteDidStart:(XCTestRun *)testRun {
    [super testSuiteDidStart:testRun];
    
    XCTestSuiteRun *suite = [[XCTestSuiteRun alloc] init];
    [suite addTestRun:testRun];
    
    sTestCounter++;
    
    if (mainSuite == nil) {
        mainSuite = suite;
    }
}

- (void)testSuiteDidStop:(XCTestRun *)testRun {
    
    sTestCounter--;
    
    [super testSuiteDidStop:testRun];
    
    XCTestSuiteRun *suite = [[XCTestSuiteRun alloc] init];
    [suite addTestRun:testRun];
    
    if (sTestCounter == 0) {
        __gcov_flush();
    }
}
@end
