
## MARK NEWMAN'S ALGORITHM AS PROPOSED IN  ARXIV REF: physics/0605087
## from: http://lists.gnu.org/archive/html/igraph-help/2007-03/msg00033.html

######################################################################################
# RETURN THE MODULARITY MATRIX AS DEFINED BY NEWMAN 
# Q = A - B WHERE B IS BASED ON A PROBABILITY OF EXISTENCE OF AN EDGE
# IN THIS CASE BASED ON THE CONFIGURATION MODEL
######################################################################################
graph.modularity=function(g){
	d <- degree(g)
	m <- ecount(g)
	vcnt <- vcount(g) 
	B<-matrix(0,nrow=vcnt,ncol=vcnt)
	for(i in 1:vcnt){
		for(j in 1:vcnt){
			B[i,j] <- d[i]*d[j]/(2*m)
		}
	}
	A <- get.adjacency(g)
	Q <- A-B
	return(Q)
}


######################################################################################
# detect.communities
# THE MAIN ROUTINE FROM WHERE COMMUNITIES ARE DETECTED USING THE MODULARITY MATRIX 
######################################################################################
detect.communities=function(g,indvsbl=0){
	V(g)$lbl<-0:(vcount(g)-1)
	V(g)$cmn<-rep(-1,vcount(g))
	g <- modularity.partitioning(g,g,indvsbl)
	####
	#clrs<-rainbow(max(V(g)$cmn)+1)
	#lay<-layout.kamada.kawai(g)
	#plot(g,vertex.color=clrs[V(g)$cmn+1],vertex.size=2,layout=lay, vertex.label=NA, edge.arrow.size=0)
	####
	membership <- V(g)$cmn
	csize <- c()
	for(i in 1:max(V(g)$cmn+1)){
		csize[i] <- length(which(V(g)$cmn==(i-1))) 
	}
	ret <- list(g,membership,csize)
	names(ret) <- c("g","membership","csize")
	return(ret)
}

#####################################################
# modularity.partitioning
# THE RECURSIVE FUNCTION CALL STOPS WHEN A SUBDIVISION DOES
# NOT CONTRIBUTE TO THE MODULARITY (A NEGATIVE LARGEST EIGENVALUE)
#####################################################
modularity.partitioning=function(g,sg,indvsbl){
	## MODULARITY MATRIX OF THE SUBGRAPH
	Q<-graph.modularity(sg)
	## EIGENVALUES OF THE MODULARITY 
	eg<-eigen(Q);
	evl<-eg$values
	max_eval<-sort(evl,decreasing=T,index.return=T)
	## IF INDIVISIBLE THEN COLOR/TAG THE COMMUNITY AND RETURN THE CURRENT GRAPH
	if(round(Re(max_eval$x[1]), digits=2)<=indvsbl) { 
	## COLOR VERTICES IN THE COMMUNITY
		col<-max(V(g)$cmn)+1
		V(g)[V(sg)$lbl]$cmn <- col
		return(g)
	}
	## ELSE GET PRINCIPAL EIGENVECTOR
	v<-Re(eg$vectors[,max_eval$ix[1]])

	## PARTITION THE VERTICES ACCORDING TO THE SIGNS OF THE EIGENVECTOR ELTS 
	neg<-which(v<0)
	pos<-which(v>=0)
	## COLOR VERTICES IN THE COMMUNITY
	## RECURSIVELY EXPLORE THE PARTITION OF NEGATIVE EIGENVECTOR CONTRIBUTIONS
	g <- modularity.partitioning(g,subgraph(g,V(sg)$lbl[neg]),indvsbl) 
	## RECURSIVELY EXPLORE THE PARTITION OF POSITIVE EIGENVECTOR CONTRIBUTIONS
	g <- modularity.partitioning(g,subgraph(g,V(sg)$lbl[pos]),indvsbl)
	return(g)
}

test.modularity=function(){
	tree100 <- graph.tree(100,mode="undirected")
	cmn1 <- detect.communities(tree100,0)
	quartz();
	cmn2 <- detect.communities(tree100,2)
}
#detect.communities(cls[[4]], 2)

memb2clust<-function(ms, graph, clid){
	clustering <- data.frame(ID=rep("X", length(ms)), DEG=rep(NA, length(ms)), CLUST=rep(NA, length(ms)), 	stringsAsFactors=FALSE)
	sidx <- 1;
	for (i in sort(unique(ms))){
		for(j in 1:length(ms)){
			if(ms[j] == i){
				clustering[sidx, ] <- list(V(graph)[j-1]$name, length(V(graph)[ nei( j-1 ) ]), clid)
				sidx <- sidx+1
			}
		}
		clid <- clid+1
	}
	return(clustering)
}

do.clustering<-function(graph, clustering, clid){
	sidx <- 1
	if ( length(V(graph)) < 5 ){
		tc <- data.frame(ID=rep(" ", length(V(graph))), DEG=rep(NA, length(V(graph))), CLUST=rep(NA, length(V(graph))), 	stringsAsFactors=FALSE)

		for ( i in 0:( length(V(graph))-1 ) ){
			tc[sidx, ] <- list( V(graph)[i]$name, length(V(graph)[ nei( i ) ]), clid )
			sidx <- sidx+1
		}
		clid <- clid+1
		clustering<-rbind(clustering, tc)
		return(clustering)
	}
	else{ 
		ms<-detect.communities(graph, 8)$membership
		if(diameter(graph, directed=FALSE, weights=NA) < 4 || length(unique(ms)) < 2){
			tc<-memb2clust(ms, graph, clid+1)
			clustering<-rbind(clustering, tc)
			sidx <- sidx+length(tc)
			clid <- tc[length(tc[,1]), 3]
			return(clustering)
		}
		else{   # Extract Subgraphs
			for (i in sort(unique(ms))){
				cat(i, '\n')
				sgids <- c(rep(1, sum(ms==i)))
				sgidx <- 1
				for(j in 1:length(ms)){
					if(ms[j] == i){
						sgids[sgidx] <- j-1
						sgidx <- sgidx+1
						
					}
				}
				cat(sgids, '\n')
				sg <- subgraph(graph, sgids)
				
				tc<-do.clustering(sg, clustering, clid+1)
				clustering<-rbind(clustering, tc)
				sidx <- sidx+length(tc)
				
				#clid <- tc[length(tc[,1]), 3]
			}
		}
	return(clustering)
	}
}


######################################################################################
# cluster.graph
######################################################################################
cluster.graph<-function(G){
	cls2<-decompose.graph(G, min.vertices = 0)

#	clustering <- data.frame(ID=rep(" ", length(V(G))), DEG=rep(NA, length(V(G))), CLUST=rep(NA, length(V(G))), 	stringsAsFactors=FALSE)
	clustering <- data.frame(ID, DEG, CLUST, stringsAsFactors=FALSE)
	clid <- 0;
	sidx <- 1;
#	for ( c in 1:length(cls2)){
	for ( c in 1:3){
		sidx <- 1;
		do.clustering(cls2[[c]], clustering, clid)
	}
	sortclust<-clustering[ order(clustering$CLUST, -clustering$DEG), ]
	return(sortclust)
}

######################################################################################
#  print.clustering
######################################################################################
print.clustering<-function(sortclust, filen=''){
	clid = sortclust[1, ]$CLUST
	idx<- 1
	for (i in 1:length(sortclust[,1])){
		if(clid != sortclust[i, ]$CLUST){
			clid<-sortclust[i, ]$CLUST
			idx<- 1
		}
		cat(sortclust[i, ]$CLUST, idx, sortclust[i, ]$ID, sep='\t', file=filen, append=TRUE)
		cat('\n', file=filen, append=TRUE)
		idx<-idx+1	
	}
}

cluster.graph.OLD_BROKEN<-function(G){
	cls2<-decompose.graph(G, min.vertices = 0)

	clustering <- data.frame(ID=rep(" ", length(V(G))), DEG=rep(NA, length(V(G))), CLUST=rep(NA, length(V(G))), 	stringsAsFactors=FALSE)
	clid <- 0;
	sidx <- 1;
	for ( c in 1:length(cls2)){
		do.clustering()
		
		else{
			ms<-detect.communities(cls2[[c]], 0)$membership
			if(diameter(cls2[[c]], directed=FALSE, weights=NA) > 3){
				for (i in sort(unique(ms))){
					sgids <- c()
					sgidx <- 0
					for(j in 1:length(ms)){
						if(ms[j] == i){
							sgids[sgidx] <- j
							sgidx <- sgidx+1
						}
					}
					sg <- subgraph(cls2[[c]], sgids);
					sms<-detect.communities(sg, 0)$membership
					for (i in sort(unique(sms))){
						for(j in 1:length(sms)){
							if(sms[j] == i){
								clustering[sidx, ] <- list(V(sg)[j-1]$name, length(V(sg)[ nei( j-1 ) ]), clid)
								sidx <- sidx+1
							}
						}
						clid <- clid+1
					}
				}
				
			}
			else{
				for (i in sort(unique(ms))){
					for(j in 1:length(ms)){
						if(ms[j] == i){
							clustering[sidx, ] <- list(V(cls2[[c]])[j-1]$name, length(V(cls2[[c]])[ nei( j-1 ) ]), clid)
							sidx <- sidx+1
						}
					}
					clid <- clid+1
				}
			}
		}
	}
	sortclust<-clustering[ order(clustering$CLUST, -clustering$DEG), ]
	return(sortclust)
}
