CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 5_000_000

OBJ

  Ping:         "Ping"
  Settings:     "Settings"
  Profiler[2]:  "Profiler"
  ADC:          "ADC"
  Gyro:         "Gyroscope"
  Accel:        "Accelerometer"

VAR

  long firstLoopStack[100]
  
  long frontUltrasonicDistance
  long frontIRSensor
  long leftIRSensor

  long compassX, compassY, compassZ
  long accelX, accelY, accelZ
  long gyroX, gyroY, gyroZ

  long firstLoopTime, secondLoopTime

  byte firstLoopCogID
  
  word tiltTimer
  byte tiltDirection

PUB start

  startFirstLoop

PUB startFirstLoop

  firstLoopCogID := cognew(firstLoop, @firstLoopStack)

PUB stopFirstLoop

  cogstop(firstLoopCogID)
  'ADC.Stop

PUB restartFirstLoop

  stopFirstLoop
  startFirstLoop

PUB getFrontUltrasonic

  return frontUltrasonicDistance

PUB getFrontIRSensor

  return frontIRSensor

PUB getLeftIRSensor

  return leftIRSensor

PUB getFirstLoopTime

  return firstLoopTime

PUB getSecondLoopTime

  return secondLoopTime

PUB firstLoop | untiltTimer

  ADC.Start(Settings#ADC_DPIN, Settings#ADC_CPIN, Settings#ADC_SPIN, Settings#ADC_MODE)
  'Compass.init
  Accel.init
  Gyro.init

  repeat
    Profiler[0].StartTimer
    Profiler[1].StartTimer
    frontUltrasonicDistance := Ping.Centimeters(Settings#PING_SIGNAL)
    frontIRSensor := ADC.in(0)
    leftIRSensor := ADC.in(1)
    'Compass.rd_xyz(@compassX, @compassY, @compassZ)
    Accel.rd_xyz(@accelX, @accelY, @accelZ)
    'gyroX += Gyro.getX/5000
    'gyroY += Gyro.getY/5000
    gyroZ += Gyro.getZ/5000
    firstLoopTime := Profiler[0].StopTimer_

    if not findTiltDirection == Settings#NONE
      tiltTimer++
      untiltTimer := 0
    else
      tiltTimer := 0
      untiltTimer++

    if tiltTimer > 7
      tiltDirection := findTiltDirection
    if untiltTimer > 7
      tiltDirection := Settings#NONE
       
    
    
    waitcnt(clkfreq/(1000/(36-firstLoopTime))+cnt) 'Keep loop running nicely at 36ms
    secondLoopTime := Profiler[1].StopTimer_

PUB getTiltX

  return accelX

PUB getTiltY

  return accelY

PUB getTiltZ

  return accelZ

PUB getCompassX

  return compassX

PUB getCompassY

  return compassY

PUB getCompassZ

  return compassZ

PUB getGyroX

  return gyroX

PUB getGyroY

  return gyroY

PUB getGyroZ

  return gyroZ

PUB resetGyro

  gyroX := 0
  gyroY := 0
  gyroZ := 0

PUB isTiltingLeft

  return (getTiltY < 0 and getTiltY < (Settings#ACCELEROMETER_Y_LEVEL - Settings#ACCELEROMETER_ERROR_MARGIN))

PUB isTiltingRight

  return (getTiltY > 0 and getTiltY > (Settings#ACCELEROMETER_Y_LEVEL + Settings#ACCELEROMETER_ERROR_MARGIN)) 

PUB isTiltingForward

  return (getTiltX < 0 and getTiltX < (Settings#ACCELEROMETER_X_LEVEL - Settings#ACCELEROMETER_ERROR_MARGIN))

PUB isTiltingBackward

  return (getTiltX > 0 and getTiltX > (Settings#ACCELEROMETER_X_LEVEL + Settings#ACCELEROMETER_ERROR_MARGIN))  

PUB findTiltDirection

  if isTiltingLeft
    return Settings#LEFT
  elseif isTiltingRight
    return Settings#RIGHT
  elseif isTiltingForward
    return Settings#FORWARD
  elseif isTiltingBackward
    return Settings#BACKWARD
  else
    return Settings#NONE

PUB getTiltDirection

  return tiltDirection

PRI abs_(number)

  if number < 0
    return -number
  else
    return number  