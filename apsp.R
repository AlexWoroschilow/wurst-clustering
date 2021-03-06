
labels<-as.vector(unique(dat$ID1))
labels2<-as.vector(unique(dat$ID2))
labels<-append(labels, labels2)
labels<-unique(labels)
eg<-graph.empty(n=0, directed=F)
eg<-add.vertices(eg, length(labels), name=labels)
for(i in 1:length(dat$ID1)){
    eg<-add.edges(eg, c(V(eg)[name == dat[i,]$ID1], V(eg)[name == dat[i,]$ID2]), weight=dat[i,]$TM.score)
}
nm8d<-decompose.graph(eg, min.vertices = 2)

for(d in 1:length(nm8d)){
    dmat<-get.adjacency(nm8d[[d]], type="both", attr="weight")
    for(i in length(dmat[1])){
        dmat[i][i]<-1
    }
    for(k in 1:length(dmat[1])){
        for(i in 1:length(dmat[1])){
            for(j in 1:length(dmat[1])){
                dmat[i][j] = max(dmat[i][j], dmat[i][k]*dmat[k][j])
            }
        }
    }

    for(i in 1:length(dmat[1])){
        for(j in i:length(dmat[1])){
            idx<- which(dat$ID1==rownames(dmat)[i] & dat$ID2==colnames(dmat)[j], arr.ind=TRUE)[1]
            if(is.na(idx)){
                idx<- which(dat$ID1==rownames(dmat)[j] & dat$ID2==colnames(dmat)[i], arr.ind=TRUE)[1]
            }
            #print(rownames(dmat)[j])
            #print(colnames(dmat)[i]) 
            #print(new8[idx, ])
            if(! is.na(idx)){
                dat[idx, ]$TM.score <- dmat[i][j]
            }
        }
    }
}
