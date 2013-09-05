OBJ

  Settings:     "Settings"

PUB init

  DIRA[Settings#BUTTON_TOP]~
  DIRA[Settings#BUTTON_BOTTOM]~

PUB getTopArmButton

  return INA[Settings#BUTTON_TOP]

PUB getBottomArmButton

  return INA[Settings#BUTTON_BOTTOM]
  