CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 5_000_000

OBJ

  Ping:         "Ping"
  Settings:     "Settings"
  Profiler[2]:  "Profiler"
  ADC:          "ADC"
  Gyro:         "Gyroscope"

VAR

  long firstLoopStack[100], ADCLoopStack[100]
  
  long frontUltrasonicDistance
  long frontIRSensor
  long leftIRSensor

  long compassX, compassY, compassZ
  long accelX, accelY, accelZ
  long gyroX, gyroY, gyroZ

  long firstLoopTime, secondLoopTime

  byte firstLoopCogID

PUB start

  startFirstLoop

PUB startFirstLoop

  firstLoopCogID := cognew(firstLoop, @firstLoopStack)

PUB stopFirstLoop

  cogstop(firstLoopCogID)
  ADC.Stop

PUB startADCLoop

  cognew(ADCLoop, @ADCLoopStack)

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

PUB firstLoop

  ADC.Start(Settings#ADC_DPIN, Settings#ADC_CPIN, Settings#ADC_SPIN, Settings#ADC_MODE)
  'Compass.init
  'Accel.init
  Gyro.init

  repeat
    Profiler[0].StartTimer
    Profiler[1].StartTimer
    frontUltrasonicDistance := Ping.Centimeters(Settings#PING_SIGNAL)
    frontIRSensor := ADC.in(0)
    leftIRSensor := ADC.in(1)
    'Compass.rd_xyz(@compassX, @compassY, @compassZ)
    'Accel.rd_xyz(@accelX, @accelY, @accelZ)
    gyroX += Gyro.getX/5000
    gyroY += Gyro.getY/5000
    gyroZ += Gyro.getZ/5000
    firstLoopTime := Profiler[0].StopTimer_
    
    
    waitcnt(clkfreq/(1000/(36-firstLoopTime))+cnt) 'Keep loop running nicely at 20ms
    secondLoopTime := Profiler[1].StopTimer_

PUB ADCLoop

  ADC.Start(Settings#ADC_DPIN, Settings#ADC_CPIN, Settings#ADC_SPIN, Settings#ADC_MODE)

  repeat
    frontIRSensor := ADC.in(0)
    leftIRSensor := ADC.in(1)

    waitcnt(clkfreq/100+cnt)

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
