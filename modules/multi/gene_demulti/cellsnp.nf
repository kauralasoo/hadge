#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process cellSNP{
    publishDir "$params.outdir/$sampleId/$params.mode/gene_demulti/cellSNP", mode: 'copy'
    label 'big_mem'
    tag "${sampleId}"
    //conda "bioconda::cellsnp-lite"
    container = "quay.io/biocontainers/cellsnp-lite:1.2.3--h6141fd1_2"

    input:
        tuple val(sampleId), path(samFile_cellSNP), path(indexFile_cellSNP), path(barcodeFile_cellSNP)
        val regionsVCF_cellSNP
        val targetsVCF_cellSNP
        val sampleList_cellSNP
        val sampleIDs_cellSNP
        val genotype_cellSNP
        val gzip_cellSNP
        val printSkipSNPs_cellSNP
        val nproc_cellSNP
        val refseq_cellSNP
        val chrom_cellSNP
        val cellTAG_cellSNP
        val UMItag_cellSNP
        val minCOUNT_cellSNP
        val minMAF_cellSNP
        val doubletGL_cellSNP
        val inclFLAG_cellSNP
        val exclFLAG_cellSNP
        val minLEN_cellSNP
        val minMAPQ_cellSNP
        val countORPHAN_cellSNP
        val cellsnp_out


    output:
        path "cellsnp_${sampleId}", emit: out1
        tuple val(sampleId), path("cellsnp_${sampleId}/${cellsnp_out}"), emit: cellsnp_input

    script:
        def samFile = "--samFile ${samFile_cellSNP}"
        def regionsVCF = regionsVCF_cellSNP != 'None' ? "--regionsVCF ${regionsVCF_cellSNP}" : ''
        def targetsVCF = targetsVCF_cellSNP != 'None' ? "--targetsVCF ${targetsVCF_cellSNP}" : ''
        def barcodeFile = "--barcodeFile ${barcodeFile_cellSNP}"
        def sampleList = sampleList_cellSNP != 'None' ? "--sampleList ${sampleList_cellSNP}" : ''
        def sampleIDs = sampleIDs_cellSNP != 'None' ? "--sampleIDs ${sampleIDs_cellSNP}" : ''
        def genotype = genotype_cellSNP != 'False' ? "--genotype" : ''
        def gzip = gzip_cellSNP != 'False' ? "--gzip" : ''
        def printSkipSNPs = printSkipSNPs_cellSNP != 'False' ? "--printSkipSNPs" : ''
        def nproc = nproc_cellSNP != 'None' ? "--nproc ${nproc_cellSNP}" : ''
        def refseq = refseq_cellSNP != 'None' ? "--refseq ${refseq_cellSNP}" : ''
        def chrom = chrom_cellSNP != 'None' ? "--chrom ${chrom_cellSNP}" : ''
        def cellTAG = "--cellTAG ${cellTAG_cellSNP}"
        def UMItag = "--UMItag ${UMItag_cellSNP}"
        def minCOUNT = "--minCOUNT ${minCOUNT_cellSNP}"
        def minMAF = "--minMAF ${minMAF_cellSNP}"
        def doubletGL = doubletGL_cellSNP != 'False' ? "--doubletGL" : ''
        def inclFLAG = inclFLAG_cellSNP != 'None' ? "--inclFLAG ${inclFLAG_cellSNP}" : ''
        def exclFLAG = exclFLAG_cellSNP != 'None' ? "--exclFLAG ${exclFLAG_cellSNP}" : ''
        def minLEN = "--minLEN ${minLEN_cellSNP}"
        def minMAPQ = "--minMAPQ ${minMAPQ_cellSNP}"
        def countORPHAN = countORPHAN_cellSNP != 'False' ? "--countORPHAN" : ''
        def out = "cellsnp_${sampleId}/${cellsnp_out}"

        """
        base_name_bam="\$(basename $samFile_cellSNP)"
        base_name_bai="\$(basename $indexFile_cellSNP)"
        base_name1="\${base_name_bam%.*}"
        base_name2="\${base_name_bai%.*}"
        if [ "\$base_name1" = "\$base_name2" ]; then
            echo "The bam file and bam index have the same base name."
        else
            echo "The bam file and bam index have different base name."
            new_file_name="\${base_name1}.bai"
            cp $indexFile_cellSNP \$new_file_name
        fi
        mkdir cellsnp_${sampleId}
        mkdir $out
        touch cellsnp_${sampleId}/params.csv
        echo -e "Argument,Value \n samfile,${samFile_cellSNP} \n regionsVCF,${regionsVCF_cellSNP} \n targetsVCF,${targetsVCF_cellSNP} \n barcodeFile,${barcodeFile_cellSNP} \n sampleList,${sampleList_cellSNP} \n sampleIDs,${sampleIDs_cellSNP} \n genotype,${genotype_cellSNP} \n gzip,${gzip_cellSNP} \n printSkipSNPs,${printSkipSNPs_cellSNP} \n nproc,${nproc_cellSNP} \n refseq,${refseq_cellSNP} \n chrom,${chrom_cellSNP} \n cellTAG,${cellTAG_cellSNP} \n UMItag,${UMItag_cellSNP} \n minCOUNT,${minCOUNT_cellSNP} \n minMAF,${minMAF_cellSNP} \n doubletGL,${doubletGL_cellSNP} \n inclFLAG,${inclFLAG_cellSNP} \n exclFLAG,${exclFLAG_cellSNP} \n minLEN,${minLEN_cellSNP} \n minMAPQ,${minMAPQ_cellSNP} \n countORPHAN,${countORPHAN_cellSNP}" >> cellsnp_${sampleId}/params.csv
        cellsnp-lite $samFile $regionsVCF $targetsVCF $barcodeFile $sampleList $sampleIDs $genotype $gzip $printSkipSNPs \
            $nproc $refseq $chrom $cellTAG $UMItag $minCOUNT $minMAF $doubletGL $inclFLAG $exclFLAG $minLEN $minMAPQ \
            $countORPHAN --outDir $out
        cd $out
        gunzip -c cellSNP.cells.vcf.gz > cellSNP.cells.vcf
        """
}


workflow variant_cellSNP{
    take:
        input_list
    main:
        regionsVCF = channel.value(params.common_variants_cellsnp)
        targetsVCF = channel.value(params.targetsVCF)
        sampleList = channel.value(params.sampleList)
        sampleIDs = channel.value(params.sampleIDs)
        genotype_cellSNP = channel.value(params.genotype_cellSNP)
        gzip_cellSNP = channel.value(params.gzip_cellSNP)
        printSkipSNPs = channel.value(params.printSkipSNPs)
        nproc_cellSNP = channel.value(params.nproc_cellSNP)
        refseq_cellSNP = channel.value(params.refseq_cellSNP)
        chrom = channel.value(params.chrom)
        cellTAG = channel.value(params.cellTAG)
        UMItag = channel.value(params.UMItag)
        minCOUNT = channel.value(params.minCOUNT)
        minMAF = channel.value(params.minMAF)
        doubletGL = channel.value(params.doubletGL)
        inclFLAG = channel.value(params.inclFLAG)
        exclFLAG = channel.value(params.exclFLAG)
        minLEN = channel.value(params.minLEN)
        minMAPQ = channel.value(params.minMAPQ)
        countORPHAN = channel.value(params.countORPHAN)
        cellsnp_out = channel.value(params.cellsnp_out)
        cellSNP(input_list, regionsVCF, targetsVCF, sampleList, sampleIDs, genotype_cellSNP, gzip_cellSNP, printSkipSNPs, 
            nproc_cellSNP, refseq_cellSNP, chrom, cellTAG, UMItag, minCOUNT, minMAF, doubletGL, inclFLAG, exclFLAG, minLEN, minMAPQ, 
            countORPHAN, cellsnp_out)
    emit:
        out1 = cellSNP.out.out1
        cellsnp_input = cellSNP.out.cellsnp_input
}
