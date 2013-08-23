VAR

  long timer, mod

PUB StartTimer

  timer := -cnt

PUB StartTimerX(modifier)

  mod := modifier

PUB StopTimer

  timer += cnt - 544

PUB StopTimer_

  timer += cnt - 544
  return timer / (clkfreq / 1_000)

PUB getTimeMs

  return (timer / (clkfreq / 1_000))+mod

PUB getTimeSec

  return getTimeMs+mod/1000

PUB getUpdatesPerSecond(time)

  'return 1_000 / (time / (clkfreq / 1_000))
  return 1000 / time