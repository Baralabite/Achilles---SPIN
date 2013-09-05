CON


  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000


OBJ


  Gyro:         "Gyroscope"
  Serial:       "FullDuplexSerial"


VAR


  long x, y, z


PUB Main


  Serial.start(31, 30, 0, 115200)


  Gyro.init


  repeat
    Serial.tx(16)
    Serial.dec(Gyro.getX)
    Serial.tx(13)
    Serial.dec(Gyro.getY)
    Serial.tx(13)
    Serial.dec(Gyro.getZ)
    waitcnt(clkfreq/10+cnt)