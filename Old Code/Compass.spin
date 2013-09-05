'' =================================================================================================
''
''   File....... jm_HMC5883L.spin
''   Purpose.... 
''   Author..... Jon "JonnyMac" McPhalen
''               Copyright (c) 2009-2013 Jon McPhalen
''               -- see below for terms of use
''   E-mail..... jon@jonmcphalen.com
''   Started....  
''   Updated.... 21 AUG 2013
''
'' =================================================================================================


con

  HMC_WR = %0011_1100
  HMC_RD = %0011_1101


con { registers }

  REG_CFG_A  =  0  { r/w }
  REG_CFG_B  =  1  { r/w }
  REG_MODE   =  2  { r/w }
  REG_X_MSB  =  3  { r }
  REG_X_LSB  =  4  { r }  
  REG_Z_MSB  =  5  { r }  
  REG_Z_LSB  =  6  { r }  
  REG_Y_MSB  =  7  { r }  
  REG_Y_LSB  =  8  { r }  
  REG_STATUS =  9  { r }  
  REG_ID_A   = 10  { r }  
  REG_ID_B   = 11  { r }  
  REG_ID_C   = 12  { r }  
  
  
obj

  i2c : "I2C"
  

var

  long  scl
  long  sda
    

pub start(device)

'' Setup I2C using default (boot EEPROM) pins

  startx(i2c#EE_SCL, i2c#EE_SDA)
         

pub startx(sclpin, sdapin)

'' Define I2C SCL (clock) and SDA (data) pins

  i2c.setupx(sclpin, sdapin)    


con

  { ----------------------------- }
  {  A C C E S S   M E T H O D S  }
  { ----------------------------- }

  
pub wr_reg(reg, b) | ackbit

'' Write byte b to reg in HMC5883L

  i2c.start
  i2c.write(HMC_WR)
  i2c.write(reg)
  ackbit := i2c.write(b)
  i2c.stop

  return ackbit


pub rd_reg(reg) | b

'' Read byte from reg in HMC5883L

  i2c.start
  i2c.write(HMC_WR)
  i2c.write(reg)
  i2c.start
  i2c.write(HMC_RD)
  b := i2c.read(i2c#NAK)
  i2c.stop

  return b


pub rd_x | value

'' Read x axis from HMC5883L

  i2c.start
  i2c.write(HMC_WR)
  i2c.write(REG_X_MSB)
  i2c.start
  i2c.write(HMC_RD)
  value := i2c.read(i2c#ACK) << 8                               ' msb first
  value |= i2c.read(i2c#NAK)
  i2c.stop

  return ~~value                                                ' extend from 16 to 32 bits


pub rd_y | value

'' Read y axis from HMC5883L

  i2c.start
  i2c.write(HMC_WR)
  i2c.write(REG_Y_MSB)
  i2c.start
  i2c.write(HMC_RD)
  value := i2c.read(i2c#ACK) << 8
  value |= i2c.read(i2c#NAK)
  i2c.stop

  return ~~value


pub rd_z | value

'' Read z axis from HMC5883L

  i2c.start
  i2c.write(HMC_WR)
  i2c.write(REG_Z_MSB)
  i2c.start
  i2c.write(HMC_RD)
  value := i2c.read(i2c#ACK) << 8
  value |= i2c.read(i2c#NAK)
  i2c.stop

  return ~~value


pub rd_xyz(p_x, p_y, p_z) | value

'' Reas x, y, and z axis values
'' -- requires pointers to longs for storage

  i2c.start
  i2c.write(HMC_WR)
  i2c.write(REG_X_MSB)
  i2c.start
  i2c.write(HMC_RD)
  
  value := i2c.read(i2c#ACK) << 8
  value |= i2c.read(i2c#ACK)
  long[p_x] := ~~value

  value := i2c.read(i2c#ACK) << 8
  value |= i2c.read(i2c#ACK)
  long[p_z] := ~~value  

  value := i2c.read(i2c#ACK) << 8
  value |= i2c.read(i2c#NAK)
  long[p_y] := ~~value

  i2c.stop


dat

{{

  Terms of Use: MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

}}