CON

  ADDRESS

OBJ

  I2C:          "I2C"
  Settings:     "Settings"

PUB init

  I2C.Initalize(Settings#IMU_SCL)
  
  I2C.Start(Settings#IMU_SCL)                           'Send start                                                                  
  I2C.Write(Settings#IMU_SCL, $3C)                      'Write address
  I2C.Write(Settings#IMU_SCL, $02)                      'Select mode register
  I2C.Write(Settings#IMU_SCL, $00)                      'Set continuous measurement mode 
  I2C.Stop(Settings#IMU_SCL)                            'Send stop
