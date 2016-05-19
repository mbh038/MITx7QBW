source("qbwRModule.R")

y = rnorm(1000)

plot(y, ylab="y-axis label goes here")

abline(h=mean(y), col="green")

sdabove = mean(y)+sd(y)

sdbelow = mean(y)-sd(y)

abline(h=sdabove, col="orange")

abline(h=sdbelow, col="orange")

count(y, sdbelow, sdabove)

count(y, sdbelow, sdabove)/1000

# WORKING WITH REAL DATA

# Describing Real Data

mean(lowtemp)
mean(hightemp)

plotsidebyside(lowtemp, hightemp, "low", "high", "Thorax length (mm)")

boxplot(lowtemp, hightemp, names=c("low", "high"), ylab="Thorax length (mm)", xlab="Temperature condition")

## INTRODUCING STANDARD ERROR

data.sim = sim(1, 200)
names(data.sim)
head(data.sim$xvals)
head(data.sim$yvals)
plot(data.sim$xvals, data.sim$yvals) # no good since all x values are the same!
plot(jitter(data.sim$xvals), data.sim$yvals, col="grey") # add jitter on x values
m = mean(data.sim$yvals)
s = sem(data.sim$yvals)
points(1, m, pch="x")
below = m-2*s
above = m+2*s
errorbars(above, below)