#demuxEM
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/demuxem:0.1.7 .

#vireosnp
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/vireosnp:0.5.6 .

#bff
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/bff:v24.01.1 .

#scsplit
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/scsplit:v24.01.1 .

#hadgetools
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/hadgetools:v24.01.1 .

#gmm_demux
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/gmm_demux:0.2.1.3 .

#solo-sc
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/solo_sc:v24.01.1 .

#hadge_donor_match
docker buildx build --platform linux/amd64 --push -t quay.io/eqtlcatalogue/hadge_donor_match:v24.01.1 .



singularity build quay.io-eqtlcatalogue-hadgetools-v24.01.1.img docker://quay.io/eqtlcatalogue/hadgetools:v24.01.1
singularity build quay.io-eqtlcatalogue-scsplit-v24.01.1.img docker://quay.io/eqtlcatalogue/scsplit:v24.01.1
singularity build quay.io-eqtlcatalogue-bff-v24.01.1.img docker://quay.io/eqtlcatalogue/bff:v24.01.1
singularity build quay.io-eqtlcatalogue-demuxem-0.1.7.img docker://quay.io/eqtlcatalogue/demuxem:0.1.7
singularity build quay.io-eqtlcatalogue-gmm_demux-0.2.1.3.img docker://quay.io/eqtlcatalogue/gmm_demux:0.2.1.3
singularity build quay.io-eqtlcatalogue-solo_sc-v24.01.1.img docker://quay.io/eqtlcatalogue/solo_sc:v24.01.1