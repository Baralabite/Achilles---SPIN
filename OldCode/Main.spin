CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  ADDRESS = $1E

OBJ

  Serial        : "Serial"
  'Sensor        : "Sensors"
  'Motor         : "HB"
  'LCD           : "LCD"
  'PC            : "PC"
  'Profiler[2]   : "Profiler"
  'Claw          : "Claw"
  'Cog           : "CogManager"
  I2C           : "I2C"
  IMU           : "IMU"

PUB Main | x, y, z

  Serial.start(31, 30, 0, 9600)
  IMU.Start(0, 1)

  repeat

    Serial.tx(16)
    
    Serial.dec(IMU.GetRX)
    
    waitcnt(clkfreq/10+cnt)

  
  