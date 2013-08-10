CON

  'Mode 1 is terminal mode
  'Mode 2 is comms mode

  {{Debugging Constants}}

  PRIMARY_BAUD = 115200
  PRIMARY_TX_PIN = -1
  PRIMARY_RX_PIN = -1
  PRIMARY_MODE = 1
  PRIMARY_PORT = 0

  SECONDARY_BAUD = 115200
  SECONDARY_TX_PIN = -1
  SECONDARY_RX_PIN = -1
  SECONDARY_MODE = 1
  SECONDARY_PORT = 1

  LINE_BUFFER_LENGTH = 15

  {{Debugging Coordinate Constants}}
  
  START_X = 2
  START_Y = 4

  COMMAND_START_X = 3
  COMMAND_START_Y = 20

  {{CMUCam Constants}}

  CMUCAM_TX_PIN = 17
  CMUCAM_RX_PIN = 16
  CMUCAM_BAUD = 19200
  CMUCAM_TARGET_BAUD = 115200
  CMUCAM_PORT = 2

  CMUCAM_DEBUG_TX_PIN = 30
  CMUCAM_DEBUG_RX_PIN = 31
  CMUCAM_DEBUG_BAUD = 115200
  CMUCAM_DEBUG_PORT = 3
  CMUCAM_INTERACTIVE_TERMINAL = true

OBJ

  Term:         "COG_3"
  Profiler[5]:  "Profiler"
  Strings:       "Strings"           

VAR

  {{Enabled Parts}}

  byte primaryDebugEnabled, secondaryDebugEnabled, cmucamEnabled, cmucamDebugEnabled
  byte started

  {{Random global variables}}

  byte sampling
  byte subelement[3]
  byte element[8]
  byte subelementNumber
  byte elementNumber
  byte packetStartedFlag

  {{Loop Stack}}

  long stack[50]
  
  {{Terminal Random Variables}}
  
  long primaryCommand, secondaryCommand
  long primaryCommandDataLen, secondaryCommandDataLen
  long title, author
  long lineBuffer[LINE_BUFFER_LENGTH]
  long lineBufferOld[LINE_BUFFER_LENGTH]

  {{Debugging Parameters}}

  long baudrate, rxPin, txPin

  {{Profiler Times}}

  long loopTime, primaryTime, secondaryTime, cmucamTime
  long startupTime
  
  {{CMUCam Parameters}}

  long cmucamAvgRed, cmucamAvgGreen, cmucamAvgBlue
  long cmucamStdDevRed, cmucamStdDevGreen, cmucamStdDevBlue

  long cmucamMiddleOfMassX, cmucamMiddleOfMassY
  long cmucamBBoxX1, cmucamBBoxY1, cmucamBBoxX2, cmucamBBoxY2                   'Per meaning percentage
                                                                                'So, percentage of pixels
  long cmucamPerPixTracked, cmucamBBoxPerPixTracked                             'tracked in all, or BBox

  long tTypeUpdated, sTypeUpdated

  long cmucamRawCommandsBuffer[10]
  long cmucamRawCommandResponse

  {{Calibration}}

  long cmucamBlack_Red, cmucamBlack_Green, cmucamBlack_Blue
  long cmucamStdDevBlack_Red, cmucamStdDevBlack_Green, cmucamStdDevBlack_Blue
  long cmucamGreen_Red, cmucamGreen_Green, cmucamGreen_Blue
  long cmucamStdDevGreen_Red, cmucamStdDevGreen_Green, cmucamStdDevGreen_Blue

  long cmucamColorTrackingRedBottom, cmucamColorTrackingGreenBottom, cmucamColorTrackingBlueBottom
  long cmucamColorTrackingRedTop, cmucamColorTrackingGreenTop, cmucamColorTrackingBlueTop
  long cmucamCalibrationChanged

  long cmucamRedModifier, cmucamGreenModifier, cmucamBlueModifier

  long cmucamBrightness, cmucamContrast, cmucamNoiseFilter

  {{Temp global variables}}

  byte temp1[128], temp2[128], temp3[128]
    
PUB start(primaryDebugEnabled_, secondaryDebugEnabled_, cmucamEnabled_, cmucamDebugEnabled_)

  Profiler[4].StartTimer
  
  primaryDebugEnabled := primaryDebugEnabled_ 
  secondaryDebugEnabled := secondaryDebugEnabled_
  cmucamEnabled := cmucamEnabled_
  cmucamDebugEnabled := cmucamDebugEnabled_

  cmucamBlack_Red :=            0
  cmucamBlack_Green :=          0
  cmucamBlack_Blue :=           0

  cmucamStdDevBlack_Red :=      0
  cmucamStdDevBlack_Green :=    0
  cmucamStdDevBlack_Blue :=     0

  cmucamGreen_Red :=            0
  cmucamGreen_Green :=          0
  cmucamGreen_Blue :=           0

  cmucamStdDevGreen_Red :=      0
  cmucamStdDevGreen_Green :=    0
  cmucamStdDevGreen_Blue :=     0

  cmucamBrightness :=           0
  cmucamContrast :=             0
  cmucamNoiseFilter :=          0

  updateCalibrationBlack

  cognew(Loop, @stack)
  startupTime := Profiler.StopTimer_

  repeat while not started  

{{Misc Debugging Gets & Sets}}

PUB setTitle(title_)

  title := title_

PUB getTitle    

  return title

PUB setAuthor(author_)

  author := author_

PUB getAuthor

  return author

{{Profiler Times}}  
  
PUB getLoopTime

  return loopTime

PUB getPrimaryTime

  return primaryTime

PUB getSecondaryTime

  return secondaryTime

PUB getCMUCamTime

  return cmucamTime

PUB getStartupTime

  return startupTime
  
{{CMUCam Calibration Sets & Gets}}

PUB updateCalibrationBlack

  cmucamColorTrackingRedBottom :=  cmucamBlack_Red - cmucamStdDevBlack_Red - cmucamRedModifier
  cmucamColorTrackingGreenBottom :=cmucamBlack_Green - cmucamStdDevBlack_Green - cmucamGreenModifier
  cmucamColorTrackingBlueBottom := cmucamBlack_Blue - cmucamStdDevBlack_Blue - cmucamBlueModifier
  cmucamColorTrackingRedTop :=     cmucamBlack_Red + cmucamStdDevBlack_Red + cmucamRedModifier
  cmucamColorTrackingGreenTop :=   cmucamBlack_Green + cmucamStdDevBlack_Green + cmucamGreenModifier
  cmucamColorTrackingBlueTop :=    cmucamBlack_Blue + cmucamStdDevBlack_Blue + cmucamBlueModifier
  cmucamCalibrationChanged := true

PUB updateCalibrationGreen

  cmucamColorTrackingRedBottom :=  cmucamGreen_Red - cmucamStdDevGreen_Red - cmucamRedModifier
  cmucamColorTrackingGreenBottom :=cmucamGreen_Green - cmucamStdDevGreen_Green - cmucamGreenModifier
  cmucamColorTrackingBlueBottom := cmucamGreen_Blue - cmucamStdDevGreen_Blue - cmucamBlueModifier
  cmucamColorTrackingRedTop :=     cmucamGreen_Red + cmucamStdDevGreen_Red + cmucamRedModifier
  cmucamColorTrackingGreenTop :=   cmucamGreen_Green + cmucamStdDevGreen_Green + cmucamGreenModifier
  cmucamColorTrackingBlueTop :=    cmucamGreen_Blue + cmucamStdDevGreen_Blue + cmucamBlueModifier
  cmucamCalibrationChanged := true

PUB setBrightness(brightness)

  cmucamBrightness := brightness
  cmucamCalibrationChanged := true

PUB setContrast(contrast)

  cmucamContrast := contrast
  cmucamCalibrationChanged := true

PUB setNoiseFilter(noiseFilter)

  cmucamNoiseFilter := noiseFilter
  cmucamCalibrationChanged := true

PUB setBlackCalibrationRed(red)

  cmucamBlack_Red := red

PUB getBlackCalibrationRed

  return cmucamBlack_Red  

PUB setBlackCalibrationGreen(green)

  cmucamBlack_Green := green

PUB getBlackCalibrationGreen

  return cmucamBlack_Green

PUB setBlackCalibrationBlue(blue)

  cmucamBlack_Blue := blue

PUB getBlackCalibrationBlue

  return cmucamBlack_Blue

PUB setBlackCalibrationStdDevRed(red)

  cmucamStdDevBlack_Red := red

PUB getBlackCalibrationStdDevRed

  return cmucamStdDevBlack_Red

PUB setBlackCalibrationStdDevGreen(green)

  cmucamStdDevBlack_Green := green

PUB getBlackCalibrationStdDevGreen

  return cmucamStdDevBlack_Green

PUB setBlackCalibrationStdDevBlue(blue)

  cmucamStdDevBlack_Blue := blue

PUB getBlackCalibrationStdDevBlue

  return cmucamStdDevBlack_Blue

PUB setGreenCalibrationRed(red)

  cmucamGreen_Red := red

PUB getGreenCalibrationRed

  return cmucamGreen_Red

PUB setGreenCalibrationGreen(green)

  cmucamGreen_Green := green

PUB getGreenCalibrationGreen

  return cmucamGreen_Green

PUB setGreenCalibrationBlue(blue)

  cmucamGreen_Blue := blue

PUB getGreenCalibrationBlue

  return cmucamGreen_Blue
  
PUB setGreenCalibrationStdDevRed(red)

  cmucamStdDevGreen_Red := red

PUB getGreenCalibrationStdDevRed

  return cmucamStdDevGreen_Red

PUB setGreenCalibrationStdDevGreen(green)

  cmucamStdDevGreen_Green := green

PUB getGreenCalibrationStdDevGreen

  return cmucamStdDevGreen_Green

PUB setGreenCalibrationStdDevBlue(blue)

  cmucamStdDevGreen_Blue := 0

PUB getGreenCalibrationStdDevBlue

  return cmucamStdDevGreen_Blue

{{CMUCam Gets}}

PUB isTTypeUpdated

  return tTypeUpdated

PUB isSTypeUpdated

  return sTypeUpdated
  
PUB getMiddleOfMassX

  tTypeUpdated := false
  return cmucamMiddleOfMassX

PUB getMiddleOfMassY

  tTypeUpdated := false
  return cmucamMiddleOfMassY

PUB getBBoxX1

  tTypeUpdated := false
  return cmucamBBoxX1

PUB getBBoxY1

  tTypeUpdated := false
  return cmucamBBoxY1

PUB getBBoxX2

  tTypeUpdated := false
  return cmucamBBoxX2

PUB getBBoxY2

  tTypeUpdated := false
  return cmucamBBoxY2
  
PUB getPerPixTracked

  return cmucamPerPixTracked

PUB getbBoxPerPixTracked

  return cmucamBBoxPerPixTracked

PUB getAverageRed

  sTypeUpdated := false
  return cmucamAvgRed

PUB getAverageGreen

  sTypeUpdated := false           
  return cmucamAvgGreen

PUB getAverageBlue

  sTypeUpdated := false
  return cmucamAvgBlue

{{CMUCam action functions}}

PUB cmucamSetNoiseFilter(int) | buffer

  Strings.stringConcatenate(@temp3, string("NF "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(int, 3))
  sendCommand(@temp3)
  clearTemp3
  getResult(@buffer)
  if strcomp(@buffer, string("ACK"))
    return true
  else
    return false 

PUB cmucamSetCameraBrightness(int) | buffer

  Strings.stringConcatenate(@temp3, string("CB "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(int, 3))
  sendCommand(@temp3)
  clearTemp3
  getResult(@buffer)
  if strcomp(@buffer, string("ACK"))
    return true
  else
    return false

PUB cmucamSetCameraContrast(int) | buffer

  Strings.stringConcatenate(@temp3, string("CC "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(int, 3))
  sendCommand(@temp3)
  clearTemp3
  getResult(@buffer)
  if strcomp(@buffer, string("ACK"))
    return true
  else
    return false  

PUB cmucamSetPollMode(int) | buffer

  Strings.stringConcatenate(@temp3, string("PM "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(int, 1))
  sendCommand(@temp3)
  clearTemp3
  getResult(@buffer)
  if strcomp(@buffer, string("ACK"))
    return true
  else
    return false  
    
PUB cmucamSetTrackingWindow(x1, y1, x2, y2) | buffer

  Strings.stringConcatenate(@temp3, string("SW "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(x1, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(y1, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(x2, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(y2, 3)) 
  cmucamDebug(string("Sending command", 13))
  cmucamDebug(@temp3)
  sendCommand(@temp3)
  cmucamDebug(string("Sent command successfully.", 13))  
  getResult(@buffer)
  cmucamDebug(string("Finished getting result. Should have been dumped into buffer.", 13))
  clearTemp3
  cmucamDebug(String("Cleared temp3.", 13))

PUB cmucamSetTrackingParameters(rB, rT, gB, gT, bB, bT) | buffer

  clearTemp3
  Strings.stringConcatenate(@temp3, string("ST "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(rB, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(rT, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(gB, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(gT, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(bB, 3))
  Strings.stringConcatenate(@temp3, string(" "))
  Strings.stringConcatenate(@temp3, Strings.integerToDecimal(bT, 3))

  cmucamDebug(string("Sending command", 13))
  cmucamDebug(@temp3)
  sendCommand(@temp3)
  cmucamDebug(string("Sent command successfully.", 13))  
  getResult(@buffer)
  cmucamDebug(string("Finished getting result. Should have been dumped into buffer.", 13))
  clearTemp3
  cmucamDebug(String("Cleared temp3.", 13))
    

PUB startSampling | buffer

  sendCommand(string("TC"))
  cmucamDebug(string("Started sampling", 13))
  sampling := true
    
PUB stopSampling | rx

  cmucamDebug(string("Sending CR to stop sampling...", 13))
  Term.tx(CMUCAM_PORT, 13)
  sampling := false
  repeat until rx == 58
    rx := Term.rx(CMUCAM_PORT)
  cmucamDebug(string("Stopped Sampling", 13))

PUB sendCommand(cmd)

  SetString(@temp2, cmd) 
  if cmucamDebugEnabled
    SetString(@temp1, string("Command Executed: "))    
    Strings.stringConcatenate(@temp1, @temp2)
    cmucamDebug(@temp1)
    Term.tx(CMUCAM_DEBUG_PORT, 13)
  Term.str(CMUCAM_PORT, @temp2)
  Term.tx(CMUCAM_PORT, 13)
  clearTemp1
  clearTemp2

PUB getResult(strpointer) | rx, lastPacket

  cmucamDebug(string("Command Result: "))
  repeat
    rx := Term.rx(CMUCAM_PORT)
    Term.dec(CMUCAM_DEBUG_PORT, rx)
    if rx==58'lastPacket == 13 and rx==58
      quit
    lastPacket := rx
    'if cmucamDebugEnabled
    '  Term.tx(CMUCAM_DEBUG_PORT, rx)
    if rx => 32
      Strings.buildString(rx)
  Strings.stringCopy(strpointer, Strings.builtString(true))
  cmucamDebug(strpointer)  
  cmucamDebugNewline
  cmucamDebug(string("Finished command.", 13))
  waitcnt(clkfreq/10+cnt)

PUB initalizeSerial

  if primaryDebugEnabled or secondaryDebugEnabled or cmucamEnabled or cmucamDebugEnabled
    Term.init
    if primaryDebugEnabled
      Term.AddPort(PRIMARY_PORT,PRIMARY_RX_PIN,PRIMARY_RX_PIN,TERM#PINNOTUSED,TERM#PINNOTUSED,TERM#DEFAULTTHRESHOLD, TERM#NOMODE,PRIMARY_BAUD)
    if secondaryDebugEnabled
      Term.AddPort(SECONDARY_PORT,SECONDARY_RX_PIN,SECONDARY_TX_PIN,TERM#PINNOTUSED,TERM#PINNOTUSED,TERM#DEFAULTTHRESHOLD, TERM#NOMODE,SECONDARY_BAUD)
    if cmucamEnabled
      Term.AddPort(CMUCAM_PORT, CMUCAM_RX_PIN, CMUCAM_TX_PIN,TERM#PINNOTUSED,TERM#PINNOTUSED,TERM#DEFAULTTHRESHOLD, TERM#NOMODE,19200)
    if cmucamDebugEnabled
      Term.AddPort(CMUCAM_DEBUG_PORT,CMUCAM_DEBUG_RX_PIN,CMUCAM_DEBUG_TX_PIN,TERM#PINNOTUSED,TERM#PINNOTUSED,TERM#DEFAULTTHRESHOLD, TERM#NOMODE,CMUCAM_DEBUG_BAUD)      
    Term.start   

PUB Loop | data, rx, lastPacket

  initalizeSerial

  DIRA[2]~~

  if primaryDebugEnabled
    if PRIMARY_MODE == 1
      DrawFrame(SECONDARY_PORT)
    else      
    
  if secondaryDebugEnabled
    if SECONDARY_MODE == 1
      DrawFrame(SECONDARY_PORT)
    else

  if cmucamEnabled
    cmucamDebug(string("CMUCam Debugging Interface", 13, "====================", 13, 13))
    rx := Term.rx(CMUCAM_PORT)
    cmucamDebug(string("Connected to Camera.", 13))
    if cmucamDebugEnabled
      Term.tx(CMUCAM_DEBUG_PORT, rx)
    repeat
      rx := Term.rx(CMUCAM_PORT)
      if cmucamDebugEnabled
        Term.tx(CMUCAM_DEBUG_PORT, rx)      
      if lastPacket == 13 and rx==58
        quit
      lastPacket := rx
    waitcnt(clkfreq*2+cnt)
    cmucamDebug(string(13, 13, "Ready for commands.", 13, 13))

    cmucamSetNoiseFilter(cmucamNoiseFilter)
    cmucamSetCameraBrightness(cmucamBrightness)
    cmucamSetCameraContrast(cmucamContrast)
    cmucamSetTrackingParameters(cmucamColorTrackingRedBottom, {
    } cmucamColorTrackingRedTop, {
    } cmucamColorTrackingGreenBottom, {
    } cmucamColorTrackingGreenTop, {
    } cmucamColorTrackingBlueBottom, {
    } cmucamColorTrackingBlueTop)

  started := true
            
  repeat
    Profiler[0].StartTimer
    if primaryDebugEnabled
      UpdatePrimary
    if secondaryDebugEnabled
      UpdateSecondary
    if cmucamEnabled
      UpdateCMUCam

    !outa[2]
    
    loopTime := Profiler[0].StopTimer_

PUB UpdatePrimary | y, data

  Profiler[1].StartTimer
  if PRIMARY_MODE == 1

    repeat y from 0 to LINE_BUFFER_LENGTH-1
      if not StrComp(lineBuffer[y], lineBufferOld[y])
        Term.Position(PRIMARY_PORT, START_X, START_Y+y)
        Term.str(PRIMARY_PORT, lineBuffer[y])
        lineBufferOld[y] := lineBuffer[y]

    data := Term.rx(PRIMARY_PORT)
    if data == 13
      ClearLine(PRIMARY_PORT, COMMAND_START_Y)
      primaryCommand := Strings.builtString(true)    
    if data => 32 =< 127
      Strings.buildString(data)
      Term.Position(PRIMARY_PORT, COMMAND_START_X+primaryCommandDataLen, COMMAND_START_Y)
      Term.tx(PRIMARY_PORT, data)
      primaryCommandDataLen++
      
  elseif PRIMARY_MODE == 2

  primaryTime := Profiler[1].StopTimer_

PUB UpdateSecondary

  Profiler[2].StartTimer
  
  if SECONDARY_MODE == 1

  elseif SECONDARY_MODE == 2
  
  secondaryTime := Profiler[2].StopTimer_

PUB UpdateCMUCam | packet, x

  Profiler[3].StartTimer

  'cmucamMiddleOfMassX, etc

  'T mx my x1 y1 x2 y2 pixels confidence\r

  packet := Term.rxcheck(CMUCAM_PORT)
  
  if sampling
    if packetStartedFlag
      if packet == 13
        cmucamMiddleOfMassX := element[0]
        cmucamMiddleOfMassY := element[1]
        cmucamBBoxX1 := element[2]
        cmucamBBoxY1 := element[3]
        cmucamBBoxX2 := element[4]
        cmucamBBoxY2 := element[5]
        cmucamPerPixTracked := element[6]
        cmucamBBoxPerPixTracked := element[7]
        elementNumber := 0
        repeat x from 0 to 7
          element[x] := 0
        packetStartedFlag := false 
      elseif packet == 32 and subelementNumber => 1
        element[elementNumber] := Strings.decimalToInteger(@subelement)
        elementNumber++
        subelementNumber := 0      
        repeat x from 0 to 2
          subelement[x] := 0  
      elseif packet => 48 and packet =< 57
        subelement[subelementNumber] := packet 
        subelementNumber++
    else
      if packet == 84
        packetStartedFlag := true
    'cmucamDebug(string("Char Recieved: "))
    'Term.tx(CMUCAM_DEBUG_PORT, packet)
    'cmucamDebugNewLine

  cmucamTime := Profiler[3].StopTimer_ 

PUB DrawFrame(terminal)

  Term.Clear(terminal)
  Term.str(terminal, @TerminalWindow)
  Term.Position(terminal, START_X, 1)
  Term.str(terminal, title)
  Term.Position(terminal, START_X, 2)
  Term.str(terminal, author)
  if terminal==1
    primaryCommandDataLen := 0
  elseif terminal==2
    secondaryCommandDataLen := 0

PUB setLine(line, text)

  lineBuffer[line] := text

PUB newEntry(terminal, text) | y

  repeat y from 0 to LINE_BUFFER_LENGTH 

PUB ClearLine(terminal, line) | x

  Term.Position(terminal, COMMAND_START_X-1, line)
  Term.str(0, string(">                                       "))

PUB cmucamDebug(msg)

  if cmucamDebugEnabled               
    Term.str(CMUCAM_DEBUG_PORT, msg)

PUB cmucamDebugNewLine

  if cmucamDebugEnabled
    Term.tx(CMUCAM_DEBUG_PORT, 13)

PUB clearTempVariables | x

  repeat x from 0 to 127
    temp1[x] := 0
    temp2[x] := 0
    temp3[x] := 0

PUB clearTemp1 | x

  repeat x from 0 to 127
    temp1[x] := 0

PUB clearTemp2 | x

  repeat x from 0 to 127
    temp2[x] := 0

PUB clearTemp3 | x

  repeat x from 0 to 127
    temp3[x] := 0        

PRI SetString( dstStrPtr, srcStrPtr )
  repeat until ( byte[ dstStrPtr++ ] := byte[ srcStrPtr++ ] ) == 0    

DAT

TerminalWindow          byte "*-----------[Terminal Window]------------*", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|=============[Log Window]===============|", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|                                        |", 13
                        byte "|============[Command Window]============|", 13
                        byte "|>                                       |", 13
                        byte "*----------------------------------------*", 13
                                                