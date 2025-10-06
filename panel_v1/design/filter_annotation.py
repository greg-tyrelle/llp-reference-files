import re
#chr1	2488069	2488201	AMPL7170799749	.	GENE_ID=AMPL7170799749;Pool=1
#['chr1', '2488069', '2488201', 'AMPL7170799749', '.', 'GENE_ID=AMPL7170799749;Pool=1', 'chr1', '2481358', '2488450', 'TNFRSF14-AS1', '.', '-', 'ncbiRefSeq.2021-05-17', 'transcript', '.', 'gene_id "TNFRSF14-AS1"; transcript_id "NR_037844.2";  gene_name "TNFRSF14-AS1";']


# chr1    2489236 2489371 AMPL7170799871  .       GENE_ID=AMPL7170799871,AMPL7170800088;Pool=2    chr1    2489164 2489273 TNFRSF14        .       +       BestRefSeq      exon    .       gene_id "TNFRSF14"; transcript_id "NM_003820.4"; db_xref "GeneID:8764"; gene "TNFRSF14"; product "TNF receptor superfamily member 14, transcript variant 1"; tag "RefSeq Select"; transcript_biotype "mRNA"; exon_number "2";

with open('anno.bed') as anno_bed:
    for line in anno_bed:
        l = line.strip().split('\t')
        amplicon_id = l[3]
        chrom = l[0]
        start = l[1]
        end = l[2]
        orig_bed_line = l[5]
        pool = orig_bed_line.split(';')[1]
        gene = l[9]
        atype = l[12]
        etype = l[13]
        region_type = l[13]
        annos = l[15].split(';')
        #print(annos)
        #['gene_id "EP300"', ' transcript_id "NM_001429.4"', ' db_xref "GeneID:2033"', ' gene "EP300"', ' product "E1A binding protein p300, transcript variant 1"', ' tag "RefSeq Select"', ' transcript_biotype "mRNA"', ' exon_number "30"', '']
        annotations = {}
        #['gene_id ', 'TNFRSF14-AS1', '']
        for a in annos:
            n = a.split('"')
            if len(n) >=2:
                annotations[n[0].strip()] = n[1].strip()

        if 'product' in annotations:
            p_transcript = re.match('.*transcript variant 1.*', annotations['product'])
        else:
            p_transcript = None

#        if 'tag' in annotations and annotations['tag'] == 'RefSeq Select' and atype == "BestRefSeq" and etype == "CDS":
#        print(p_transcript, atype, etype)
        if (amplicon_id == "AMPL7172303932" or amplicon_id == "AMPL7171625842") and annotations['transcript_id'] == "NM_001318876.2":
                new_anno_line = ";".join([pool, "GENE_ID=%s" % gene, "TRANSCRIPT=%s" % annotations['transcript_id']] )
                print("\t".join([chrom, start, end, amplicon_id, new_anno_line]))
                continue

        if (amplicon_id == "AMPL7171762988" or amplicon_id == "AMPL7171762887") and annotations['transcript_id'] == "NR_173091.1":
                new_anno_line = ";".join([pool, "GENE_ID=%s" % 'BCL6', "TRANSCRIPT=%s" % 'NM_001130845.2'] )
                print("\t".join([chrom, start, end, amplicon_id, new_anno_line]))
                continue

        if p_transcript and atype == "BestRefSeq" and etype == "transcript":
                new_anno_line = ";".join([pool, "GENE_ID=%s" % gene, "TRANSCRIPT=%s" % annotations['transcript_id']] )
                print("\t".join([chrom, start, end, amplicon_id, new_anno_line]))
                continue

        if ('tag' in annotations and annotations['tag'] == 'RefSeq Select') and (etype == "CDS" or etype == 'gene' or etype == 'transcript'):
                new_anno_line = ";".join([pool, "GENE_ID=%s" % gene, "TRANSCRIPT=%s" % annotations['transcript_id']] )
                print("\t".join([chrom, start, end, amplicon_id, new_anno_line]))
