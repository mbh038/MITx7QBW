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

# Now let's simulate a dataset with 200 values using the sim() function
# from the course module:

data.sim = sim(1, 200)

# The sim() function is an expanded version of the rnorm command that
# produces more than one simulated dataset if the first argument is 
# greater than 1.  The command returns a list containing two vectors, 
# each with a name that can be accessed through the names function:

names(data.sim)

# Now we can peek at each element of the list using the $ command:

head(data.sim$xvals)
head(data.sim$yvals)

# We can plot the points, but since the x-axis value is the same, 
# they will be pretty stacked:

plot(data.sim$xvals, data.sim$yvals) # no good since all x values are the same!

# Try to stagger (or "jitter") the x-axis values slightly so that the 
# individual data points are more easily distinguishable from one 
# another:
    
plot(jitter(data.sim$xvals), data.sim$yvals, col="grey") # add jitter on x values

# This kind of view is best when you're working with a large number
# of partially overlapping data points. 

#Now let's calculate the mean and SEM of the y-values:

m = mean(data.sim$yvals)
s = sem(data.sim$yvals)

# Let's add an "x" to the plot for the mean (pch stands for
# "point character", ie the symbol used to represent the point):

points(1, m, pch="x")

# You can replace "x" with pretty much any symbol or number (examples shown in example(pch)).
# Now, we're going to plot error bars above and below the mean:below = m-2*s

above = m+2*s
errorbars(above, below)

# Now, more than likely, the mean is very close to 0, and the error bars
# will extend slightly above and below zero.

# These error bars represent what are called 95% confidence intervals: 
# we are 95% confident that the true mean falls somewhere along the 
# error bars.

## USING SIMULATIONS TO ESTIMATE CONFIDENCE

# In real biology, you do your best to get a large sample size but you
# generally have to make do with whatever you can get. 
# You are going to take advantage of the fact that we are simulating data
# to see what would happen if you repeated the experiment over and over
# again.

# You will follow the same steps of simulating data, plotting it, 
# calculating the confidence intervals, and then adding those on top of
# the plotted data. This time, though, you are going to do it with 
# multiple data sets simultaneously. Create a new script document that 
# you can use to type in commands.

# Use the sim() function to simulate 100 datasets each of size 25. 
# Type these lines into the new script document:

nsamples = 100
samplesize = 25
datasets = sim(nsamples, samplesize)

# Again use source command to run the commands you just typed in. 
# As before, datasets is a variable with some x-values and some y-values. 
# Let's look at the individual datasets. You can try running the following
# command at the command prompt to inspect the y-values:

datasets$yvals

# You will notice that the data are organized into 100 columns (each 
# representing a dataset) of 25 values each (the data points). 
# The x-values are basically just groupings for the 100 different datasets,
# as you will see when you plot the simulated data:

plot(datasets$xvals, datasets$yvals, col="grey")

# (You can make the window wider or try the jitter command again-if the
# points are too jittered, you can also try using jitter(datasets$xvals, 0.5)
# to reduce the amount of jitter).

#You are going to calculate the means and SEMs for each of the columns.
# Add these two lines to your script file and hit run:
    
col.means = colMeans(datasets$yvals)
col.sems = sem(datasets$yvals)

# Inspect the col.means and col.sems variables. You will note that
# col.means and col.sems each have 100 values, since the colMeans()
# and sem() commands work on each column of their input separately. 
# The "matrix" variable type (basically just a table of values) is built
# into the R language, and is one of the reasons that R lends itself so
# readily to analyzing data.

# As before, use the points() command to superimpose the mean values for
# the data points 1:100 on top of the raw data points 
# (remember that 1:nsamples will fill in as 1:100, which produces each
# integer between 1 and 100):

points(1:nsamples, col.means, pch="x")

# Run the script to see the points plotted. Now, we'll use the means and
# SEMs to calculate error bars. As we did before, we Are going to take the
# mean values and add the SEMs to them, and here we are taking advantage
# of the capabilities of the matrix variable type: subtraction of 
# equally-sized matrices performs element-wise subtraction. Add the 
# following:

col.lowers = col.means-2*col.sems

# which multiplies 2 times each value in col.sems; and then subtracts the
# first value in 2*col.sems from the first value in col.means, the second
# value in 2*col.sems from the second value in col.means, and so on.

col.uppers = col.means+2*col.sems

# Next, as we did before, we're going to plot the error bars, but we are
# going to color those that do not include zero differently:

colors = errorbarcolors(col.uppers, col.lowers)

errorbars(col.uppers, col.lowers, col=colors)

# And finally, we will add in a line representing the "true" mean of zero:

abline(h=0, col="red")

# About 95% of the confidence intervals should include zero-that is, on 
# average, 95 out of the 100 datasets you sampled. If you are having 
# trouble eyeballing from the graph how many of the confidence intervals
# do in fact include zero, you can use the following command to count 
# them for you:

print(count(0, col.lowers, col.uppers)/nsamples)

# which counts how many col.lowers, col.uppers pairs include zero. 
# If you have copied the above into a new script file, you can re-run 
# it several times to see that this number should be quite close to 95/100.

## STANDARD ERROR IN REAL DATA

# Let's return to our Drosophila experiment. As a reminder, we had raised fruit
# flies at two different temperatures (the low temperature, and the higher, 
# normal temperature) and measured thorax lengths of a number of flies. 
# You are going to plot the means and approximate confidence intervals so we can
# make an informed comparison between the two means.

# Calculate the two means and SEMs by creating vectors of these values at the command prompt:

fly.means = c(mean(lowtemp), mean(hightemp))
fly.sems = c(sem(lowtemp), sem(hightemp))

# Calculate the confidence interval lower and upper bounds (remember this subtraction will 
# work element-wise, so fly.lower and fly.upper will both be vectors of length 2):

fly.lower = fly.means-2*fly.sems
fly.upper = fly.means+2*fly.sems

# Now plot the values:

plot(c(1,2), fly.means)

# Now add in the error bars:

errorbars(fly.lower, fly.upper)

# If you like, you can change the y-axis on the plot() command by adding in the parameter
# ylim=c(0.9,1.2):

plot(c(1,2), fly.means, ylim=c(0.9,1.2))
errorbars(fly.lower, fly.upper)

## HYPOTHESIS TESTING

hist(lowtemp)
hist(hightemp)

t.test(lowtemp,hightemp) # 2 sample t test
t.test(lowtemp, mu=1) # 1 sample t test
t.test(hightemp, mu=1)