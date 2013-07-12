CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  Serial        : "Serial"
  Sensor        : "Sensors"
  Motor         : "HB"
  LCD           : "LCD"
  PC            : "PC"
  Profiler[2]   : "Profiler"
  Claw          : "Claw"
  Cog           : "CogManager"

PUB Main

  Start
  Loop
  Stop
  
PUB Start

  Sensor.Start(4, 8, 9, 10, 11, 12, 5)
  
  SetSpeedFast
  Motor.Start(1, 2, 3)
  