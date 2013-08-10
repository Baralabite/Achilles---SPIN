CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 5_000_000

   
   'GYRO             
   A_SDA = 21
   A_SCL = 20       
   A_Addr = %11010000


     ' Set pins and baud rate for PC comms 
  PC_Rx     = 31  
  PC_Tx     = 30
  PC_Baud   = 9600

  ' Register Map addresses (partial list)
   _DeviceID   = $00   'Device ID (0xE5)      r   Always %1110_0101
   _xOffset    = $1E   'User defined offset   r/w Each bit has a factor of 
   _yOffset    = $1F   'User defined offset   r/w 15.6mg/LSB per offset
   _zOffset    = $20   'User defined offset   r/w
   _FreeFallTh = $28   'freefall threshold    r/w 62.5mg/LSB Recommended between 0x05 and 0x09
   _FreeFall   = $29   'freefall time         r/w
   _Rate       = $2C   'Transfer Rate         r/w See datasheet table default 100Hz output
   _PwrCtrl    = $2D   'Measurement Controls  r/w
   _IntEnable  = $2E   'Interrupt control     r/w (%0000_0100 for freefall)
   _IntMap     = $2F   'Interrupt mapping     r/w (%0000_0000 for Int1 output)
   _IntSource  = $30   'Source of interrupts  r   (%0000_0100 freefall triggered int1)
   _DataFormat = $31   'Data format           r/w (%0000_0011 +/-16g with sign extension, 10 bit mode)
                       '                          (%1000_0000 Self-Test)
   _X0         = $32   '                      r    LSB
   _X1         = $33   '                      r    MSB
   _Y0         = $34   '                      r    LSB
   _Y1         = $35   '                      r    MSB
   _Z0         = $36   '                      r    LSB
   _Z1         = $37   '                      r    MSB
   _FifoCtrl   = $38   'FIFO control          r/w
   _FifoStat   = $39   'FIFO status           r

OBJ

  Ping:         "Ping"
  Settings:     "Settings"
  Profiler[5]:  "Profiler"
  ADC:          "ADC"
  A_I2C : "I2C"
  adxl:    "IMU"  

VAR

  long firstLoopStack[50]
  
  long frontUltrasonicDistance
  long frontIRSensor
  long leftIRSensor

  long firstLoopTime

  long xaxis, yaxis, zaxis, temp, axis, axis0, axis1
  long xgryo, ygryo, zgryo
  long gyroX, gyroY, gyroZ

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

PUB getRawGyroX

  return xgryo

PUB getRawGyroY

  return ygryo

PUB getRawGyroZ

  return zgryo

PUB getGyroX

  return gyrox

PUB getGyroY

  return gyroy

PUB getGyroZ

  return gyroz

PUB resetGyroX

  gyrox := 0

PUB resetGyroY

  gyroy := 0

PUB resetGyroZ

  gyroz := 0

PUB firstLoop

  ADC.Start(Settings#ADC_DPIN, Settings#ADC_CPIN, Settings#ADC_SPIN, Settings#ADC_MODE)
  A_I2C.Init(A_SDA,A_SCL,false)
  adxl.InitI2C 
  adxl.WrLoc(_Rate, %0000_1010)               'Set data rate at 100Hz
  adxl.WrLoc(_PwrCtrl, %0000_1000)            'Set chip to take measurements

  repeat
    Profiler[0].StartTimer
    frontUltrasonicDistance := Ping.Centimeters(Settings#PING_SIGNAL)
    frontIRSensor := ADC.in(0)
    leftIRSensor := ADC.in(1)
    updateRegisterX
    updateRegisterY
    updateRegisterZ

    gyroX := gyroX + xgryo
    gyroY := gyroY + ygryo
    gyroZ := gyroZ + zgryo
    firstLoopTime := Profiler[0].StopTimer_

PUB updateRegisterX | c, register
     
  register := $1D | %10000000                          
  c.byte[1]:=A_I2C.readLocation(A_ADDR,register,8,8)
  register := $1E | %10000000 
  c.byte[0]:=A_I2C.readLocation(A_ADDR,register,8,8)
  c:= ~~c
  xgryo := c/1000
PUB updateRegisterY | c, register      

  register := $1F | %10000000                          
  c.byte[1]:=A_I2C.readLocation(A_ADDR,register,8,8)
  register := $20 | %10000000
  c.byte[0]:=A_I2C.readLocation(A_ADDR,register,8,8)
  c:= ~~c
  ygryo := c/1000
PUB updateRegisterZ | c, register  
     
  register := $21 | %10000000                          
  c.byte[1]:=A_I2C.readLocation(A_ADDR,register,8,8)
  register := $22 | %10000000
  c.byte[0]:=A_I2C.readLocation(A_ADDR,register,8,8)
  c:= ~~c
  zgryo := c/1000 
pri writeRegister(register,value)       
  register |= %00000000                          
  A_I2C.writeLocation(A_ADDR,register,value, 8,8) 
          
    