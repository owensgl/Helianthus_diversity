raw <- read.table("/home/owens/working/germplasm/germplasm.freebayes.variable.PCintrogression.tab",header=T)

raw %>% filter(pc == 1, species == "bol" | species == "exi") %>% filter(pc_ranking < 100) %>%
  select(result) %>%
  group_by(result) %>% tally()
  ggplot(.,aes(x=species, y=result)) + geom_bar()

raw %>% filter(pc == 3, species == "arg" | species == "pra"  | species == "deb") %>% 
  filter(pc_ranking > 100) %>% group_by(species,result) %>% ggplot(.,aes(x= species, fill=as.factor(result))) +geom_bar()

raw %>% filter(pc == 2, species == "pra" ) %>% filter(pc_ranking < 100) %>%
  select(result) %>%
  group_by(result) %>% tally()

raw %>% filter(pc == 1) %>% filter(pc_ranking < 100) %>% filter(species == "bol" | species == "exi") %>%
  ggplot(.,aes(x= 1, fill=as.factor(result))) +geom_bar()

raw %>% filter(pc == 1, species == "bol" | species == "exi") %>% filter(pc_ranking < 100) %>%
  mutate(neg_pos = (neg_freq - pos_freq), neg_out = (neg_freq - species_freq)) %>% 
  filter(neg_pos < 0 & neg_out < 0 | neg_pos > 0 & neg_out > 0) %>% 
  tally()
#65/197 match positive PC1 direction of allele change for bolanderi/exilis
raw %>% filter(pc == 2, species == "arg") %>% filter(pc_ranking < 100) %>%
  mutate(pos_neg = (pos_freq - neg_freq), pos_out = (pos_freq - species_freq)) %>% 
  filter(pos_neg < 0 & pos_out < 0 | pos_neg > 0 & pos_out > 0) %>% 
  tally()
#47/94 match negative PC2 direction of allele change for argophyllus

raw %>% filter(pc == 2, species == "deb") %>% filter(pc_ranking < 100) %>%
  mutate(pos_neg = (pos_freq - neg_freq), pos_out = (pos_freq - species_freq)) %>% 
  filter(pos_neg < 0 & pos_out < 0 | pos_neg > 0 & pos_out > 0) %>% 
  tally()
#41/95 match negative PC2 direction of allele change for debilis
