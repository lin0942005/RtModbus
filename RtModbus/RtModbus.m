//
//  RtModbus.m
//  Test2
//
//  Created by Operator on 2026/1/29.
//

#import <Foundation/Foundation.h>
#import "RtModbus.h"

// 定义全局变量
uint16_t readBuf[2];      //存储32位寄存器值
uint16_t m_readInt = 0;
uint16_t m_tick = 0;

// 建立Modbus连接
int mb_openCommModbusTCP(const char* address, int port, MbHandle **hand)
{
    modbus_t **ctx = (modbus_t**) hand;
    *ctx = modbus_new_tcp(address, port);
    modbus_set_response_timeout(*ctx, 2, 0);
    if (modbus_connect(*ctx) != 0) {
        modbus_close(*ctx);
        modbus_free(*ctx);
        *ctx = NULL;
        return -1;
    }
    return 1;
}

// 获取实际轴数
int mb_getAxisNum(MbHandle *ctx, int *axisNum)
{
    uint16_t readValue;
    int ret = modbus_read_input_registers(ctx, DEV_AXIS_COUNT, 1, &readValue);
    if (ret != 1) {
        return -1;
    }
    *axisNum = (int)readValue;
    return 1;
}

// 获取轴状态
int mb_getAxisState(MbHandle *ctx, int axisId, uint16_t *axisState)
{
    uint16_t axisBase = AXIS_STATE + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 1, axisState);
    return (ret == 1) ? 1 : -1;
}

// 获取轴IO状态
int mb_getAxisIoState(MbHandle *ctx, int axisId, uint16_t *axisIoState)
{
    uint16_t axisBase = AXIS_IO_STATE + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 1, axisIoState);
    return (ret == 1) ? 1 : -1;
}

// 获取轴理论位置
int mb_getAxisCmdPos(MbHandle *ctx, int axisId, float *cmdPos)
{
    uint16_t axisBase = AXIS_CMD_POS + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *cmdPos = modbus_get_float(readBuf);
    return 1;
}

// 获取轴实际位置
int mb_getAxisActPos(MbHandle *ctx, int axisId, float *actPos)
{
    uint16_t axisBase = AXIS_ACT_POS + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *actPos = modbus_get_float(readBuf);
    return 1;
}

// 获取轴PPU
int mb_getAxisPPU(MbHandle *ctx, int axisId, float *ppu)
{
    uint16_t axisBase = PARAM_PPU + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *ppu = modbus_get_float(readBuf);
    return 1;
}

// 获取轴最大速度
int mb_getAxisMaxVel(MbHandle *ctx, int axisId, float *max_vel)
{
    uint16_t axisBase = PARAM_MAX_VEL + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *max_vel = modbus_get_float(readBuf);
    return 1;
}

// 获取轴加速度
int mb_getAxisAcc(MbHandle *ctx, int axisId, float *acc)
{
    uint16_t axisBase = PARAM_ACC + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *acc = modbus_get_float(readBuf);
    return 1;
}

// 获取轴减速度
int mb_getAxisDec(MbHandle *ctx, int axisId, float *dec)
{
    uint16_t axisBase = PARAM_DEC + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *dec = modbus_get_float(readBuf);
    return 1;
}

// 获取轴加加速度
int mb_getAxisJerk(MbHandle *ctx, int axisId, float *jerk)
{
    uint16_t axisBase = PARAM_JERK + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *jerk = modbus_get_float(readBuf);
    return 1;
}

// 获取轴急停减速度
int mb_getAxisKillDec(MbHandle *ctx, int axisId, float *kill_dec)
{
    uint16_t axisBase = PARAM_KILL_DEC + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *kill_dec = modbus_get_float(readBuf);
    return 1;
}

// 获取轴正限位使能状态
int mb_getSPLimitEnableState(MbHandle *ctx, int axisId, uint16_t *enable)
{
    uint16_t axisBase = PARAM_SW_Positive_LIMIT_ENABLE + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 1, readBuf);
    if (ret != 1) {
        return -1;
    }
    *enable = readBuf[0];
    return 1;
}

// 获取轴正限位值
int mb_getSPLimitPosition(MbHandle *ctx, int axisId, float *value)
{
    uint16_t axisBase = PARAM_SW_Positive_LIMIT_VALUE + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *value = modbus_get_float(readBuf);
    return 1;
}

// 获取轴负限位使能状态
int mb_getSNLimitEnableState(MbHandle *ctx, int axisId, uint16_t *enable)
{
    uint16_t axisBase = PARAM_SW_Negative_LIMIT_ENABLE + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 1, readBuf);
    if (ret != 1) {
        return -1;
    }
    *enable = readBuf[0];
    return 1;
}

// 获取轴负限位值
int mb_getSNLimitPosition(MbHandle *ctx, int axisId, float *value)
{
    uint16_t axisBase = PARAM_SW_Negative_LIMIT_VALUE + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *value = modbus_get_float(readBuf);
    return 1;
}

// 获取轴旋转方向
int mb_getAxisInvertDir(MbHandle *ctx, int axisId, uint16_t *dir)
{
    uint16_t axisBase = PARAM_INVERT_DIR + (axisId * 50);
    int ret = modbus_read_registers(ctx, axisBase, 1, readBuf);
    if (ret != 1) {
        return -1;
    }
    *dir = readBuf[0];
    return 1;
}

// 获取轴回零模式
int mb_getAxisHomeMode(MbHandle *ctx, uint16_t *homeMode)
{
    int ret = modbus_read_registers(ctx, HOME_MODE, 1, readBuf);
    if (ret != 1) {
        return -1;
    }
    *homeMode = readBuf[0];
    return 1;
}

// 获取轴回零开关速度
int mb_getAxisHomeSwitchVel(MbHandle *ctx, float *switchVel)
{
    int ret = modbus_read_registers(ctx, HOME_SWITCH_VEL, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *switchVel = modbus_get_float(readBuf);
    return 1;
}

// 获取轴回零零点速度
int mb_getAxisHomeZeroVel(MbHandle *ctx, float *zeroVel)
{
    int ret = modbus_read_registers(ctx, HOME_ZERO_VEL, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *zeroVel = modbus_get_float(readBuf);
    return 1;
}

// 获取轴回零加速度
int mb_getAxisHomeAcc(MbHandle *ctx, float *homeAcc)
{
    int ret = modbus_read_registers(ctx, HOME_ACC, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *homeAcc = modbus_get_float(readBuf);
    return 1;
}

// 获取轴回零偏移量
int mb_getAxisHomeOffset(MbHandle *ctx, float *offset)
{
    int ret = modbus_read_registers(ctx, HOME_OFFSET, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *offset = modbus_get_float(readBuf);
    return 1;
}

// 获取轴JOG速度
int mb_getAxisJogSpeed(MbHandle *ctx, float *jogSpeed)
{
    int ret = modbus_read_registers(ctx, JOG_SPEED, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *jogSpeed = modbus_get_float(readBuf);
    return 1;
}

// 获取轴MOVE移动速度
int mb_getAxisMoveVel(MbHandle *ctx, float *moveVel)
{
    int ret = modbus_read_registers(ctx, MOVE_VELOCITY, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *moveVel = modbus_get_float(readBuf);
    return 1;
}

// 获取轴MOVE目标位置
int mb_getAxisMoveEndPos(MbHandle *ctx, float *endPos)
{
    int ret = modbus_read_registers(ctx, MOVE_END_POS, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    *endPos = modbus_get_float(readBuf);
    return 1;
}

// 设置轴PPU
int mb_setAxisPPU(MbHandle *ctx, int axisId, float ppu)
{
    m_readInt = 0;
    uint16_t addrsetppuError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_PPU + (axisId * 50);
    modbus_set_float(ppu, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetppuError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴最大速度
int mb_setAxisMaxVel(MbHandle *ctx, int axisId, float max_vel)
{
    m_readInt = 0;
    uint16_t addrsetmaxvelError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_MAX_VEL + (axisId * 50);
    modbus_set_float(max_vel, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetmaxvelError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴加速度
int mb_setAxisAcc(MbHandle *ctx, int axisId, float acc)
{
    m_readInt = 0;
    uint16_t addrsetaccError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_ACC + (axisId * 50);
    modbus_set_float(acc, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetaccError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴减速度
int mb_setAxisDec(MbHandle *ctx, int axisId, float dec)
{
    m_readInt = 0;
    uint16_t addrsetdecError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_DEC + (axisId * 50);
    modbus_set_float(dec, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetdecError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴加加速度
int mb_setAxisJerk(MbHandle *ctx, int axisId, float jerk)
{
    m_readInt = 0;
    uint16_t addrsetjerkError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_JERK + (axisId * 50);
    modbus_set_float(jerk, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetjerkError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴急停减速度
int mb_setAxisKillDec(MbHandle *ctx, int axisId, float kill_dec)
{
    m_readInt = 0;
    uint16_t addrsetkilldecError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_KILL_DEC + (axisId * 50);
    modbus_set_float(kill_dec, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetkilldecError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴正限位使能状态
int mb_setSPLimitEnableState(MbHandle *ctx, int axisId, uint16_t enable)
{
    m_readInt = 0;
    uint16_t addrsetsplimitenableError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_SW_Positive_LIMIT_ENABLE + (axisId * 50);
    int ret = modbus_write_register(ctx, axisBase, enable);
    if (ret != 1) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetsplimitenableError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴正限位值
int mb_setSPLimitPosition(MbHandle *ctx, int axisId, float value)
{
    m_readInt = 0;
    uint16_t addrsetsplimitpositionError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_SW_Positive_LIMIT_VALUE + (axisId * 50);
    modbus_set_float(value, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetsplimitpositionError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴负限位使能状态
int mb_setSNLimitEnableState(MbHandle *ctx, int axisId, uint16_t enable)
{
    m_readInt = 0;
    uint16_t addrsetsnlimitenableError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_SW_Negative_LIMIT_ENABLE + (axisId * 50);
    int ret = modbus_write_register(ctx, axisBase, enable);
    if (ret != 1) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetsnlimitenableError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴负限位值
int mb_setSNLimitPosition(MbHandle *ctx, int axisId, float value)
{
    m_readInt = 0;
    uint16_t addrsetsnlimitpositionError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_SW_Negative_LIMIT_VALUE + (axisId * 50);
    modbus_set_float(value, readBuf);
    int ret = modbus_write_registers(ctx, axisBase, 2, readBuf);
    if (ret != 2) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetsnlimitpositionError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴旋转方向
int mb_setAxisInvertDir(MbHandle *ctx, int axisId, uint16_t dir)
{
    m_readInt = 0;
    uint16_t addrsetinvertdurError = (axisId * 50) + AXIS_LAST_ERROR;
    uint16_t axisBase = PARAM_INVERT_DIR + (axisId * 50);
    int ret = modbus_write_register(ctx, axisBase, dir);
    if (ret != 1) {
        return ret;
    }
    modbus_read_input_registers(ctx, addrsetinvertdurError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 设置轴回零轴号
int mb_setHomeAxis(MbHandle *ctx, uint16_t homeAxis)
{
    int ret = modbus_write_register(ctx, HOME_AXIS_ID, homeAxis);
    if (ret != 1) {
        return -1;
    } else {
        return 1;
    }
}

// 设置轴回零模式
int mb_setAxisHomeMode(MbHandle *ctx, uint16_t axisId, uint16_t homeMode)
{
    m_tick = 0;
    m_readInt = 0;
    uint16_t addrParamDone = (axisId * 50) + HOME_PARAM_DONE;
    uint16_t addrParamSuccess = (axisId * 50) + HOME_PARAM_SUCCESS;

    modbus_write_register(ctx, HOME_MODE, homeMode);
    while(m_tick < HOME_OUT_TIME)
    {
        modbus_read_input_registers(ctx, addrParamDone, 1, &m_readInt);
        if(m_readInt == 1) break;
        m_tick++;
        usleep(1000);
    }
    modbus_read_input_registers(ctx, addrParamSuccess, 1, &m_readInt);
    if (m_readInt != 1) {
        return -1;
    } else {
        return 1;
    }
}

// 设置轴回零开关速度
int mb_setAxisHomeSwitchVel(MbHandle *ctx, uint16_t axisId, Float32 switchVel)
{
    m_tick = 0;
    m_readInt = 0;
    uint16_t addrParamDone = (axisId * 50) + HOME_PARAM_DONE;
    uint16_t addrParamSuccess = (axisId * 50) + HOME_PARAM_SUCCESS;

    modbus_set_float_cdab(switchVel, readBuf);
    modbus_write_registers(ctx, HOME_SWITCH_VEL, 2, readBuf);
    while(m_tick < HOME_OUT_TIME)
    {
        modbus_read_input_registers(ctx, addrParamDone, 1, &m_readInt);
        if(m_readInt == 1) break;
        m_tick++;
        usleep(1000);
    }
    modbus_read_input_registers(ctx, addrParamSuccess, 1, &m_readInt);
    if (m_readInt != 1) {
        return -1;
    } else {
        return 1;
    }
}

// 设置轴回零零点速度
int mb_setAxisHomeZeroVel(MbHandle *ctx, uint16_t axisId, Float32 zeroVel)
{
    m_tick = 0;
    m_readInt = 0;
    uint16_t addrParamDone = (axisId * 50) + HOME_PARAM_DONE;
    uint16_t addrParamSuccess = (axisId * 50) + HOME_PARAM_SUCCESS;

    modbus_set_float_cdab(zeroVel, readBuf);
    modbus_write_registers(ctx, HOME_ZERO_VEL, 2, readBuf);
    while(m_tick < HOME_OUT_TIME)
    {
        modbus_read_input_registers(ctx, addrParamDone, 1, &m_readInt);
        if(m_readInt == 1) break;
        m_tick++;
        usleep(1000);
    }
    modbus_read_input_registers(ctx, addrParamSuccess, 1, &m_readInt);
    if (m_readInt != 1) {
        return -1;
    } else {
        return 1;
    }
}

// 设置轴回零加速度
int mb_setAxisHomeAcc(MbHandle *ctx, uint16_t axisId, Float32 homeAcc)
{
    m_tick = 0;
    m_readInt = 0;
    uint16_t addrParamDone = (axisId * 50) + HOME_PARAM_DONE;
    uint16_t addrParamSuccess = (axisId * 50) + HOME_PARAM_SUCCESS;

    modbus_set_float_cdab(homeAcc, readBuf);
    modbus_write_registers(ctx, HOME_ACC, 2, readBuf);
    while(m_tick < HOME_OUT_TIME)
    {
        modbus_read_input_registers(ctx, addrParamDone, 1, &m_readInt);
        if(m_readInt == 1) break;
        m_tick++;
        usleep(1000);
    }
    modbus_read_input_registers(ctx, addrParamSuccess, 1, &m_readInt);
    if (m_readInt != 1) {
        return -1;
    } else {
        return 1;
    }
}

// 设置轴回零偏移量
int mb_setAxisHomeOffset(MbHandle *ctx, uint16_t axisId, int32_t offset)
{
    m_tick = 0;
    m_readInt = 0;
    uint16_t addrParamDone = (axisId * 50) + HOME_PARAM_DONE;
    uint16_t addrParamSuccess = (axisId * 50) + HOME_PARAM_SUCCESS;

    modbus_set_float_cdab(offset, readBuf);
    modbus_write_registers(ctx, HOME_OFFSET, 2, readBuf);
    while(m_tick < HOME_OUT_TIME)
    {
        modbus_read_input_registers(ctx, addrParamDone, 1, &m_readInt);
        if(m_readInt == 1) break;
        m_tick++;
        usleep(1000);
    }
    modbus_read_input_registers(ctx, addrParamSuccess, 1, &m_readInt);
    if (m_readInt != 1) {
        return -1;
    } else {
        return 1;
    }
}

// 设置轴JOG速度
int mb_setAxisJogSpeed(MbHandle *ctx, Float32 jogSpeed)
{
    modbus_set_float_cdab(jogSpeed, readBuf);
    int ret = modbus_write_registers(ctx, JOG_SPEED, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    return 1;
}

// 设置轴MOVE移动速度
int mb_setAxisMoveVel(MbHandle *ctx, Float32 moveVel)
{
    modbus_set_float_cdab(moveVel, readBuf);
    int ret = modbus_write_registers(ctx, MOVE_VELOCITY, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    return 1;
}

// 设置轴MOVE目标位置
int mb_setAxisMoveEndPos(MbHandle *ctx, Float32 endPos)
{
    modbus_set_float_cdab(endPos, readBuf);
    int ret = modbus_write_registers(ctx, MOVE_END_POS, 2, readBuf);
    if (ret != 2) {
        return -1;
    }
    return 1;
}

// 轴使能
int mb_enable(MbHandle *ctx, int axisId)
{
    m_readInt = 0;
    uint16_t addrenableError = (axisId * 50) + AXIS_LAST_ERROR;
    int ret = modbus_write_register(ctx, ENABLE_AXIS, axisId);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrenableError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 轴断使能
int mb_disable(MbHandle *ctx, int axisId)
{
    m_readInt = 0;
    uint16_t addrdisableError = (axisId * 50) + AXIS_LAST_ERROR;
    int ret = modbus_write_register(ctx, DISABLE_AXIS, axisId);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrdisableError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 清除报警
int mb_clearAlarm(MbHandle *ctx, int axisId)
{
    m_readInt = 0;
    uint16_t addrclearError = (axisId * 50) + AXIS_LAST_ERROR;
    int ret = modbus_write_register(ctx, CLEAR_AXIS_ALARM, axisId);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrclearError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 轴停止
int mb_halt(MbHandle *ctx, int axisId)
{
    m_readInt = 0;
    uint16_t addrhaltError = (axisId * 50) + AXIS_LAST_ERROR;
    int ret = modbus_write_register(ctx, HALT_AXIS, axisId);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrhaltError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// 轴急停
int mb_kill(MbHandle *ctx, int axisId)
{
    m_readInt = 0;
    uint16_t addrkillError = (axisId * 50) + AXIS_LAST_ERROR;
    int ret = modbus_write_register(ctx, KILL_AXIS, axisId);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrkillError, 1, &m_readInt);
    if (m_readInt) {
        return m_readInt;
    } else {
        return 1;
    }
}

// JOG
int mb_jog(MbHandle *ctx, int axisId, int dir, Float32 jogSpeed)
{
    uint16_t addrjogError = (axisId * 50) + AXIS_LAST_ERROR;
    if (modbus_write_register(ctx, JOG_AXIS_ID, axisId) != 1) return -1;
    modbus_set_float_cdab(jogSpeed, readBuf);
    if (modbus_write_registers(ctx, JOG_SPEED, 2, readBuf) != 2) return -1;
    int ret = modbus_write_register(ctx, JOG_CMD, dir);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrjogError, 1, &m_readInt);
    if (m_readInt){
        return m_readInt;
    } else {
        return 1;
    }
}

// HOME
int mb_startHome(MbHandle *ctx, int axisId, int cmd)
{
    m_tick = 0;
    m_readInt = 0;
    uint16_t addrMoveDone = (axisId * 50) + HOME_MOVE_DONE;
    uint16_t addrMoveSuccess = (axisId * 50) + HOME_MOVE_SUCCESS;
    uint16_t addrhomeError = (axisId * 50) + AXIS_LAST_ERROR;
    int ret = modbus_write_register(ctx, HOME_CMD, cmd);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrhomeError, 1, &m_readInt);
    if (m_readInt){
        return m_readInt;
    }
    while(m_tick < HOME_OUT_TIME)
    {
        modbus_read_input_registers(ctx, addrMoveDone, 1, &m_readInt);
        if(m_readInt == 1) break;
        m_tick++;
        usleep(1000);
    }
    modbus_read_input_registers(ctx, addrMoveSuccess, 1, &m_readInt);

    if (m_readInt != 1 ) {
        return -1;
    } else {
        return 1;
    }
}

// MOVE
int mb_move(MbHandle *ctx, int axisId, int moveMode, Float32 moveSpeed, Float32 endPos)
{
    m_readInt = 0;
    uint16_t addrmoveError = (axisId * 50) + AXIS_LAST_ERROR;
    int ret = modbus_write_register(ctx, MOVE_AXIS_ID, axisId);
    if (ret != 1)
        return ret;
    modbus_set_float_cdab(moveSpeed, readBuf);
    ret = modbus_write_registers(ctx, MOVE_VELOCITY, 2, readBuf);
    if (ret != 2)
        return ret;
    modbus_set_float_cdab(endPos, readBuf);
    ret = modbus_write_registers(ctx, MOVE_END_POS, 2, readBuf);
    if (ret != 2)
        return ret;
    int ret = modbus_write_register(ctx, MOVE_CMD, moveMode);
    if (ret != 1)
        return ret;
    modbus_read_input_registers(ctx, addrhomeError, 1, &m_readInt);
    if (m_readInt){
        return m_readInt;
    } else {
        return 1;
    }
}

// 获取错误信息
const char *mb_getErrorMessage(int errnum)
{
    m_readInt = 0;
    if (errnum == EMBBADCRC || errnum == EMBBADDATA || errnum == EMBBADEXC || errnum == EMBUNKEXC ||errnum == EMBMDATA || errnum == EMBBADSLAVE )
        return modbus_strerror(errnum);
    if (errnum) {
        static char error_msg[256];
        snprintf(error_msg, sizeof(error_msg), "Error Code: %d", errnum);
        return error_msg;
    }
    return "No error";
}

// 获取轴最后错误码
int mb_getAxisLastError(MbHandle *ctx, int axisId, uint16_t *lastError)
{
    uint16_t axisBase = AXIS_LAST_ERROR + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 1, lastError);
    return (ret == 1) ? 1 : -1;
}

// 获取轴回零参数完成状态
int mb_getHomeParamDone(MbHandle *ctx, int axisId, uint16_t *paramDone)
{
    uint16_t axisBase = HOME_PARAM_DONE + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 1, paramDone);
    return (ret == 1) ? 1 : -1;
}

// 获取轴回零参数设置成功状态
int mb_getHomeParamSuccess(MbHandle *ctx, int axisId, uint16_t *paramSuccess)
{
    uint16_t axisBase = HOME_PARAM_SUCCESS + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 1, paramSuccess);
    return (ret == 1) ? 1 : -1;
}

// 获取轴回零移动完成状态
int mb_getHomeMoveDone(MbHandle *ctx, int axisId, uint16_t *moveDone)
{
    uint16_t axisBase = HOME_MOVE_DONE + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 1, moveDone);
    return (ret == 1) ? 1 : -1;
}

// 获取轴回零移动成功状态
int mb_getHomeMoveSuccess(MbHandle *ctx, int axisId, uint16_t *moveSuccess)
{
    uint16_t axisBase = HOME_MOVE_SUCCESS + (axisId * 50);
    int ret = modbus_read_input_registers(ctx, axisBase, 1, moveSuccess);
    return (ret == 1) ? 1 : -1;
}

// 获取设备错误码
int mb_getDeviceError(MbHandle *ctx, uint16_t *deviceError)
{
    int ret = modbus_read_input_registers(ctx, MB_DeviceError, 1, deviceError);
    return (ret == 1) ? 1 : -1;
}

// 获取EtherCAT连接状态
int mb_getEtherCATStatus(MbHandle *ctx, uint16_t *connectStatus)
{
    int ret = modbus_read_input_registers(ctx, ETHERCAT_STATE, 1, connectStatus); 
    return (ret == 1) ? 1 : -1;
}

// 获得Modbus连接状态
int mb_getConnectStatus(MbHandle *ctx)
{
    int ret = modbus_get_socket(ctx);
    return (ret != -1) ? 1 : -1;
}

// 关闭Modbus连接
void mb_closeCommModbusTCP(MbHandle *ctx)
{
    if (ctx != NULL) {
        modbus_close(ctx);
        modbus_free(ctx);
    }
}

// 重启控制器
int mb_resetController(MbHandle *ctx)
{
    int ret = modbus_write_register(ctx, RESET_CONTROLLER, 1);
    return (ret == 1) ? 1 : -1;
}

// 启动控制器
int mb_startController(MbHandle *ctx)
{
    int ret = modbus_write_register(ctx, START_CONTROLLER, 1);
    return (ret == 1) ? 1 : -1;
}

// 设置指定的数字输出端口位(bit)
int mb_setOutput(MbHandle *ctx, int port, int bit, int value)
{
    // 先读取当前端口值
    uint8_t currentValue;
    int ret = mb_getOutputPort(ctx, port, &currentValue);
    if (ret != 1) {
        return -1;
    }
    
    // 设置指定位
    if (value) {
        currentValue |= (1 << bit);    // 设置位为1
    } else {
        currentValue &= ~(1 << bit);   // 设置位为0
    }
    
    // 写回端口
    return mb_setOutputPort(ctx, port, currentValue);
}

// 设置指定的数字输出端口(port)
int mb_setOutputPort(MbHandle *ctx, int port, uint8_t value)
{
    int coilAddr = port * 8;
    uint8_t bits[8];
    for (int i = 0; i < 8; i++) {
            bits[i] = (value >> (8 - 1 - i)) & 0x01;
        }
    
    int ret = modbus_write_bits(ctx, coilAddr, 8, bits);
    return (ret == 8) ? 1 : -1;
}

// 获取指定数字输出端口位(bit)的状态
int mb_getOutput(MbHandle *ctx, int port, int bit, uint8_t *state)
{
    uint8_t portValue;
    int ret = mb_getOutputPort(ctx, port, &portValue);
    if (ret != 1) {
        return -1;
    }
    
    *state = (portValue >> bit) & 0x01;
    return 1;
}

// 获取指定数字输出端口(port)的状态
int mb_getOutputPort(MbHandle *ctx, int port, uint8_t *portValue)
{
    int coilAddr = port * 8;
    uint8_t bits[8];
    
    int ret = modbus_read_bits(ctx, coilAddr, 8, bits);
    if (ret != 8) {
        return -1;
    }
    // 将各个位组合成端口值
    *portValue = 0;
    for (int i = 0; i < 8; i++) {
        if (bits[i]) {
            *portValue |= (1 << (8 - 1 - i));
        }
    }
    return 1;
}

// 获取指定数字输入端口位(bit)的状态
int mb_getInput(MbHandle *ctx, int port, int bit, uint8_t *state)
{
    uint8_t portValue;
    int ret = mb_getInputPort(ctx, port, &portValue);
    if (ret != 1) {
        return -1;
    }
    
    *state = (portValue >> bit) & 0x01;
    return 1;
}

// 获取指定数字输入端口(port)的状态
int mb_getInputPort(MbHandle *ctx, int port, uint8_t *portValue)
{
    int inputAddr = port * 8;
    uint8_t bits[8];
    
    int ret = modbus_read_input_bits(ctx, inputAddr, 8, bits);
    if (ret != 8) {
        return -1;
    }
    
    // 将各个位组合成端口值
    *portValue = 0;
    for (int i = 0; i < 8; i++) {
        if (bits[i]) {
            *portValue |= (1 << (8 - 1 - i));
        }
    }
    return 1;
}
