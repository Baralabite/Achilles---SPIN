CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

OBJ

  Motors: "Motors"

PUB Main

  Motors.start(3, 6, 9)

  Motors.setForward(90)

  repeat