library(ggtree)
library(phytools)
library(viridis)

#tree <- read.tree("/home/owens/working/germplasm/germplasm.freebayes.80.1.fasta.treefile")
pdf("germplasm.freebayes.80.1.fasta.labelledtree.pdf", width=20,height=14)
p <- ggtree(tree) +
  #geom_text2(aes(subset=!isTip, label=node), hjust=-.3) +  
  #geom_tiplab() +
  geom_cladelabel(node=410, label="", align=T, offset=.1,color="white") + 
  geom_cladelabel(node=410, label="H. annuus", align=T, offset=.01) + 
  geom_cladelabel(node=442, label="H. winteri", align=T, offset=-.1) +
  geom_cladelabel(node=396, label="H. argophyllus",align=T, offset=.01) +
  geom_cladelabel(node=517, label="H. bolanderi/ H. exilis",align=T, offset=.01) +
  geom_cladelabel(node=297, label="H. anomalus",align=T, offset=.01) +
  geom_cladelabel(node=341, label="H. petiolaris fallax / H. neglectus",align=T, offset=.01) +
  geom_cladelabel(node=364, label="H. petiolaris petiolaris",align=T, offset=.01) +
  geom_cladelabel(node=303, label="H. deserticola",align=T, offset=.01) +
  geom_cladelabel(node=334, label="H. praecox",align=T, offset=.01) +
  geom_cladelabel(node=319, label="H. debilis",align=T, offset=.01) +
  geom_cladelabel(node=377, label="H. niveus",align=T, offset=.01) +
  geom_cladelabel(node=534, label="H. paradoxus",align=T, offset=.01) +
  geom_cladelabel(node=547, label="H. nuttallii",align=T, offset=.01) +
  geom_cladelabel(node=541, label="H. grosseserratus",align=T, offset=.01) +
  geom_cladelabel(node=550, label="H. maximilliani",align=T, offset=.01) +
  geom_cladelabel(node=558, label="H. giganteus",align=T, offset=.01) +
  geom_cladelabel(node=562, label="H. tuberosus",align=T, offset=.01) +
  geom_cladelabel(node=563, label="H. tuberosus",align=T, offset=.01) +
  geom_cladelabel(node=576, label="H. decapetalus",align=T, offset=.01) +
  geom_cladelabel(node=567, label="H. divaricatus / H. strumosus / H. hirsutus",align=T, offset=.01) +
  #geom_text2(aes(subset=!isTip, label=label),alpha=0.7) +
  geom_text2(aes(subset=410, label=label),alpha=0.7) +
  geom_text2(aes(subset=396, label=label),alpha=0.7) +
  geom_text2(aes(subset=517, label=label),alpha=0.7) +
  geom_text2(aes(subset=297, label=label),alpha=0.7) +
  geom_text2(aes(subset=341, label=label),alpha=0.7) +
  geom_text2(aes(subset=364, label=label),alpha=0.7) +
  geom_text2(aes(subset=303, label=label),alpha=0.7) +
  geom_text2(aes(subset=334, label=label),alpha=0.7) +
  geom_text2(aes(subset=319, label=label),alpha=0.7) +
  geom_text2(aes(subset=377, label=label),alpha=0.7) +
  geom_text2(aes(subset=534, label=label),alpha=0.7) +
  geom_text2(aes(subset=547, label=label),alpha=0.7) +
  geom_text2(aes(subset=541, label=label),alpha=0.7) +
  geom_text2(aes(subset=550, label=label),alpha=0.7) +
  geom_text2(aes(subset=558, label=label),alpha=0.7) +
  geom_text2(aes(subset=562, label=label),alpha=0.7) +
  geom_text2(aes(subset=563, label=label),alpha=0.7) +
  geom_text2(aes(subset=576, label=label),alpha=0.7) +
  geom_text2(aes(subset=567, label=label),alpha=0.7) +
  geom_text2(aes(subset=291, label=label),alpha=0.7) +
  geom_text2(aes(subset=535, label=label),alpha=0.7) +
  geom_text2(aes(subset=292, label=label),alpha=0.7) +
  geom_text2(aes(subset=293, label=label),alpha=0.7) +
  geom_text2(aes(subset=294, label=label),alpha=0.7) +
  geom_text2(aes(subset=295, label=label),alpha=0.7) +
  geom_text2(aes(subset=296, label=label),alpha=0.7) +
  geom_text2(aes(subset=316, label=label),alpha=0.7) +
  geom_text2(aes(subset=340, label=label),alpha=0.7) +
  geom_text2(aes(subset=394, label=label),alpha=0.7) +
  geom_text2(aes(subset=395, label=label),alpha=0.7) +
  geom_text2(aes(subset=317, label=label),alpha=0.7) +
  geom_text2(aes(subset=540, label=label),alpha=0.7) 
  
  
  
  p <- p %<+% specieslabels  + theme(legend.position="right") +
  geom_tippoint(aes(color=species), size=10,alpha=0.25) 
p
dev.off()
  
ggtree(tree) +
  geom_text2(aes(subset=!isTip, label=node)) + geom_tiplab() 

p <- ggtree(tree)
#tree <- reroot(tree, 395)
tree <- reroot(tree, 302)
viewClade(p+geom_tiplab()+geom_text2(aes(subset=!isTip, label=node), hjust=-.3), node=410)

specieslabels <- read.table("/home/owens/working/germplasm/germplasm.poplist.withold.txt",header=F)
colnames(specieslabels) <- c("taxa","species")


