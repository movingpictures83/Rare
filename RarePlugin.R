library(microbiome)
library(ggplot2)
#library(phyloseq)
library(ape)
library(psadd)

input <- function(inputfile) {
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1]; 
   # Need to get the three files
   otu.path <<- parameters["otufile", 2]
   tree.path <<- parameters["tree", 2]
   map.path <<- parameters["mapping", 2]
   detection <<- parameters["detection", 2]
   preval <<- parameters["prevalence", 2]
   #HMP <<- import_qiime(otu.path, map.path, tree.path, parseFunction = parse_taxonomy_qiime)
}
run <- function() {
   #samples.to.keep <<- sample_sums(HMP) >= 1000
   #HMP <<- prune_samples(samples.to.keep, HMP)
   #HMP <<- filter_taxa(HMP, function(x) sum(x >3) > (0.01*length(x)), TRUE)
   physeq <<- read_csv2phyloseq(otu.file=otu.path, taxonomy.file=tree.path, metadata.file=map.path)
   mytree = rtree(ntaxa(physeq), rooted=TRUE, tip.label=taxa_names(physeq))
   physeq <<- merge_phyloseq(physeq, mytree)
}
output <- function(outputfile) {
  #height = 10*300); #,)
  #result <<- PCoA(physeq)
  rareindex <- rare_abundance(physeq, detection, preval)
  members <- rare_members(physeq, detection, preval)
  rareamt <- rarity(physeq, detection=detection, prevalence=preval) 
  #y <- plot_sparsity(p0)
  #print(str(y))
  #print(str(y$data))
  write.csv(members, paste(outputfile, "members", "csv", sep="."))
  write.csv(rareindex, paste(outputfile, "rareindex", "csv", sep="."))
  write.csv(rareamt, paste(outputfile, "rarity", "csv", sep="."))
}
#input("plugins/Bar/example/parameters.txt")
#run()
#output("plugins/Bar/example/yes.pdf")

