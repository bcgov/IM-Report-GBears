# Copyright 2017 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#GB_AOI_MapsGBPU_Rank - Don Morgan, MoE, 250.877.3199
#Script creates a map of NatureServe rank

#Subset GBPUs
subGBPU1<-subset(GBPU, POPULATION %in% GBPU.context)
subGBPU<-merge(subGBPU1,GBRe_Rank,by='POPULATION')

#M1 M1M2 M2  orange        high management concern
#M3         yellow        moderate management concern
#M3M4 M4     light green   low m'anagement concern
#M45M M5     dark green    very low management concern

#Plotting
par(mar=c(3.1,3.1,1.1,1.1))
pdf(file=paste(figsOutDir,"GBPU_",AOI,".pdf",sep=""))
plotvar2<-(subGBPU@data$Re_Rank)
plotclr<-(c("M1","M1M2","M2","M2M3","M3","M4","M4M5","M5"))
nclr<-length(plotclr)
names(plotclr) <- c('orange2','orange2','orange2','yellow2','yellow2','green2','green4','green4')
match.idx <- match(plotvar2, plotclr)
colcode <- ifelse(is.na(match.idx), plotvar2, names(plotclr)[match.idx])

plot(subGBPU, col=colcode)
lines(AOIShp, col="blue", lwd==50)

legend("topright", legend=c("M1","M1M2","M2","M2M3","M3","M4","M4M5","M5"), fill=c((names(plotclr))), cex=0.8, bty="n", title="Grizzly Bear-Status")
scalebar(100000, xy=c(1200000,1150000), type="bar",divs=4, below="kilometers", cex=0.8, lonlat=FALSE,label=c("0","5","10"))#, adj=c(0.5,-1.5))
north.arrow(xb=1000000,yb=1350000, len=10000, cex=0.8)

#text(790000,1075000,cex=1.5,AOI)
#plot labels on each of the polygons
#slotNames(subGBPU) - "data"        "polygons"    "plotOrder"   "bbox"        "proj4string"
#subGBPU@polygons[[1]]@labpt
cents <- SpatialPointsDataFrame(coords=coordinates(subGBPU), data=data.frame(subGBPU@data$POPULATION), proj4string=CRS("+proj=longlat +ellps=clrk66"))
text(cents,cents@data[[1]], cex=0.9)

dev.off()
