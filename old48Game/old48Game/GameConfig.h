
#define zPlayer 5
#define zObstacle 4
#define zChaser 5

#define zBackLayers 4
#define zGround 4
#define zSky 2
#define zBack 3

#define kBackgroundLayerVerticalDisplacement -20

#define kScreenWidth    1024
#define kScreenHeight   768
#define kSkyHeight      1024
#define kScreenCenter   ccp(kScreenWidth / 2, kScreenHeight / 2)

#define kPlayerPos ccp(kScreenWidth / 2, 155)
#define kChaserPos ccp(30, 180)

#define kPlayerTag 8136
#define kPlayerSpeed 235

//settings stuff
#define kTumblingAllowed @"isTumblingAllowed"
#define kLevelPrefix @"res/levels/level"

//logic
#define kPlayerJumpHeight 100
#define kPlayerJumpTime 0.5

#define kPlayerTumbleHeight 310
#define kPlayerTumbleTime 0.6

#define kPlayerDodgeDelta ccp(0, -55)
#define kPlayerDodgeTime 0.25

//pause menu
#define kPauseMenuPos ccp(980, 750)

//gestures
#define kLeftGestureArea CGRectMake(0, 0, 150, 768)
#define kRightGestureArea CGRectMake(874, 0, 150, 768)

//sizes
#define kRavenSize CGSizeMake(127, 85)