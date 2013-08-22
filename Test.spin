CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  I2C: "I2C"
  Serial: "FullDuplexSerial"
  Settings: "Settings"

VAR

  long x, y, z

PUB Main

  Serial.start(31, 30, 0, 9600)
  Serial.str(string("I2C Test", 13))
  i2c_init
  i2c_loop  


PUB i2c_init

  Serial.str(string("Initalizing Compass...", 13))
  I2C.Initialize(Settings#IMU_SCL)  

  'I2C.Start(Settings#IMU_SCL)                           'Send start                                                                  
  'I2C.Write(Settings#IMU_SCL, $3C)                      'Write address
  'I2C.Write(Settings#IMU_SCL, $00)                      'Select CRA
  'I2C.Write(Settings#IMU_SCL, $70)                      'Set 8-average, 15Hz default, normal measurement 
  'I2C.Stop(Settings#IMU_SCL)                            'Send stop

  'I2C.Start(Settings#IMU_SCL)                           'Send start                                                                  
  'I2C.Write(Settings#IMU_SCL, $3C)                      'Write address
  'I2C.Write(Settings#IMU_SCL, $01)                      'Select CRB
  'I2C.Write(Settings#IMU_SCL, $A0)                      'Set Gain=5 
  'I2C.Stop(Settings#IMU_SCL)                            'Send stop

  I2C.Start(Settings#IMU_SCL)                           'Send start                                                                  
  I2C.Write(Settings#IMU_SCL, $3C)                      'Write address
  I2C.Write(Settings#IMU_SCL, $02)                      'Select mode register
  I2C.Write(Settings#IMU_SCL, $00)                      'Set continuous measurement mode 
  I2C.Stop(Settings#IMU_SCL)                            'Send stop
  
  Serial.str(string("Initalized!", 13))

PUB i2c_loop

  Serial.str(string("Entering loop", 13))
  repeat
    I2C.Start(Settings#IMU_SCL)                         'Send start
    I2C.Write(Settings#IMU_SCL, $3C)                    'Write address
    I2C.Write(Settings#IMU_SCL, $03)                    'Select register 3, X MSB register
    I2C.Start(Settings#IMU_SCL)                         'Send reset
    I2C.Write(Settings#IMU_SCL, $3D)                    'Write address
    
    x := I2C.Read(Settings#IMU_SCL, 0) << 8
    x |= I2C.Read(Settings#IMU_SCL, 0)
    x := ~~x    
    y := I2C.Read(Settings#IMU_SCL, 0) << 8
    y |= I2C.Read(Settings#IMU_SCL, 0)
    y := ~~y    
    z := I2C.Read(Settings#IMU_SCL, 0) << 8
    z |= I2C.Read(Settings#IMU_SCL, 0)
    z := ~~z
        
    I2C.Stop(Settings#IMU_SCL)

    Serial.tx(16)
    Serial.dec(x)
    Serial.tx(13)
    Serial.dec(y)
    Serial.tx(13)
    Serial.dec(z)
    Serial.tx(13)
    
    waitcnt(clkfreq/10+cnt)
    
    
  
    