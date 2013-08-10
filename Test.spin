CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  Serial:       "FullDuplexSerial~"
  Button:       "Button"
  Pot:          "Potentiometer"
  Settings:     "Settings"
  Motors:       "Motors"
  ADC:          "ADC"
  CMUCam:       "CMUCam"
  Ping:         "Ping"     

PUB Main

  Serial.start(31, 30, 0, 115200)

  repeat
    Serial.tx(16)
    Serial.dec(Ping.Centimeters(1))
    waitcnt(clkfreq/10+cnt)
    
    