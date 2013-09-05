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

PUB calculateSpeeds(x_, y) | x

    x := normalizeX(x_)

    if y > 75
      if x == 0
        leftSpeed := Settings#GOAL_SPEED
        rightSpeed := Settings#GOAL_SPEED
      elseif x > 0
        leftSpeed := Settings#GOAL_SPEED
        rightSpeed := 0
      elseif x < 0
        leftSpeed := 0
        rightSpeed := Settings#GOAL_SPEED

    else
    
      if x >  Settings#X_SCALE
        leftSpeed := 0
        rightSpeed := Settings#GOAL_SPEED
      elseif abs_(x) > Settings#X_SCALE
        leftSpeed := Settings#GOAL_SPEED
        rightSpeed := 0
      else
        if x == 0
          leftSpeed := Settings#GOAL_SPEED
          rightSpeed := Settings#GOAL_SPEED
        elseif x > 0
          leftSpeed := Settings#GOAL_SPEED
          rightSpeed := findSpeed(abs_(x))
        elseif x < 0
          leftSpeed := findSpeed(abs_(x))
          rightSpeed := Settings#GOAL_SPEED

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

    return Settings#GOAL_SPEED-(x*(Settings#GOAL_SPEED*Settings#CONVERTER_CONSTANT/Settings#X_SCALE))/Settings#CONVERTER_CONSTANT        

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