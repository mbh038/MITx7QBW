# -*- coding: utf-8 -*-
"""
Created on Wed May 11 04:57:46 2016

@author: Mike
"""

def Countdown():
    Ctdown=range(1,11)
    Ctdown.reverse()
    string="Launch in "
    for number in Ctdown:
        if number<10:
            string += "..."
        string += str(number)
        #print string
    #print string
    return Ctdown,string
        
#Countdown()

from qbwPythonModule import *

gene_file='mm9_sel_chroms_knownGene.txt'
fopen=open(gene_file,'rU').readlines()
len(fopen)
fopen[0]

gene_info=loadGeneFile(gene_file)
gene_info.keys()[0:10] 
gene_info[gene_info.keys()[10]] 

# COUNTING CHROMOSOMES

chroms=[]
for k in gene_info.keys():
    chr=gene_info[k]['chr']
    if chr not in chroms:
        chroms=chroms+[chr]
        
# COUNTING GENES
        
gene_counts={}
for chr in chroms:
    chrom_count=0 
    for k in gene_info.keys():
        if gene_info[k]['chr']==chr:
            chrom_count+=1
    gene_counts[chr]=chrom_count
    
# Of this set of chromosomes, which chromosome has the largest number of genes?
    
import operator
maxgene=max(gene_counts.iteritems(), key=operator.itemgetter(1))[0]
gene_counts[maxgene]