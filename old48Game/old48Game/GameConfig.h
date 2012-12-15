
#define zPlayer 5
#define zObstacle 4
#define zChaser 5

#define kScreenWidth    1024
#define kScreenHeight   768
#define kScreenCenter   ccp(kScreenWidth / 2, kScreenHeight / 2)

#define kPlayerPos ccp(kScreenWidth / 2, 100)
#define kChaserPos ccp(100, 100)

#define kPlayerTag 8136
#define kPlayerSpeed -300

//settings stuff
#define kTumblingAllowed @"isTumblingAllowed"
#define kLevelPrefix @"res/levels/level"

//logic
#define kPlayerJumpHeight 100
#define kPlayerJumpTime 0.5

#define kPlayerTumbleHeight 250
#define kPlayerTumbleTime 0.4

#define kPlayerDodgeDelta ccp(0, -80)
#define kPlayerDodgeTime 1.0

//pause menu
#define kPauseMenuPos ccp(980, 750)

//gestures
#define kLeftGestureArea CGRectMake(0, 0, 150, 768)
#define kRightGestureArea CGRectMake(874, 0, 150, 768)