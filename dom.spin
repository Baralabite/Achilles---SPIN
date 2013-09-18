CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  Motors: "Motors"
  Serial: "FullDuplexSerialPlus"
  Ultrasonic: "Ping"

VAR

  long a
  long b
  long age

PUB Main

  'Motors.start(3, 6, 9)

  Serial.start(31, 30, 0, 9600)

  repeat
    Serial.tx(16)
    Serial.dec(Ultrasonic.centimeters(20))
    waitcnt(clkfreq/10+cnt)
   
  
  {Serial.str(string("Type your age here: "))
  age := Serial.rxDec
  Serial.tx(13)
  Serial.dec(age)}