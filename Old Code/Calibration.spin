CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  CMUCam:         "CMUCam"
  Settings:       "Settings"
  Serial:         "FullDuplexSerial"
  Buttons:        "Button"
  Motors:         "Motors"           

VAR

  long lowestValue, bestBrightness, bestContrast, bestBrightnessValue, bestContrastValue
  byte lowestValueX, lowestValueY

  long redBottom, redTop, greenBottom, greenTop, blueBottom, blueTop

PUB Main | x, y 

  Serial.start(31, 30, 0, 19200)
  CMUCam.start(Settings#CMUCAM_RX, Settings#CMUCAM_TX)
  Serial.str(string("CMUCam Initalized.", 13))
  CMUCam.setPollMode(1)
  CMUCam.changeBaud(57600)

  waitcnt(clkfreq/2+cnt)

  CMUCam.setAutoGain(0)
  
  Buttons.init
  Motors.start(3, 6, 9)

  lowestValue := 766

  Motors.setRawPWMDuty(Settings#LAMP_SIGNAL, Settings#CMUCAM_LAMP_HIGH)

  if Buttons.getTopArmButton == 0
    CMUCam.setTrackingWindow(60, 40, 100, 80)
    repeat 4
      CMUCam.updateColorData
      waitcnt(clkfreq/10+cnt)
     
    repeat x from 0 to 128 step 32
      CMUCam.setTrackingWindow(x, 0, x+32, 120)
      CMUCam.updateColorData
      {Serial.dec(CMUCam.getAverageRed)
      Serial.tx(13)
      Serial.dec(CMUCam.getAverageGreen)
      Serial.tx(13)
      Serial.dec(CMUCam.getAverageBlue)
      Serial.tx(13)}
      if CMUCam.getAverageRed+CMUCam.getAverageGreen+CMUCam.getAverageBlue < lowestValue
        lowestValue := CMUCam.getAverageRed+CMUCam.getAverageGreen+CMUCam.getAverageBlue
        lowestValueX := x
        lowestValueY := y
    Serial.str(String("Lowest average color detected at: ", 13))
    Serial.str(string(" X: "))
    Serial.dec(lowestValueX)
    Serial.tx(13)
    Serial.str(string(" Y: "))
    Serial.dec(lowestValueY)
    Serial.tx(13)
    Serial.str(string(" Lowest Value: "))
    Serial.dec(lowestValue)
    Serial.tx(13)
     
    CMUCam.setTrackingWindow(lowestValueX, 0, lowestValueX+32, 120)
    CMUCam.updateColorData
     
    Serial.str(String(13, "=====[Mean/StdDev Values]=====", 13))
    Serial.str(String("Red Average: "))
    Serial.dec(CMUCam.getAverageRed)
    Serial.str(String(13, "Green Average: "))
    Serial.dec(CMUCam.getAverageGreen)
    Serial.str(String(13, "Blue Average: "))
    Serial.dec(CMUCam.getAverageBlue)
    Serial.str(String(13, 13, "StdDev Red: "))
    Serial.dec(CMUCam.getStdDevRed)
    Serial.str(String(13, "StdDev Green: "))
    Serial.dec(CMUCam.getStdDevGreen)
    Serial.str(String(13, "StdDev Blue: "))
    Serial.dec(CMUCam.getStdDevBlue)  
    Serial.str(String(13, "==============================", 13, 13))
     
    redBottom := CMUCam.getAverageRed-CMUCam.getStdDevRed-Settings#CMUCAM_MODIFIER
    redTop := CMUCam.getAverageRed+CMUCam.getStdDevRed+Settings#CMUCAM_MODIFIER
    greenBottom := CMUCam.getAverageGreen-CMUCam.getStdDevGreen-Settings#CMUCAM_MODIFIER
    greenTop := CMUCam.getAverageGreen+CMUCam.getStdDevGreen+Settings#CMUCAM_MODIFIER
    blueBottom := CMUCam.getAverageBlue-CMUCam.getStdDevBlue-Settings#CMUCAM_MODIFIER
    blueTop := CMUCam.getAverageBlue+CMUCam.getStdDevBlue+Settings#CMUCAM_MODIFIER
     
    CMUCam.setTrackingParameters(redBottom, redTop, greenBottom, greenTop, blueBottom, blueTop) 
     
    CMUCam.updateTrackingData
     
    Serial.str(String("Adjusting Brightness...", 13))
     
    repeat x from -30 to 30
      CMUCam.setBrightness(x)
      CMUCam.updateTrackingData
      if CMUCam.getPerPixTracked > bestBrightnessValue
        bestBrightnessValue := CMUCam.getPerPixTracked
        bestBrightness := x
     
    Serial.str(String("Best Brightness: "))
    Serial.dec(bestBrightness)
    CMUCam.setBrightness(bestBrightness)
    Serial.str(String(13, 13))
        
    Serial.str(String("Adjusting Contrast...", 13))
     
    repeat x from -30 to 30
      CMUCam.setContrast(x)
      CMUCam.updateTrackingData
      if CMUCam.getPerPixTracked > bestBrightnessValue
        bestContrastValue := CMUCam.getPerPixTracked
        bestContrast := x
     
    Serial.str(String("Best Contrast: "))
    Serial.dec(bestContrast)
    CMUCam.setContrast(bestContrast)
    Serial.str(String(13, 13))
     
    Serial.str(String("=====[Black Calibration Settings]=====", 13))
    Serial.str(String("S "))
    Serial.dec(redBottom)
    Serial.str(String(" "))
    Serial.dec(redTop)
    Serial.str(String(" "))
    Serial.dec(greenBottom)
    Serial.str(String(" "))
    Serial.dec(greenTop)
    Serial.str(String(" "))
    Serial.dec(blueBottom)
    Serial.str(String(" "))
    Serial.dec(blueTop)
    Serial.str(String(13))
    Serial.str(String("CB "))
    Serial.dec(bestBrightness)
    Serial.str(String(13))
    Serial.str(String("CC "))
    Serial.dec(bestContrast)
    Serial.str(String(13, 13, 13, 13))

  CMUCam.setTrackingWindow(0, 0, 160, 120)

  Serial.str(String("Waiting for button press to move on...", 13, 13))
  Buttons.init  
  repeat until Buttons.getTopArmButton == 1
  Serial.str(String("Calibrating Green...", 13))

  CMUCam.setTrackingWindow(50, 30, 110, 90)
  
  Motors.setRawPWMDuty(Settings#LAMP_SIGNAL, Settings#CMUCAM_LAMP_HIGH)
  bestBrightness := 0
  bestBrightnessValue := 0
  bestContrast := 0
  bestContrastValue := 0
  
  CMUCam.setTrackingParameters(0, 255, 0, 255, 0, 255)
  
  repeat 10
    CMUCam.updateColorData
    waitcnt(clkfreq/10+cnt)

  Serial.str(String(13, "=====[Mean/StdDev Values]=====", 13))
  Serial.str(String("Red Average: "))
  Serial.dec(CMUCam.getAverageRed)
  Serial.str(String(13, "Green Average: "))
  Serial.dec(CMUCam.getAverageGreen)
  Serial.str(String(13, "Blue Average: "))
  Serial.dec(CMUCam.getAverageBlue)
  Serial.str(String(13, 13, "StdDev Red: "))
  Serial.dec(CMUCam.getStdDevRed)
  Serial.str(String(13, "StdDev Green: "))
  Serial.dec(CMUCam.getStdDevGreen)
  Serial.str(String(13, "StdDev Blue: "))
  Serial.dec(CMUCam.getStdDevBlue)  
  Serial.str(String(13, "==============================", 13, 13))  
  
  redBottom := CMUCam.getAverageRed-CMUCam.getStdDevRed-Settings#CMUCAM_MODIFIER
  redTop := CMUCam.getAverageRed+CMUCam.getStdDevRed+Settings#CMUCAM_MODIFIER
  greenBottom := CMUCam.getAverageGreen-CMUCam.getStdDevGreen-Settings#CMUCAM_MODIFIER
  greenTop := CMUCam.getAverageGreen+CMUCam.getStdDevGreen+Settings#CMUCAM_MODIFIER
  blueBottom := CMUCam.getAverageBlue-CMUCam.getStdDevBlue-Settings#CMUCAM_MODIFIER
  blueTop := CMUCam.getAverageBlue+CMUCam.getStdDevBlue+Settings#CMUCAM_MODIFIER

  if redBottom < 0
    redBottom := 0

  CMUCam.setTrackingParameters(redBottom, redTop, greenBottom, greenTop, blueBottom, blueTop) 

  CMUCam.updateTrackingData

  Serial.str(String("Adjusting Brightness...", 13))
  
  repeat x from -30 to 30
    CMUCam.setBrightness(x)
    CMUCam.updateTrackingData
    if CMUCam.getPerPixTracked > bestBrightnessValue
      bestBrightnessValue := CMUCam.getPerPixTracked
      bestBrightness := x

  Serial.str(String("Best Brightness: "))
  Serial.dec(bestBrightness)
  CMUCam.setBrightness(bestBrightness)
  Serial.str(String(13, 13))
      
  Serial.str(String("Adjusting Contrast...", 13))

  repeat x from -30 to 30
    CMUCam.setContrast(x)
    CMUCam.updateTrackingData
    if CMUCam.getPerPixTracked > bestBrightnessValue
      bestContrastValue := CMUCam.getPerPixTracked
      bestContrast := x

  Serial.str(String("Best Contrast: "))
  Serial.dec(bestContrast)
  CMUCam.setContrast(bestContrast)
  Serial.str(String(13, 13))

  Serial.str(String("=====[Green Calibration Settings]=====", 13))
  Serial.str(String("S "))
  Serial.dec(redBottom)
  Serial.str(String(" "))
  Serial.dec(redTop)
  Serial.str(String(" "))
  Serial.dec(greenBottom)
  Serial.str(String(" "))
  Serial.dec(greenTop)
  Serial.str(String(" "))
  Serial.dec(blueBottom)
  Serial.str(String(" "))
  Serial.dec(blueTop)
  Serial.str(String(13))
  Serial.str(String("CB "))
  Serial.dec(bestBrightness)
  Serial.str(String(13))
  Serial.str(String("CC "))
  Serial.dec(bestContrast)
  Serial.str(String(13, 13, 13, 13))

  CMUCam.setTrackingWindow(0, 0, 160, 120)

  repeat

PUB CalibrationError

  repeat
    !outa[2]
    waitcnt(clkfreq/10+cnt)                                                   