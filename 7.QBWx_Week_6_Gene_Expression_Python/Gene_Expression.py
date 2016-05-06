# -*- coding: utf-8 -*-
"""
Created on Fri May 06 05:15:05 2016

@author: Mike
"""
#Question 8

import re
line = "1684730100 Ter3A chr8 - 641.57 12.03 113.7"
myPattern=re.search(r"\d+\s(\S+)\s\S+\s[+-]\s(\d+\.?\d*)\s(\d+\.?\d*)\s(\d+\.?\d*)", line)
print myPattern.group(0)
print myPattern.group(1)
print myPattern.group(2)
print myPattern.group(3)
print myPattern.group(4)

print myPattern.group(0)==line

pattern1 = re.search(r"\d+\s\S+\s\S+\s[+-]\s\S+\s\S+\s\S+", line)
print pattern1.group(0)
print pattern1.group(1)
#print pattern1.group(0)
print pattern1.group(0)==line

# Question 9, part 1: Accessing Match Object Data

line = "1684730100 Ter3A chr8 - 641.57 12.03 113.7"
pattern2 = re.search(r"\d+\s\S+\s\S+\s[+-]\s\d+\s\d+\s\d+", line)
print pattern2.group(1)

# Question 9, part 2: Accessing Match Object Data

pattern2 = re.search(r"\d+\s(\S+)\s\S+\s[+-]\s(\d+\.?\d*)\s(\d+\.?\d*)\s(\d+\.?\d*)", line)
print pattern2.group(1)

# Question 10, part 1: Writing Regular Expression Commands

line = "Sox2  chr3  34548926  34551382  +"
exp="\S+\s+chr\S+\s+\d+\s+\d+\s+[-+]"
myPattern=re.search(r"\S+\s+chr\S+\s+\d+\s+\d+\s+[-+]",line)
print myPattern.group(0)==line
print myPattern.group(0)

# Question 10, part 2: Writing Regular Expression Commands

line="The Biology department averages 32 students/class"

exp="\S+\s+(\S+)\s+\S+\s+\S+\s+(\d+)\s+\S+"
myPattern=re.search(exp,line)
print myPattern.group(0)
print myPattern.group(1)
print myPattern.group(2)

# Question 10, Part 3: Now Make the Commands a Function

line = "Sox2  chr3  34548926  34551382  +"
def chromosome_regex (line):
    myPattern=re.search(r"\S+\s+chr\S+\s+\d+\s+\d+\s+[-+]",line)
    return myPattern.group(0)