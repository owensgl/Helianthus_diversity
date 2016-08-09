library(ggplot2)
library(SNPRelate)
library("bigmemory")
library(dplyr)
library("mapdata")
library("maps")
library("maptools")
library("rworldmap")
library(ggmap)
library(viridis)

filename <- "/home/owens/working/germplasm/germplasm.freebayes.80.1.onlyann.ntab"
gds_name <- "/home/owens/working/germplasm/germplasm.freebayes.80.1.onlyann.try2.gds"
geno_matrix <- read.big.matrix(filename, sep="\t", header = TRUE)
geno_matrix  <- geno_matrix[,-c(1:2)]


genotype_id_df <- read.table(pipe(paste("cut -f1,2", filename,sep=" ")), header = TRUE)
genotype_id_df$id <- paste(genotype_id_df$CHROM,genotype_id_df$POS,sep="_")
genotype_id_df$CHROM <- gsub('Ha', '', genotype_id_df$CHROM) 
genotype_id_df$CHROM <- gsub('_73Ns', '', genotype_id_df$CHROM) 
genotype_id_df$CHROM <- as.numeric(genotype_id_df$CHROM)
sample_id <- colnames(geno_matrix)

snpgdsCreateGeno(gds_name, genmat = geno_matrix, 
                 sample.id = sample_id, snpfirstdim = TRUE, 
                 snp.id = genotype_id_df$id, snp.chromosome = genotype_id_df$CHROM, 
                 snp.position = genotype_id_df$POS)

rm(list=c("geno_matrix"))


##################
#Load gds file
###################

genofile_all <- snpgdsOpen(gds_name, allow.duplicate = TRUE)
snpset_pruned <- snpgdsLDpruning(genofile_all)
snpset.id <- unlist(snpset_pruned)
#############
#Run PCA
###############
pca <- snpgdsPCA(genofile_all, snp.id=snpset.id, num.thread = 2, eigen.cnt = 16, sample.id = sample_id,maf = 0.05)

# variance proportion (%)
pc.percent <- pca$varprop*100
round(pc.percent, 2)

# Gather sample information
labels <- read.table("/home/owens/working/germplasm/germplasm.ann.locationlist.txt",header=F)
colnames(labels) <- c("sample.id","latitude","longitude")

# make a data.frame
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  EV3 = pca$eigenvect[,3],
                  EV4 = pca$eigenvect[,4],
                  stringsAsFactors = FALSE)
write.table(tab,file="/home/owens/working/germplasm/germplasm.freebayes.80.1.onlyann.pcsamples.tab",sep="\t",quote = F,col.names = T,row.names = F)


tab <- merge(tab, labels)

write.table(load_df,file="/home/owens/working/germplasm/germplasm.freebayes.80.1.onlyann.pcloadings.tab",sep="\t",quote = F,col.names = T,row.names = F)


###########
#Plot PCA
##########
ggplot(data=tab,aes(EV1,EV3)) + geom_point(aes(color=latitude)) + ylab("Principal component 2") + xlab("Principal component 1")

dot_size <- 2
map <- get_map(location = c(lon = -100, lat = 35), zoom=4, source="stamen", maptype="toner")
pc1 <- ggmap(map) + geom_point(data=tab, aes(y=latitude,x=longitude, color=EV1),size=dot_size,alpha=0.8)+ scale_color_viridis(name="PC1") +
  ylab("Latitude") + xlab("Longitude") + ggtitle("PC1 (PVE=5.46%)")
pc2 <- ggmap(map) + geom_point(data=tab, aes(y=latitude,x=longitude, color=EV2),size=dot_size,alpha=0.8)+ scale_color_viridis(name="PC2") +
  ylab("Latitude") + xlab("Longitude") + ggtitle("PC2 (PVE=2.95%)")
pc3 <- ggmap(map) + geom_point(data=tab, aes(y=latitude,x=longitude, color=EV3),size=dot_size,alpha=0.8)+ scale_color_viridis(name="PC3") +
  ylab("Latitude") + xlab("Longitude") + ggtitle("PC3 (PVE=2.53%)")
pc4 <- ggmap(map) + geom_point(data=tab, aes(y=latitude,x=longitude, color=EV4),size=dot_size,alpha=0.8)+ scale_color_viridis(name="PC4") +
  ylab("Latitude") + xlab("Longitude") + ggtitle("PC4 (PVE=2.16%)")

pdf("germplasm.freebayes.80.1.onlyann.pca.pdf")
multiplot(pc1, pc2, pc3, pc4, cols=2)
dev.off()


###########
#Extract PCA loadings
###########

pca_load <- snpgdsPCASNPLoading(pca, genofile_all, num.thread = 3)
load_df <- data.frame(snp = pca_load$snp.id, load_ev1 = t(pca_load$snploading)[,1], load_ev2 = t(pca_load$snploading)[,2], 
                      load_ev3 = t(pca_load$snploading)[,3], load_ev4 = t(pca_load$snploading)[,4])
load_df %>% arrange(desc(abs(load_ev2)))
write.table(load_df,file="/home/owens/working/germplasm/germplasm.freebayes.80.1.onlyann.pcloadings.tab",sep="\t",quote = F,col.names = T,row.names = F)


