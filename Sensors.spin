CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 5_000_000

OBJ

  Ping:         "Ping"
  Settings:     "Settings"
  Profiler[1]:  "Profiler"
  ADC:          "ADC"

VAR

  long firstLoopStack[50]
  
  long frontUltrasonicDistance
  long frontIRSensor
  long leftIRSensor

  long firstLoopTime

PUB start

  cognew(firstLoop, @firstLoopStack)

PUB getFrontUltrasonic

  return frontUltrasonicDistance

PUB getFrontIRSensor

  return frontIRSensor

PUB getLeftIRSensor

  return leftIRSensor

PUB getFirstLoopTime

  return firstLoopTime

PUB firstLoop

  ADC.Start(Settings#ADC_DPIN, Settings#ADC_CPIN, Settings#ADC_SPIN, Settings#ADC_MODE)

  repeat
    Profiler[0].StartTimer
    frontUltrasonicDistance := Ping.Centimeters(Settings#PING_SIGNAL)
    frontIRSensor := ADC.in(0)
    leftIRSensor := ADC.in(1)


PUB resetGyroZ 'DEPRICATED

PUB getGyroZ 'DEPRICATED