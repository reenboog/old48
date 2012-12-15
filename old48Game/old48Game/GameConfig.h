
#define zPlayer 5
#define zChaser 5

#define kScreenWidth    1024
#define kScreenHeight   768
#define kScreenCenter   ccp(kScreenWidth / 2, kScreenHeight / 2)

#define kPlayerPos ccp(kScreenWidth / 2, 100)
#define kChaserPos ccp(100, 100)

#define kPlayerTag 8136

//settings stuff
#define kTumblingAllowed @"isTumblingAllowed"

//logic
#define kPlayerJumpHeight 100
#define kPlayerJumpTime 0.5

#define kPlayerTumbleHeight 250
#define kPlayerTumbleTime 0.4

#define kPlayerDodgeDelta ccp(0, -20)
#define kPlayerDodgeTime 0.3