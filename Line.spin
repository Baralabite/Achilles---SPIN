{{
Original python source:

++++++++++++++++++++

GOAL_SPEED = 50
X_SCALE = 80

PWM_TOP = 90
PWM_BOTTOM = 10

X_SIZE = 160
Y_SIZE = 120

CONVERTER_CONSTANT = 10000

def calculateSpeed(x, y): #Only calculating mode 1 currently
    #X Axis Calculations
    leftSpeed = 0
    rightSpeed = 0
    if x > X_SCALE:
        leftSpeed = 0
        rightSpeed = GOAL_SPEED
    elif abs(x) > X_SCALE:
        leftSpeed = GOAL_SPEED
        rightSpeed = 0
    else:
        if x == 0:
            leftSpeed = GOAL_SPEED
            rightSpeed = GOAL_SPEED
        elif x > 0:
            leftSpeed =  GOAL_SPEED
            rightSpeed = findSpeed(abs(x))
        elif x < 0:
            leftSpeed = findSpeed(abs(x))
            rightSpeed = GOAL_SPEED

    #Y Axis Calculations
    
    return (leftSpeed, rightSpeed)

leftSpeed, rightSpeed = calculateSpeed(0, 0)

print "Speed in Percentage: "
print leftSpeed, rightSpeed
print
print "PWM Duty Cycle Speed: "
print speedUnitConverter(leftSpeed), speedUnitConverter(rightSpeed)

++++++++++++++++++++

}}

OBJ

  Settings:     "Settings"

VAR

  byte leftSpeed, rightSpeed
  byte GOAL_SPEED, INTERSECTION_SPEED
  byte CORNER_SATURATION_THRESHOLD, X_SCALE
  byte Y_INTERVENTION_THRESHOLD

PUB Init

  GOAL_SPEED                    := Settings#GOAL_SPEED
  INTERSECTION_SPEED            := Settings#INTERSECTION_SPEED
  CORNER_SATURATION_THRESHOLD   := Settings#CORNER_SATURATION_THRESHOLD
  X_SCALE                       := Settings#X_SCALE
  Y_INTERVENTION_THRESHOLD      := Settings#Y_INTERVENTION_THRESHOLD

PUB setSpeed(speed)

  GOAL_SPEED := speed

PUB calculateSpeeds(x_, y) | x    

    x := normalizeX(x_)

    if y > Y_INTERVENTION_THRESHOLD
      if x == 0
        leftSpeed := GOAL_SPEED
        rightSpeed := GOAL_SPEED
      elseif x > 0
        leftSpeed := GOAL_SPEED
        rightSpeed := 0
      elseif x < 0
        leftSpeed := 0
        rightSpeed := GOAL_SPEED

    else
    
      if x >  X_SCALE
        leftSpeed := 0
        rightSpeed := GOAL_SPEED
      elseif abs_(x) > X_SCALE
        leftSpeed := GOAL_SPEED
        rightSpeed := 0
      else
        if x == 0
          leftSpeed := GOAL_SPEED
          rightSpeed := GOAL_SPEED
        elseif x > 0
          leftSpeed := GOAL_SPEED
          rightSpeed := findSpeed(abs_(x))
        elseif x < 0
          leftSpeed := findSpeed(abs_(x))
          rightSpeed := GOAL_SPEED

  leftSpeed := speedUnitConverter(leftSpeed)
  rightSpeed := speedUnitConverter(rightSpeed)

PUB setLeftSpeed(speed)

  leftSpeed := speed

PUB setRightSpeed(speed)

  rightSpeed := speed

PUB getLeftSpeed

  return leftSpeed

PUB getRightSpeed

  return rightSpeed

PRI findSpeed(x)

    return GOAL_SPEED-(x*(GOAL_SPEED*Settings#CONVERTER_CONSTANT/X_SCALE))/Settings#CONVERTER_CONSTANT        

PRI normalizeX(x)

    return x-(Settings#X_RES/2)

PRI normalizeY(y)

  return y-(Settings#Y_RES/2)

PRI speedUnitConverter(inp_speed)

    return ((((Settings#PWM_DUTY_TOP-Settings#PWM_DUTY_BOTTOM)*Settings#CONVERTER_CONSTANT/100)*inp_speed)/Settings#CONVERTER_CONSTANT)+10

PRI abs_(number)

  if number < 0
    return -number
  else
    return number  