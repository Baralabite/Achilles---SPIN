CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  Motors:       "Motors"
  Serial:       "FullDuplexSerial"
  Settings:     "Settings"
  Line:         "Line"

PUB Main | x

  Motors.start(3, 6, 9)
  Serial.start(31, 30, 0, 115200)
  x := 10

  repeat
    repeat x from -30 to 30
      Line.calculateSpeeds(x, 0)
      Motors.setLeftSpeed(Line.getLeftSpeed)
      Motors.setRightSpeed(Line.getRightSpeed)
      Serial.tx(16)
      Serial.dec(x)
      waitcnt(clkfreq/50+cnt)
    repeat x from 30 to -30
      Line.calculateSpeeds(x, 0)
      Motors.setLeftSpeed(Line.getLeftSpeed)
      Motors.setRightSpeed(Line.getRightSpeed)
      Serial.tx(16)
      Serial.dec(x)
      waitcnt(clkfreq/50+cnt)      

    {Serial.tx(16)
    Serial.dec(x)
    Serial.tx(13)
    Serial.dec(Line.getLeftSpeed)
    Serial.tx(13)
    Serial.dec(Line.getRightSpeed)}    
  