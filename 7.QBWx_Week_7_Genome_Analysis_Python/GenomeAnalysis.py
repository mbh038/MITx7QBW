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

# FINDING ANNOTATED GENES IN GENOMIC DATA

fa_file='H:/RSpace/MITx7QBWdata/selChroms_mm9.fa.zip'
seq_dict=loadFasta(fa_file)
len(seq_dict)
seq_dict.keys()
cntn4="uc009dcr.2"
gene_info[cntn4]
gene_info[cntn4]['chr']
len(seq_dict['chr6'])
len(seq_dict['chr16'])

# GETTING GENETIC INFORMATION

hchr=gene_info[cntn4]['chr']
hst=gene_info[cntn4]['start']
hen=gene_info[cntn4]['end']

cntn4_seq=seq_dict[hchr][hst:hen]
#cntn4_seq=seq_dict[hchr][hst:hen]
len(cntn4_seq)

# Getting Information about Genes
# The gene Matn2 has the UCSC identifier of "uc007vll.1". Using this information,
#  repeat the steps above to extract the following information:

matn2="uc007vll.1"
gene_info[matn2]

# On what chromosome is Matn2 located?

gene_info[matn2]['chr']



len(seq_dict['chr15'])

# GETTING GENETIC INFORMATION

hchr=gene_info[matn2]['chr']
hst=gene_info[matn2]['start']
hen=gene_info[matn2]['end']

matn2_seq=seq_dict[hchr][hst:hen]
len(matn2_seq)

# READING THE GENOME

cntn4_seq[5:200]

cntn4_seq.index('ATG')

# Translating the Genome

matn2_seq[0:10]
matn2_seq.index('ATG')

# GENOMIC STATISTICS

import numpy as np

# Now we can find the start and end of each gene, and store the difference:

gene_lengths={}
for g in gene_info.keys():
  st=gene_info[g]['start']
  en=gene_info[g]['end']
  gene_lengths[g]=np.absolute(en-st)

# Now we can use some of PyLab's basic plotting tools to create a histogram: 

import pylab as P
n,bins,patches=P.hist(gene_lengths.values(),50,normed=False,histtype='stepfilled')

# You can alter the color to green (g) by passing in the patches object to one that overlays a new color on top:
 
P.setp(patches,'facecolor','g','alpha',0.75)

n,bins,patches=P.hist(gene_lengths.values(),50,normed=False,histtype='stepfilled',log=True)
P.setp(patches,'facecolor','g','alpha',0.75)

maxlen=max(gene_lengths.values())

maxlen-len(cntn4_seq)
maxlen-gene_lengths[cntn4]

# OUTSIDE THE CODING REGION

#Creates an empty set object. Sets are collections of unordered unique values.
in_gene=set()

#Looping through all the genes in chromosome 6, we find every sequence index
# assigned to the gene.
for gene in gene_info.keys():
  if gene_info[gene]['chr']=='chr6':
    gene_inds=range(gene_info[gene]['start'],gene_info[gene]['end'])
#Now we update the set with the indices of the current gene. Because it is a set,
#even if the indices were already entered as a different gene, we will not get duplicate entries.
    in_gene.update(gene_inds)
print len(in_gene)
 
#This might take a while to compute (or cause a memory error). If you are having trouble,
# we can also do this less directly using a boolean array.

# Create a boolean Numpy array the same length as the chromosome
# Initially, every entry will be False
chr6_length = len(seq_dict['chr6'])
in_gene_numpy = np.zeros(chr6_length, dtype=np.bool)

# Loop through the genes, switching entries to True if they are found
for gene in gene_info.keys():
   if gene_info[gene]['chr']=='chr6':
     start_ind = gene_info[gene]['start']
     end_ind = gene_info[gene]['end']
     in_gene_numpy[start_ind:end_ind] = True

# Get the answer by summing the Numpy array
# True values are treated as 1, False as 0, so the sum of the array will be the 
# number of index sites that are coding sites (the length of coding sequence in chr6)
num_in_gene = in_gene_numpy.sum()
print(num_in_gene)

#Use of either of these methods will end with a set of indices that are inside
#transcribed regions and displaying the length of the coding sequence in chromosome 6.

# Non-coding DNA

#Now that we have used Python to count coding DNA we can evaluate just how much of chromosome 6 is devoted to encoding genes:

#Enter the length of the in_gene set (using the len) command:
inGene=len(in_gene)
inGene
#Now enter the total size of chromosome 6:

chr6Len=len(seq_dict['chr6'])
chr6Len
#Now we can calculate the difference between them to count non-coding base pairs:
nonCoding=len(seq_dict['chr6'])-len(in_gene)
#What is the fraction of non-coding DNA on chromosome 6? 
nonCoding/float(chr6Len)
#Note that in Python the quotient of two integers is an integer. If you are doing division
#  and desire a decimal value, cast the numerator or denominator to a float.

#GENE REGULATORY REGIONS

#MOTIF FINDING
seq_dict['chr6'].upper().count('TATA')
gene_counts['chr6']
chr6_starts=getTssOnChroms(gene_info,'chr6')

tata_dist={}
for g in chr6_starts.keys():
  e=chr6_starts[g]
  strand=gene_info[g]['strand']
  if strand=='+':
    s=e-40
  else:
    s=e
    e=s+40
  if 'TATA' in seq_dict['chr6'][s:e].upper():
    if strand=='+':
      tata_dist[g]=seq_dict['chr6'][s:e].upper().rindex('TATA')
    else:
      tata_dist[g]=seq_dict['chr6'][s:e].upper().index('TATA')
      
#TATA Binding Motif Analysis
      
len(tata_dist)
np.mean(tata_dist.values())      