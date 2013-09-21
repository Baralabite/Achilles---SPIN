VAR

  long counter
  long stack[10]
  byte cogid_
  long markedTime[20]

PUB wait(ms)

  repeat until counter == counter+ms 
  
PUB startGlobalClock

  cogid_ := cognew(Loop, @stack)

PUB stopGlobalClock

  cogstop(cogid_)

PUB getGlobalTime

  return counter

PUB setGlobalTime(time)

  counter := (time)

PUB markTime(index)

  markedTime[index] := counter

PUB setMarkedTime(index, value)

  markedTime[index] := counter

PUB getMarkedTime(index)

  return markedTime[index]
  
PUB Loop

  repeat
    counter++
    waitcnt((clkfreq/1_000)+cnt)