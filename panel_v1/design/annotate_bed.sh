#bedtools intersect -a design/WG_IAD211800_v3_Lymphoid_v6.20210408.designed.bed -b /Users/tyrellg/ThermoLocal/Data/ref/GCF_000001405.25_GRCh37.p13_genomic.gff
#bedtools intersect -wa -wb -a design/WG_IAD211800_v3_Lymphoid_v6.20210408.designed.bed -b /Users/tyrellg/ThermoLocal/Data/ref/NCBI_RefSeq.bed
bedtools annotated -wa -wb -a design/WG_IAD211800_v3_Lymphoid_v6.20210408.designed.bed -b /Users/tyrellg/ThermoLocal/Data/ref/NCBI_RefSeq.bed
