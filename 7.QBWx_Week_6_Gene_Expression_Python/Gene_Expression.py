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
    
# Question 11: Writing the Code
test1="ENSMUSG00000000134	Tcfe3	14.92599	6.080252	7.205497	5.5972915\nENSMUSG00000000134	Tcfe3	14.92599	6.080252	7.205497	5.5972915"
test2="0.267"
test3='\nensGene\tgeneSymb\tESC.RPKM\tMES.RPKM\tCP.RPKM\tCM.RPKM\nENSMUSG00000000134\tTcfe3\t14.92599\t6.080252\t7.205497\t5.5972915\nENSMUSG00000000708\tKat2b\t9.379815\t0.37079784\t1.1033436\t5.6754346\nENSMUSG00000000948\tSnrpn\t40.668293\t14.529371\t13.403415\t23.01873\nENSMUSG00000001054\tRmnd5b\t43.369095\t7.0136724\t14.050683\t11.829396\nENSMUSG00000001366\tFbxo9\t7.6720843\t6.9369035\t6.499769\t6.778531\nENSMUSG00000001482\tDef8\t24.153797\t15.451096\t15.014166\t13.819534\nENSMUSG00000001542\tEll2\t8.156232\t3.5004125\t3.5680292\t2.2641196\nENSMUSG00000001627\tIfrd1\t28.733929\t16.701181\t15.508437\t12.778727\nENSMUSG00000001642\tAkr1b3\t4.319858\t1.9163351\t1.2716209\t0.82428175\nENSMUSG00000001687\tUbl3\t28.78591\t9.088697\t9.046656\t20.373514\nENSMUSG00000002227\tMov10\t29.740297\t3.2102342\t6.25411\t9.091757\nENSMUSG00000002635\tPdcd2l\t30.69546\t18.50777\t15.635618\t15.247209\nENSMUSG00000002660\tClpp\t93.85232\t51.403442\t32.20393\t33.370808\nENSMUSG00000002767\tMrpl2\t86.59501\t61.894024\t50.002293\t51.35253\nENSMUSG00000002963\tPnkp\t8.918158\t5.5222096\t6.193148\t6.496989\nENSMUSG00000002983\tRelb\t7.0391517\t1.501116\t1.7450844\t2.5017977\nENSMUSG00000003032\tKlf4\t41.70846\t7.747598\t4.1997404\t6.5344357\nENSMUSG00000003662\tCiao1\t15.639003\t11.429388\t9.724962\t11.069197\nENSMUSG00000003813\tRad23a\t30.253717\t16.276289\t15.284632\t21.372665\nENSMUSG00000004285\tAtp6v1f\t30.517672\t23.897362\t24.671564\t25.907063\nENSMUSG00000004568\tArhgef18\t13.561201\t6.151879\t5.004999\t6.8743706\nENSMUSG00000004667\tPolr2e\t91.243706\t51.02243\t36.53202\t33.37132'
import string
import re
def RNAseqParser (mytext):
    exp='\S+\s+(\S+)\s+\d*\.*\d*\s+\d*\.*\d*\s+(\d*\.*\d*)\s+\d*\.*\d*'
    #exp2="\d+\.\d+"
    stringlist=mytext.split("\n")
    print stringlist
    count=1
    for line in stringlist:
        #print count
        #print line
#        words=line.split("\t")
#        print words
#        newline=""
#        for word in words:
#            newline+=word
#            newline+="\t"
#        newline.rstrip() 
#        print newline
        if count >2:
            myPattern=re.match(exp,line)
            #print myPattern.group(0)
            print str(count)+"\t"+str(myPattern.group(1))+"\t"+str(myPattern.group(2))
        count+=1
    print
fhand = open('CMdiff_RNAseq.txt')

   
RNAseqParser(fhand)

def test (text):
    for line in text:
        print line
        
test(test3)