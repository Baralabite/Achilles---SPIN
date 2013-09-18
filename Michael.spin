CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
  
OBJ

  CMUCam:        "CMUCam"
  Motors:        "Motors"
  Settings:      "Settings"
  Line:          "Line"
  Serial:        "FullDuplexSerial"
  Profiler[1]:   "Profiler"

VAR

  long stack[50], stack1[50]
  long location

  byte leftSpeed, rightSpeed
  byte leftSaturation, rightSaturation

  byte direction
  byte speed

  long wheelCountLeft, wheelCountRight

  long spare, spare2

PUB Main | data, time, x, y

  Motors.start(3, 6, 9)   
  CMUCam.start(Settings#CMUCAM_RX, Settings#CMUCAM_TX)
  CMUCam.changeBaud(57600)
  'CMUCam.setPollMode(0)  
  CMUCam.configureToBlack
  CMUCam.setTrackingWindow(20, 20, 140, 120)
  waitcnt(clkfreq/2+cnt)  
  CMUCam.setAutoGain(0)
  CMUCam.setAutoWhiteBalance(0)
  CMUCam.startTracking
  Motors.setRawPWMDuty(Settings#LAMP_SIGNAL, Settings#CMUCAM_LAMP_MEDIUM)
  Line.init

  cognew(debugloop, @stack)
  'cognew(wheelcounter, @stack1)
  
  toLineFollowing

PUB followLine | x, y, stepsize

  x := CMUCam.getMiddleOfMassX
  y := CMUCam.getMiddleOfMassY
  Line.calculateSpeeds(x, y)
  leftSpeed := Line.getLeftSpeed
  rightSpeed := Line.getRightSpeed
  Motors.setLeftDirection(0)
  Motors.setRightDirection(0)
  Motors.setLeftSpeed(leftSpeed)
  Motors.setRightSpeed(rightSpeed)

PUB followLineVerbose(x_, y_) | x, y, stepsize

  x := CMUCam.getMiddleOfMassX
  y := CMUCam.getMiddleOfMassY
  Line.calculateSpeeds(x, y)
  leftSpeed := Line.getLeftSpeed
  rightSpeed := Line.getRightSpeed
  Motors.setLeftDirection(0)
  Motors.setRightDirection(0)
  Motors.setLeftSpeed(leftSpeed+x_)
  Motors.setRightSpeed(rightSpeed)

PUB shortcutDirection | x

  x := CMUCam.getMiddleOfMassX
  Motors.halt
  CMUCam.stopTracking
  CMUCam.setPollMode(1)
  CMUCam.setTrackingWindow(20, 40, 80, 120)
  CMUCam.updateTrackingData
  leftSaturation := CMUCam.getPerPixTracked
  CMUCam.setTrackingWindow(120, 20, 140, 120)
  CMUCam.updateTrackingData
  rightSaturation := CMUCam.getPerPixTracked
  CMUCam.setTrackingWindow(20, 20, 140, 120)
  CMUCam.setPollMode(0)
  CMUCam.startTracking
  if leftSaturation > rightSaturation
    return Settings#LEFT
  else
    return Settings#RIGHT

PUB scanForShortcutDirection | x

  leftSaturation := -1000
  rightSaturation := 0

  repeat until abs_(leftSaturation-rightSaturation) > 20
  x := CMUCam.getMiddleOfMassX
  Motors.halt
  'Motors.backward(25, 100) 
  Motors.spinLeft(25, 250)
  waitcnt(clkfreq*1+cnt)
  leftSaturation := CMUCam.getPerPixTracked    
  Motors.spinRight(25, 500)
  waitcnt(clkfreq*1+cnt)
  rightSaturation := CMUCam.getPerPixTracked  
  Motors.spinLeft(25, 250)
  'if abs_(leftSaturation-rightSaturation) < 100
  '  return Settings#NUTER
  if leftSaturation > rightSaturation
    return Settings#LEFT
  else
    return Settings#RIGHT        

PUB toLineFollowing | y

  location := String("Line Following")

  repeat
    if CMUCam.getPerPixTracked > 180
      spare2 := CMUCam.getPerPixTracked     
      direction := scanForShortcutDirection

      Motors.setForward(20)
      repeat until CMUCam.getPerPixTracked < 120
      repeat                       
        if CMUCam.getPerPixTracked > 150
          location := String("Gridlock")
          Motors.setBackward(20)  
          repeat until CMUCam.getPerPixTracked < 120
          repeat until CMUCam.getPerPixTracked > 200
          Motors.backward(25, 200)
          Motors.spinRight(25, 300)
          repeat until CMUCam.getMiddleOfMassX > 70 and CMUCam.getMiddleOfMassX < 90 and CMUCam.getPerPixTracked > 50
          Motors.halt
          Motors.forward(25, 500)          
          quit
        elseif CMUCam.getPerPixTracked < 20
          location := String("Corner")
          repeat
          quit
      Motors.halt      
      
      if direction == Settings#LEFT
        location := String("Left Corner")
       
        repeat
       
        Motors.backward(25, 100)
        Motors.spinLeft(25, 250)
        Motors.setForward(25)
        waitcnt(clkfreq/2+cnt)
        repeat until CMUCam.getMiddleOfMassX > 70 and CMUCam.getMiddleOfMassX < 90 and CMUCam.getPerPixTracked > 50
        Motors.halt
          
        location := String("Line Following")
        direction := 100
      elseif direction == Settings#RIGHT
        location := String("Right Corner")
       
        repeat
        
        Motors.backward(25, 100)
        Motors.spinRight(25, 300)
        Motors.setForward(25)
        waitcnt(clkfreq/2+cnt)
        repeat until CMUCam.getMiddleOfMassX > 70 and CMUCam.getMiddleOfMassX < 90 and CMUCam.getPerPixTracked > 50
        Motors.halt                      
       
        location := String("Line Following")
        direction := 100
      else
        Motors.forward(25, 300)
    followLine

PUB debugloop

  Serial.start(31, 30, 0, 115200)
  repeat
    Serial.tx(16)
    Serial.str(location)
    Serial.tx(13)
    Serial.dec(wheelCountLeft)
    Serial.tx(13)
    Serial.dec(wheelCountRight)

    

    
    'Serial.tx(13)
    'Serial.dec(CMUCam.getMiddleOfMassX)
    'Serial.str(string(", "))
    'Serial.dec(CMUCam.getMiddleOfMassY)
    'Serial.tx(13)
    'if direction == Settings#LEFT
    '  Serial.str(String("Left"))
    'elseif direction == Settings#RIGHT
    '  Serial.str(String("Right"))
    'elseif direction == Settings#NUTER
    '  Serial.str(String("Neither"))     
    'else
    '  Serial.str(String("None"))
    Serial.tx(13)
    Serial.dec(CMUCam.getPerPixTracked)
    'Serial.tx(13)
    'Serial.dec(leftSpeed)
    'Serial.tx(13)
    'Serial.dec(rightSpeed)
    'Serial.tx(13)
    'Serial.dec(leftSaturation)
    'Serial.tx(13)
    'Serial.dec(rightSaturation)
    'Serial.tx(13)
    'Serial.dec(spare)
    'Serial.tx(13)
    'Serial.dec(spare2)
    waitcnt(clkfreq/10+cnt)

{PUB WheelCounter | delta, goalMS

  goalMS := 100

  repeat
    Profiler[0].startTimer
    wheelCountLeft += abs_(Motors.getLeftSpeed - Settings#GOAL_SPEED)
    wheelCountRight += abs_(Motors.getRightSpeed - Settings#GOAL_SPEED)
    waitcnt((clkfreq/1_000)*10+cnt)    
    delta := Profiler[0].stopTimer_
    waitcnt(((clkfreq/(1_000))*goalMS-delta)+cnt)

} 

PRI abs_(number)
                                
  if number < 0
    return -number
  else
    return number
        
    