{{
Name: Motors.spin
Author: John Board
Description:

Driver for ESCON 36/2 motor drivers using
the PWM driver. This code is simply an
easy-to-use wrapper for the PWM library.

This code also supports driving the arm servo
along with using button feedback to control the
"kill-switch" for the arm.

Default pins for Achilles Board vR:

Left: 3 (4, 5)
Right: 6 (7, 8)
Arm: 9 (10, 11)

}}
CON

  MAX_SPEED = 90
  FULL_SPEED = 90
  NORMAL_SPEED = 50
  SLOW_SPEED = 30
  STOPPED = 10

  PWM_PERIOD = 200 'microseconds, or 5kHz

OBJ

  PWM:          "PWM"
  Button:       "Button"

VAR

  long leftSpeed, rightSpeed, armSpeed
  byte leftDirection, rightDirection, armDirection
  byte leftPin, rightPin, armPin

PUB start(leftPin_, rightPin_, armPin_)

  {{
  The pin mapping for each driver (using left as example)
  is as follows:

  Speed: leftPin
  CW & Enable: leftPin + 1
  CCW & Enable: leftPin + 2
  }}

  leftPin := leftPin_
  rightPin := rightPin_
  armPin := armPin_
  
  DIRA[leftPin..leftPin+2]~~
  DIRA[rightPin..rightPin+2]~~
  DIRA[armPin..armPin+2]~~

  PWM.Start

PUB setLeftSpeed(speed)

  ''Speed is expressed as a percentage, from 10%-90%

  leftSpeed := speed
  updatePWMDriver

PUB getLeftSpeed

  return leftSpeed

PUB setRightSpeed(speed)

  rightSpeed := speed
  updatePWMDriver

PUB getRightSpeed

  return rightSpeed

PUB setArmSpeed(speed)

  armSpeed := speed
  updatePWMDriver

PUB getArmSpeed

  return armSpeed

PUB setLeftDirection(direction)

  leftDirection := direction
  updateDirection

PUB getLeftDirection

  return leftDirection

PUB setRightDirection(direction)

  rightDirection := direction
  updateDirection

PUB getRightDirection

  return rightDirection

PUB setArmDirection(direction)

  armDirection := direction
  updateDirection

PUB getArmDirection

  return armDirection

PUB forward(speed, time)

  setLeftDirection(0)
  setRightDirection(0)
  setLeftSpeed(speed)
  setRightSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt
  
PUB setForward(speed)

  setLeftDirection(0)
  setRightDirection(0)
  setLeftSpeed(speed)
  setRightSpeed(speed)

PUB forwardVerbose(speedL, speedR, time)

  setLeftDirection(0)
  setRightDirection(0)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setForwardVerbose(speedL, speedR)

  setLeftDirection(0)
  setRightDirection(0)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)

PUB backward(speed, time)

  setLeftDirection(1)
  setRightDirection(1)
  setLeftSpeed(speed)
  setRightSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt
  
PUB setBackward(speed)

  setLeftDirection(1)
  setRightDirection(1)
  setLeftSpeed(speed)
  setRightSpeed(speed)

PUB backwardVerbose(speedL, speedR, time)

  setLeftDirection(1)
  setRightDirection(1)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setBackwardVerbose(speedL, speedR)

  setLeftDirection(1)
  setRightDirection(1)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)
  
PUB forwardLeft(speed, time)

  setLeftDirection(0)
  setLeftSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setForwardLeft(speed)

  setLeftDirection(0)
  setLeftSpeed(speed)

PUB backwardLeft(speed, time)

  setLeftDirection(1)
  setLeftSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setBackwardLeft(speed)

  setLeftDirection(1)
  setLeftSpeed(speed)

PUB forwardRight(speed, time)

  setRightDirection(0)
  setRightSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setForwardRight(speed)

  setRightDirection(0)
  setRightSpeed(speed)

PUB backwardRight(speed, time)

  setRightDirection(1)
  setRightSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setBackwardRight(speed)

  setRightDirection(1)
  setRightSpeed(speed)

PUB spinLeft(speed, time)

  setLeftDirection(1)
  setRightDirection(0)
  setLeftSpeed(speed)
  setRightSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setSpinLeft(speed)

  setLeftDirection(1)
  setRightDirection(0)
  setLeftSpeed(speed)
  setRightSpeed(speed)

PUB spinLeftVerbose(speedL, speedR, time)

  setLeftDirection(1)
  setRightDirection(0)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setSpinLeftVerbose(speedL, speedR)

  setLeftDirection(1)
  setRightDirection(0)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)

PUB spinRight(speed, time)

  setLeftDirection(0)
  setRightDirection(1)
  setLeftSpeed(speed)
  setRightSpeed(speed)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setSpinRight(speed)

  setLeftDirection(0)
  setRightDirection(1)
  setLeftSpeed(speed)
  setRightSpeed(speed)

PUB spinRightVerbose(speedL, speedR, time)

  setLeftDirection(0)
  setRightDirection(1)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)
  waitcnt((clkfreq/1_000)*time+cnt)
  Halt

PUB setSpinRightVerbose(speedL, speedR)

  setLeftDirection(0)
  setRightDirection(1)
  setLeftSpeed(speedL)
  setRightSpeed(speedR)
  
PUB Halt

  setLeftSpeed(10)
  setRightSpeed(10)

PUB updatePWMDriver

  PWM.Duty(leftPin, leftSpeed, PWM_PERIOD)
  PWM.Duty(rightPin, rightSpeed, PWM_PERIOD)
  PWM.Duty(armPin, armSpeed, PWM_PERIOD)

PUB updateDirection

  if leftDirection == 0
    OUTA[leftPin+1..leftPin+2] := %10
  else
    OUTA[leftPin+1..leftPin+2] := %01
    
  if rightDirection == 0
    OUTA[rightPin+1..rightPin+2] := %10
  else
    OUTA[rightPin+1..rightPin+2] := %01

  if armDirection == 0
    OUTA[armPin+1..armPin+2] := %10
  else
    OUTA[armPin+1..armPin+2] := %01    
