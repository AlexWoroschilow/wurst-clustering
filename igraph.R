library(igraph)
#G<-read.graph("/Volumes/HD/Users/margraf/pdb90_k20_w.ncol", format='ncol')
G<-read.graph("/Volumes/HD/Users/margraf/all_k50_tmscore.ncol", format='ncol')
#G<-as.undirected(G, mode="each")

summary(G)

diam<-get.diameter(G, directed = FALSE)
av_pl<-average.path.length(G)
bccs<-c()
### Calculate BCCs
G<-read.graph("/Volumes/HD/Users/margraf/pdb90_k20_w_rmsd.ncol", format='ncol', directed=TRUE)
for (x in 1:10){
	G <- delete.edges(G, E(G)[ weight > 1/x ])
	bcc <- biconnected.components(G)
	bccs[x] <- bcc$no

}
biconco<-bccs

### Calculate clusters per cutoff
G<-read.graph("/Volumes/HD/Users/margraf/pdb90_k20_w_rmsd.ncol", format='ncol', directed=TRUE)
for (x in 1:10){
	G <- delete.edges(G, E(G)[ weight < x/10 ])
	bccs[x] <- no.clusters(G)
	maxcsiz[x] <- length(cluster.distribution(G))-1
}

### Plot clusters, bccs
plot(bccs, xlab=expression(paste("RMSD cutoff " (ring(A)))), ylab="# of clusters")
points(biconco, pch=19, col="black")
legend("topright", c("Clusters", "Biconnected Components"), pch=c(21, 19))








memberships <- list()
bccs <- c()
for (x in c(20:1)){
	bccs[x] <- biconnected.components(G)
	delete.edges(G, E(G)[ weight >= x ])
}

	### fastgreedy.community
	fc <- fastgreedy.community(G)
	memb <- community.to.membership(G, fc$merges,
                               steps=which.max(fc$modularity)-1)
	memberships$x <- memb$membership


}
### leading.eigenvector.community
lec <- leading.eigenvector.community(G)
memberships$`Leading eigenvector` <- lec$membership

### label.propagation.community
memberships$`Label propagation` <- label.propagation.community(G)

V(G)$color <- rainbow(length(unique(memberships$'Leading eigenvector')))[memberships$'Leading eigenvector'+1]
G$layout <- layout.lgl
summary(memberships$`Leading eigenvector`)
summary(memberships$`Label propagation`)



