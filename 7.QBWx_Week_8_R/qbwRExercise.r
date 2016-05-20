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

## USING SIMULATIONS TO ESTIMATE CONFIDENCE

nsamples = 100
samplesize = 25
datasets = sim(nsamples, samplesize)
plot(datasets$xvals, datasets$yvals, col="grey")
col.means = colMeans(datasets$yvals)
col.sems = sem(datasets$yvals)
points(1:nsamples, col.means, pch="x")
col.lowers = col.means-2*col.sems
col.uppers = col.means+2*col.sems
colors = errorbarcolors(col.uppers, col.lowers)
errorbars(col.uppers, col.lowers, col=colors)
abline(h=0, col="red")
print(count(0, col.lowers, col.uppers)/nsamples)

## STANDARD ERROR IN REAL DATA

fly.means = c(mean(lowtemp), mean(hightemp))
fly.sems = c(sem(lowtemp), sem(hightemp))

fly.lower = fly.means-2*fly.sems
fly.upper = fly.means+2*fly.sems

plot(c(1,2), fly.means)
errorbars(fly.lower, fly.upper)

plot(c(1,2), fly.means, ylim=c(0.9,1.2))
errorbars(fly.lower, fly.upper)