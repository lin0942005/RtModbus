//  RtModbus.h

#import "modbus.h"
#include <MacTypes.h>

#if defined(__cplusplus)
#define RTMODBUS_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define RTMODBUS_EXTERN extern __attribute__((visibility("default")))
#endif

#ifndef RtModbus_h
#define RtModbus_h



// 限位使能
#define MB_Limit_Enable  1
#define MB_Limit_Disable 0
// 轴旋转方向
#define MB_Inver_Dir  1
#define MB_Normal     0
// JOG 方向
#define MB_POSITIVE_DIRECTION     1
#define MB_NEGATIVE_DIRECTION     0
// Move Mode
#define MB_MOVE_ABS   0
#define MB_MOVE_REL   1

//Axis states
#define RT_AST_UNKNOW                       0x0000    //未知状态
#define RT_AST_IDLE                         0x0001    //尚未就绪
#define RT_AST_READY                        0x0002    //就绪
#define RT_AST_PTP                          0x0004    //点对点运动
#define RT_AST_JOG                          0x0008    //定速移动
#define RT_AST_HOME                         0x0010    //回零中
#define RT_AST_ERROR                        0x8000    //轴错误
#define RT_AST_BUSY            (RT_AST_HOME | RT_AST_PTP | RT_AST_JOG )

//Axis Motion io
#define RT_MOTION_IO_LIMIT_N             0x0001      //负限位
#define RT_MOTION_IO_LIMIT_P             0x0002      //正限位
#define RT_MOTION_IO_ORG                 0x0004      //原点信号
#define RT_MOTION_IO_EZ                  0x0008      //index信号
#define RT_MOTION_IO_SLIMIT_N            0x0010      //软负限位
#define RT_MOTION_IO_SLIMIT_P            0x0020      //软正限位
#define RT_MOTION_IO_DRIVERALARM         0x0040      //驱动器错误
#define RT_MOTION_IO_DRIVERERROR         0x0080      //驱动器错误
#define RT_MOTION_IO_ENABLE              0x0100      //驱动器使能
#define RT_MOTION_IO_INP                 0x0200      //INP, InPosition

// 寄存器地址
// Coil Register
#define DO_START_ADDR          0      // 00001-01000

// Input Discrete Register
#define DI_START_ADDR          0      // 00001-01000

// Holding Register
#define RESET_CONTROLLER       0       // 40001
#define START_CONTROLLER       1       // 40002
#define ENABLE_AXIS            100     // 40101
#define DISABLE_AXIS           101     // 40102
#define CLEAR_AXIS_ALARM       102     // 40103
#define HALT_AXIS              103     // 40104
#define KILL_AXIS              104     // 40105
#define HOME_CMD               120     // 40121
#define HOME_AXIS_ID           121     // 40122
#define HOME_MODE              122     // 40123
#define HOME_SWITCH_VEL        123     // 40124
#define HOME_ZERO_VEL          125     // 40126
#define HOME_ACC               127     // 40128
#define HOME_OFFSET            129     // 40130
#define JOG_CMD                140     // 40141
#define JOG_AXIS_ID            141     // 40142
#define JOG_MODE               142     // 40143
#define JOG_DISTANCE           143     // 40144
#define JOG_SPEED              145     // 40146
#define MOVE_CMD               160     // 40161
#define MOVE_AXIS_ID           161     // 40162
#define MOVE_VELOCITY          162     // 40163
#define MOVE_END_POS           164     // 40165
#define PARAM_PPU              400     // 40401
#define PARAM_MAX_VEL          402     // 40403
#define PARAM_ACC              404     // 40405
#define PARAM_DEC              406     // 40407
#define PARAM_JERK             408     // 40409
#define PARAM_KILL_DEC         410     // 40411
#define PARAM_SW_Positive_LIMIT_ENABLE  412      // 40413
#define PARAM_SW_Positive_LIMIT_VALUE   413      // 40414
#define PARAM_SW_Negative_LIMIT_ENABLE  415      // 40416
#define PARAM_SW_Negative_LIMIT_VALUE   416      // 40417
#define PARAM_INVERT_DIR       418     // 40419

// Input Register
#define MB_DeviceError         0       // 30001
#define MB_EMGStatus           1       // 30002
#define MB_ScanStatus          2       // 30003
#define MB_ScanErrorCode       3       // 30004
#define DEV_AXIS_COUNT         4       // 30005
#define ETHERCAT_STATE         6       // 30007
#define AXIS_STATE             100     // 30101
#define AXIS_IO_STATE          101     // 30102
#define AXIS_CMD_POS           102     // 30103
#define AXIS_ACT_POS           104     // 30105
#define AXIS_LAST_ERROR        106     // 30107
#define HOME_PARAM_DONE        107     // 30108
#define HOME_PARAM_SUCCESS     108     // 30109
#define HOME_MOVE_DONE         109     // 30110
#define HOME_MOVE_SUCCESS      110     // 30111


#define MbHandle             modbus_t // Modbus句柄
#define HOME_OUT_TIME 10000

// 声明全局变量
extern uint16_t readBuf[2];
extern uint16_t m_readInt;
extern uint16_t m_tick;

//@brief:建立控制器ModbusTCP通讯
//@param-in address 控制器IP地址
//@param-in port 端口号
//@param-in ctx modbus句柄
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_openCommModbusTCP(const char* address, int port, MbHandle **ctx);

//@brief:获取实际轴数量
//@param-in ctx modbus句柄
//@param-in axisNum 实际轴数
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisNum(MbHandle *ctx, int *axisNum);

//@brief: 获取轴状态
//@param-in ctx: Modbus句柄
//@param-in axisId: 轴号
//@param-out axisState: 输出轴状态值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisState(MbHandle *ctx, int axisId, uint16_t *axisState);

//@brief: 获取轴Io状态
//@param-in ctx: Modbus句柄
//@param-in axisId: 轴号
//@param-out axisState: 输出轴Io状态值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisIoState(MbHandle *ctx, int axisId, uint16_t *axisIoState);

//@brief: 获取轴理论位置
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out cmdPos 输出理论位置
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisCmdPos(MbHandle *ctx, int axisId, float *cmdPos);

//@brief: 获取轴实际位置
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出实际位置
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisActPos(MbHandle *ctx, int axisId, float *actPos);

//@brief: 获取轴PPU
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴PPU值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisPPU(MbHandle *ctx, int axisId, float *ppu);

//@brief: 获取轴最大速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴最大速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisMaxVel(MbHandle *ctx, int axisId, float *max_vel);

//@brief: 获取轴加速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴加速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisAcc(MbHandle *ctx, int axisId, float *acc);

//@brief: 获取轴减速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴减速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisDec(MbHandle *ctx, int axisId, float *dec);

//@brief: 获取轴加加速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴加加速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisJerk(MbHandle *ctx, int axisId, float *jerk);


//@brief: 获取轴急停减速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴急停减速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisKillDec(MbHandle *ctx, int axisId, float *kill_dec);

//@brief: 获取轴正限位使能状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴正限位使能状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getSPLimitEnableState(MbHandle *ctx, int axisId, uint16_t *enable);

//@brief: 获取轴正限位值
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴正限位值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getSPLimitPosition(MbHandle *ctx, int axisId, float *value);

//@brief: 获取轴负限位使能状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴负限位使能状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getSNLimitEnableState(MbHandle *ctx, int axisId, uint16_t *enable);

//@brief: 获取轴负限位值
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out actPos 输出轴负限位值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getSNLimitPosition(MbHandle *ctx, int axisId, float *value);

//@brief: 获取轴旋转方向
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out dir 输出轴旋转方向
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisInvertDir(MbHandle *ctx, int axisId, uint16_t *dir);

//@brief: 获取轴回零模式
//@param-in ctx Modbus句柄
//@param-out homeMode 输出轴回零模式
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisHomeMode(MbHandle *ctx, uint16_t *homeMode);

//@brief: 获取轴回零开关速度
//@param-in ctx Modbus句柄
//@param-out switchVel 输出轴回零开关速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisHomeSwitchVel(MbHandle *ctx, float *switchVel);

//@brief: 获取轴回零零点速度
//@param-in ctx Modbus句柄
//@param-out zeroVel 输出轴回零零点速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisHomeZeroVel(MbHandle *ctx, float *zeroVel);

//@brief: 获取轴回零加速度
//@param-in ctx Modbus句柄
//@param-out homeAcc 输出轴回零加速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisHomeAcc(MbHandle *ctx, float *homeAcc);

//@brief: 获取轴回零偏移量
//@param-in ctx Modbus句柄
//@param-out offset 输出轴回零偏移量
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisHomeOffset(MbHandle *ctx, float *offset);

//@brief: 获取轴JOG速度
//@param-in ctx Modbus句柄
//@param-out jogSpeed 输出轴JOG速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisJogSpeed(MbHandle *ctx, float *jogSpeed);

//@brief: 获取轴MOVE移动速度
//@param-in ctx Modbus句柄
//@param-out moveVel 输出轴MOVE移动速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisMoveVel(MbHandle *ctx, float *moveVel);

//@brief: 获取轴MOVE目标位置
//@param-in ctx Modbus句柄
//@param-out endPos 输出轴MOVE目标位置
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisMoveEndPos(MbHandle *ctx, float *endPos);

//@brief: 设置轴PPU
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in ppu 要设置的轴PPU值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisPPU(MbHandle *ctx, int axisId, float ppu);

//@brief: 设置轴最大速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in max_vel 要设置的轴最大速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisMaxVel(MbHandle *ctx, int axisId, float max_vel);

//@brief: 设置轴加速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in acc 要设置的轴加速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisAcc(MbHandle *ctx, int axisId, float acc);

//@brief: 设置轴减速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in dec 要设置的轴减速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisDec(MbHandle *ctx, int axisId, float dec);

//@brief: 设置轴加加速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in jerk 要设置的轴加加速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisJerk(MbHandle *ctx, int axisId, float jerk);

//@brief: 设置轴急停减速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in kill_dec 要设置的轴急停减速度值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisKillDec(MbHandle *ctx, int axisId, float kill_dec);

//@brief: 设置轴正限位使能状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in enable 要设置的轴正限位使能状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setSPLimitEnableState(MbHandle *ctx, int axisId, uint16_t enable);

//@brief: 设置轴正限位值
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in value 要设置的轴正限位值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setSPLimitPosition(MbHandle *ctx, int axisId, float value);

//@brief: 设置轴负限位使能状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in enable 要设置的轴负限位使能状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setSNLimitEnableState(MbHandle *ctx, int axisId, uint16_t enable);

//@brief: 设置轴负限位值
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in value 要设置的轴负限位值
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setSNLimitPosition(MbHandle *ctx, int axisId, float value);

//@brief: 设置轴旋转方向
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in dir 要设置的轴旋转方向
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisInvertDir(MbHandle *ctx, int axisId, uint16_t dir);

//@brief: 设置回零轴号
//@param-in ctx Modbus句柄
//@param-in homeAxis 要设置的回零轴号
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setHomeAxis(MbHandle *ctx, uint16_t homeAxis);

//@brief: 设置轴回零模式
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in homeMode 要设置的轴回零模式
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisHomeMode(MbHandle *ctx, uint16_t axisId, uint16_t homeMode);

//@brief: 设置轴回零开关速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in switchVel 要设置的轴回零开关速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisHomeSwitchVel(MbHandle *ctx, uint16_t axisId, Float32 switchVel);

//@brief: 设置轴回零零点速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in zeroVel 要设置的轴回零零点速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisHomeZeroVel(MbHandle *ctx, uint16_t axisId, Float32 zeroVel);

//@brief: 设置轴回零加速度
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisHomeAcc(MbHandle *ctx, uint16_t axisId, Float32 homeAcc);

//@brief: 设置轴回零偏移量
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-in offset 要设置的轴回零偏移量
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisHomeOffset(MbHandle *ctx, uint16_t axisId, int32_t offset);

//@brief: 设置轴JOG速度
//@param-in ctx Modbus句柄
//@param-in jogSpeed 要设置的轴JOG速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisJogSpeed(MbHandle *ctx, Float32 jogSpeed);

//@brief: 设置轴MOVE移动速度
//@param-in ctx Modbus句柄
//@param-in moveVel 要设置的轴MOVE移动速度
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisMoveVel(MbHandle *ctx, Float32 moveVel);

//@brief: 设置轴MOVE目标位置
//@param-in ctx Modbus句柄
//@param-in endPos 要设置的轴MOVE目标位置
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setAxisMoveEndPos(MbHandle *ctx, Float32 endPos);

//@brief:轴使能
//@param-in ctx modbus句柄
//@param-in axisId 使能的轴号
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_enable(MbHandle *ctx, int axisId);

//@brief:轴断使能
//@param-in ctx modbus句柄
//@param-in axisId 断使能的轴号
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_disable(MbHandle *ctx, int axisId);

//@brief:清除轴报警
//@param-in ctx modbus句柄
//@param-in axisId 清除报警的轴号
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_clearAlarm(MbHandle *ctx, int axisId);

//@brief:轴停止
//@param-in ctx modbus句柄
//@param-in axisId 停止的轴号
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_halt(MbHandle *ctx, int axisId);

//@brief:轴急停
//@param-in ctx modbus句柄
//@param-in axisId 急停的轴号
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_kill(MbHandle *ctx, int axisId);

//@brief:JOG点动
//@param-in ctx modbus句柄
//@param-in axisId 点动的轴号
//@param-in dir 点动方向
//          MB_POSITIVE_DIRECTION   1 正向移动
//          MB_NEGATIVE_DIRECTION   0 负向移动
//@param-in jogSpeed 点动速度
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_jog(MbHandle *ctx, int axisId, int dir, Float32 jogSpeed);

//@brief:轴回零
//@param-in ctx modbus句柄
//@param-in cmd 回零命令
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_startHome(MbHandle *ctx, int axisId, int cmd);

//@brief:轴点对点移动
//@param-in ctx modbus句柄
//@param-in axisId 移动的轴号
//@param-in moveMode 移动模式
//          MB_MOVE_ABS   0 运动使用绝对位置
//          MB_MOVE_REL   1 运动使用相对位置
//@param-in moveSpeed 移动速度
//@param-in endPos 目标位置
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_move(MbHandle *ctx, int axisId, int moveMode, Float32 moveSpeed, Float32 endPos);

//@brief:获取错误信息
//@return 错误返回一个指向错误信息字符串的指针
RTMODBUS_EXTERN const char *mb_getErrorMessage(int errnum);

//@brief: 获取轴最后错误码
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out lastError 输出轴最后错误码
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getAxisLastError(MbHandle *ctx, int axisId, uint16_t *lastError);

//@brief: 获取轴回零参数完成状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out paramDone 输出回零参数完成状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getHomeParamDone(MbHandle *ctx, int axisId, uint16_t *paramDone);

//@brief: 获取轴回零参数设置成功状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out paramSuccess 输出回零参数设置成功状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getHomeParamSuccess(MbHandle *ctx, int axisId, uint16_t *paramSuccess);

//@brief: 获取轴回零移动完成状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out moveDone 输出回零移动完成状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getHomeMoveDone(MbHandle *ctx, int axisId, uint16_t *moveDone);

//@brief: 获取轴回零移动成功状态
//@param-in ctx Modbus句柄
//@param-in axisId 轴号
//@param-out moveSuccess 输出回零移动成功状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getHomeMoveSuccess(MbHandle *ctx, int axisId, uint16_t *moveSuccess);

//@brief: 获取设备错误码
//@param-in ctx Modbus句柄
//@param-out deviceError 输出设备错误码
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getDeviceError(MbHandle *ctx, uint16_t *deviceError);

//@brief: 获取EtherCAT连接状态
//@param-in ctx Modbus句柄
//@param-out connectStatus 输出连接状态
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getEtherCATStatus(MbHandle *ctx, uint16_t *connectStatus);

//@brief: 获取ModbusTCP连接状态
//@param-in ctx Modbus句柄
//@return: 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getConnectStatus(MbHandle *ctx);

//@brief: 关闭Modbus连接
//@param-in ctx modbus句柄
//@return 无返回值
RTMODBUS_EXTERN void mb_closeCommModbusTCP(MbHandle *ctx);

//@brief: 重启控制器
//@param-in ctx modbus句柄
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_resetController(MbHandle *ctx);

//@brief: 启动控制器
//@param-in ctx modbus句柄
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_startController(MbHandle *ctx);

//@brief: 设置指定的数字输出端口位(bit)为指定值
//@param-in ctx modbus句柄
//@param-in port 端口号
//@param-in bit 位号 (0-7)
//@param-in value 要设置的值 (0或1)
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setOutput(MbHandle *ctx, int port, int bit, int value);

//@brief: 设置指定的数字输出端口(port)为指定值
//@param-in ctx modbus句柄
//@param-in port 端口号
//@param-in value 要设置的端口值
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_setOutputPort(MbHandle *ctx, int port, uint8_t value);

//@brief: 获取指定数字输出端口位(bit)的当前状态
//@param-in ctx modbus句柄
//@param-in port 端口号
//@param-in bit 位号 (0-7)
//@param-out state 输出位状态
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getOutput(MbHandle *ctx, int port, int bit, uint8_t *state);

//@brief: 获取指定数字输出端口(port)的当前状态
//@param-in ctx modbus句柄
//@param-in port 端口号
//@param-out portValue 输出端口值
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getOutputPort(MbHandle *ctx, int port, uint8_t *portValue);

//@brief: 获取指定数字输入端口位(bit)的当前状态
//@param-in ctx modbus句柄
//@param-in port 端口号
//@param-in bit 位号 (0-7)
//@param-out state 输入位状态
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getInput(MbHandle *ctx, int port, int bit, uint8_t *state);

//@brief: 获取指定数字输入端口(port)的当前状态
//@param-in ctx modbus句柄
//@param-in port 端口号
//@param-out portValue 输入端口值
//@return 成功返回1，失败返回-1
RTMODBUS_EXTERN int mb_getInputPort(MbHandle *ctx, int port, uint8_t *portValue);

#endif /* RtModbus_h */
