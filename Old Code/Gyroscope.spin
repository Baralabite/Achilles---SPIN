{some notes: when you change the pins on sen-10121 demo you also need to on adxl3450object}






CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 5_000_000

   
   'GYRO             
   A_SDA = 23
   A_SCL = 22       
   A_Addr = %11010000


     ' Set pins and baud rate for PC comms 
  PC_Rx     = 31  
  PC_Tx     = 30
  PC_Baud   = 115200

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
{{
   ACK      = 0        ' I2C Acknowledge
   NAK      = 1        ' I2C No Acknowledge
   Xmit     = 0        ' I2C Direction Transmit
   Recv     = 1        ' I2C Direction Receive
   BootPin  = 28       ' I2C Boot EEPROM SCL Pin
   EEPROM   = $A0      ' I2C EEPROM Device Address
   SCL      = 3       ' I2C SCL Pin
   SDA      = 4       ' I2C SDA Pin
}}

  
OBJ
         
  A_I2C : "AdvI2C"

VAR

  long xgryo, ygryo, zgryo

  
PUB Init

    A_I2C.Init(A_SDA,A_SCL,false)

PUB getX

  printRegisterX
  return xgryo

PUB getY

  printRegisterY
  return ygryo

PUB getZ

  printRegisterZ
  return zgryo
                                
pri printRegisterx | c, register
     
  register := $1D | %10000000                          
  c.byte[1]:=A_I2C.readLocation(A_ADDR,register,8,8)
  register := $1E | %10000000 
  c.byte[0]:=A_I2C.readLocation(A_ADDR,register,8,8)
  c:= ~~c
  xgryo := c
  
pri printRegistery | c, register      

  register := $1F | %10000000                          
  c.byte[1]:=A_I2C.readLocation(A_ADDR,register,8,8)
  register := $20 | %10000000
  c.byte[0]:=A_I2C.readLocation(A_ADDR,register,8,8)
  c:= ~~c
  ygryo := c
  
pri printRegisterz | c, register  
     
  register := $21 | %10000000                          
  c.byte[1]:=A_I2C.readLocation(A_ADDR,register,8,8)
  register := $22 | %10000000
  c.byte[0]:=A_I2C.readLocation(A_ADDR,register,8,8)
  c:= ~~c
  zgryo := c
    
pri writeRegister(register,value)       

register |= %00000000                          
  A_I2C.writeLocation(A_ADDR,register,value, 8,8) 
      