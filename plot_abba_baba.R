#Plotting ABBA BABA
abba <- read.table("/home/owens/working/germplasm/germplasm.freebayes.abbaout.summary.txt",header=T)

abba$species <- factor(abba$species, levels = c("bol","arg","deb","pra"))
pdf("germplasm.freebayes.abbaout.summary.pdf")
ggplot(abba, aes(x=species, y=D)) + 
  geom_errorbar(aes(ymin=D-D_stdev, ymax=D+D_stdev), width=.1) +
  geom_point() + theme_bw() + geom_hline(yintercept=0,linetype="dotted") + 
  xlab("Species") + ylab("Patterson's D") +
  scale_x_discrete(labels=c("bol" = expression(italic("H. bolanderi/H. exilis")), 
                            "arg" = expression(italic("H. argophyllus")),
                            "deb" = expression(italic("H. debilis")),
                            "pra" = expression(italic("H. praecox")))) +
  theme(axis.text.x = element_text(angle=45, hjust=1)) +
  annotate("text",x=1,y=0.21,label="*",size=7) +
  annotate("text",x=2,y=0.21,label="*",size=7) +
  annotate("text",x=1,y=0.22,label="*",size=7,color="white") +
  geom_vline(xintercept=1.5,linetype="solid") +
  annotate("text",x=0.95,y=0.3,label="California",size=5) +
  annotate("text",x=3,y=0.3,label="Texas",size=5)
dev.off()
