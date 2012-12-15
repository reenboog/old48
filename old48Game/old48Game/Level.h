

@interface Level: NSObject
{
    NSString *groundImage;
    NSString *backImage;
    NSString *skyImage;
    
    NSArray *objects;
}

@property (nonatomic, retain) NSString *groundImage;
@property (nonatomic, retain) NSString *backImage;
@property (nonatomic, retain) NSString *skyImage;

@property (nonatomic, retain, readonly) NSArray *objects;

- (id) initWithIndex: (NSInteger) levelIndex;

@end
