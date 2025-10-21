/**
 * @author	Michael Meindl, Benjamin Spiegler
 * @date	23.03.22
 * @brief	Host class to combine all other hardware-classes.
 */
#ifndef CBBBHARDWARE_H
#define CBBBHARDWARE_H
#include "CADCMMap.h"
#include "CMotor.h"
#include "CMPU9250.h"
#include "CIMUData.h"
#include "CGPIO.h"

class CBBBHardware
{
public:
	bool fetchValues(UInt16& adcValue,
					 CIMUData& sensor1Data,
					 CIMUData& sensor2Data);
	bool enableMotor();
	bool disableMotor();
	bool setTorque(float torque);
	bool openBrake();
	bool closeBrake();
public:
	CBBBHardware();
private:
	CADCMMap mADC;
	CMPU9250 mSensor1, mSensor2;
	CMotor mMotor;
};

#endif
