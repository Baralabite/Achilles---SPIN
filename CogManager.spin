var

  long stack[5]
  byte cog

PUB StopCog(id)

  COGSTOP(id)

PUB GetUsedCogs | x

  'stack := false
  x := cognew(TempCog, @stack)
  if x == -1
    return 8
  else
    return x
  

PUB CogsAvaliable

  if GetUsedCogs < 8
    return true
  else
    return false

PUB getCPU

  return GetUsedCogs*8

PUB getCurrentDraw | MIPS, mA, I

  MIPS := 80_000_000 / 4 * GetUsedCogs
  mA := (MIPS * 500) / 1000
  return mA

PRI TempCog