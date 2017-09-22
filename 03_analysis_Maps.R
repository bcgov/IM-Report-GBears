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

#Maps Provincial LU indicators
#By Don Morgan, MoE

#Plotting - first rd density then mid seral
pdf(file=paste(figsOutDir,"RdDens_",AOI,".pdf",sep=""))

plotvar2<-(MapGBPU$rdDens_Ris)
nclr<-5
#Use all LUs in province so scale provincially
plotclr<-unique(ProvLUs$rdDens_Ris)

#change order of plot names for legend
plot_names<-c(as.character(plotclr[1]),as.character(plotclr[2]),as.character(plotclr[3]),as.character(plotclr[5]),as.character(plotclr[4]))

col_vec<-c(rev(brewer.pal(nclr,"RdYlGn")))
#change order of colours 
names(plotclr) <- c(col_vec[1:3],col_vec[5],col_vec[4])
match.idx <- match(plotvar2, plotclr)
colcode <- ifelse(is.na(match.idx), plotvar2, names(plotclr)[match.idx])

plot(MapGBPU, col=colcode)
#lines(subTSA, col="blue", lwd==0.8)
lines(AOIShp, col="blue", lwd==50)
#lines(OWMap, col="purple", lwd==100)
legend("topright", legend=plot_names, fill=col_vec, cex=0.6, y.intersp=1.1, bty="o", bg='white', title="Grizzly Bear-Rd Density")
#legend("topright", legend=unique(LUs$rdDens_Ris), fill=c((names(plotclr))), cex=0.8, y.intersp=1.1, bty="n", title="Grizzly Bear-Rd Density")

#text(1405000,1100000,AOI)
scalebar(100000, xy=c(1200000,1150000), type="bar",divs=4, below="kilometers", cex=0.8, lonlat=FALSE,label=c("0","5","10"))#, adj=c(0.5,-1.5))
north.arrow(xb=1000000,yb=1350000, len=10000, cex=0.8)

dev.off()

#Print mid seral map
pdf(file=paste(figsOutDir,"MidSeral_",AOI,".pdf",sep=""))

plotvar2<-(MapGBPU$BEC_midSer)
nclr<-3
plotclr<-unique(ProvLUs$BEC_midSer)
#change order of plot names for legend
#plot_names<-c(as.character(plotclr[1]),as.character(plotclr[2]),as.character(plotclr[3]),as.character(plotclr[5]),as.character(plotclr[4]))
plot_names<-plotclr

col_vec<-c(rev(brewer.pal(nclr,"RdYlGn")))
#change order of colours if required
#names(plotclr) <- c(col_vec[1:3],col_vec[5],col_vec[4])
names(plotclr)<-col_vec
match.idx <- match(plotvar2, plotclr)
colcode <- ifelse(is.na(match.idx), plotvar2, names(plotclr)[match.idx])


plot(MapGBPU, col=colcode)
lines(AOIShp, col="blue", lwd==50)
#lines(subTSA, col="blue", lwd==0.8)

legend("topright", legend=plot_names, fill=col_vec, cex=0.6, y.intersp=1.1, bty="o", bg='white', title="Grizzly Bear-Mid Seral")
#legend("topright", legend=unique(ProvLUs$rdDens_Ris), fill=c((names(plotclr))), cex=0.8, y.intersp=1.1, bty="n", title="Grizzly Bear-Rd Density")

#text(1405000,1100000,AOI)
scalebar(100000, xy=c(1200000,1150000), type="bar",divs=4, below="kilometers", cex=0.8, lonlat=FALSE,label=c("0","5","10"))#, adj=c(0.5,-1.5))
north.arrow(xb=1000000,yb=1350000, len=10000, cex=0.8)

dev.off()
#Print core security map
pdf(file=paste(figsOutDir,"CoreSecure_",AOI,".pdf",sep=""))

plotvar2<-(MapGBPU$LU_Secure1)
nclr<-3
plot_names<-c('60-100','30-60 (flag)','0-30 (flag)')
MaxClassI<-classIntervals(plotvar2, n=nclr, style="fixed",fixedBreaks=c(0,30,60,101))
plotvar3<-findInterval(plotvar2,MaxClassI$brks)
plotclr<-unique(plotvar3)

col_vec<-c(rev(brewer.pal(nclr,"RdYlGn")))

#names(plotclr) <- c(col_vec[1:3])
names(plotclr) <- c(col_vec[1],col_vec[3],col_vec[2])
match.idx <- match(plotvar3, plotclr)
colcode <- ifelse(is.na(match.idx), plotvar2, names(plotclr)[match.idx])

par(mar=c(1.1,1.1,1.1,1.1))
plot(MapGBPU, col=colcode)
lines(AOIShp, col="blue", lwd==50)

legend("topright", legend=plot_names, fill=col_vec, cex=0.6, y.intersp=1.1, bty="o", bg='white', title="Grizzly Bears: Proportion of Capable Secure")
#legend("topright", legend=unique(ProvLUs$rdDens_Ris), fill=c((names(plotclr))), cex=0.8, y.intersp=1.1, bty="n", title="Grizzly Bear-Rd Density")

#text(1405000,1100000,AOI)
scalebar(100000, xy=c(1200000,1150000), type="bar",divs=4, below="kilometers", cex=0.8, lonlat=FALSE,label=c("0","5","10"))#, adj=c(0.5,-1.5))
north.arrow(xb=1000000,yb=1350000, len=10000, cex=0.8)

dev.off()

pdf(file=paste(figsOutDir,"FrontCountry_",AOI,".pdf",sep=""))

plotvar2<-(MapGBPU$Front_Coun)
nclr<-5

plot_names<-c('0-20','21-40 (flag)','41-60 (flag)','61-80 (flag)','81-100 (flag)')
#plot_names<-c('81-100 (flag)','61-80 (flag)','41-60 (flag)','21-40 (flag)','0-20')
MaxClassI<-classIntervals(plotvar2, n=nclr, style="fixed",fixedBreaks=c(0,20,40,60,80,101))
plotvar3<-findInterval(plotvar2,MaxClassI$brks)
plotclr<-unique(plotvar3)

col_vec<-c(rev(brewer.pal(nclr,"RdYlGn")))

names(plotclr) <- c(col_vec[1:5])
#names(plotclr) <- c(col_vec[1],col_vec[3],col_vec[2])
plotclr<-sort(plotclr)
match.idx <- match(plotvar3, plotclr)
colcode <- ifelse(is.na(match.idx), plotvar3, names(plotclr)[match.idx])

par(mar=c(1.1,1.1,1.1,1.1))
plot(MapGBPU, col=colcode)
lines(AOIShp, col="blue", lwd==50)

legend("topright", legend=plot_names, fill=col_vec, cex=0.6, y.intersp=1.1, bty="o", bg='white', title="Grizzly Bears: Proportion of Front Country")
#legend("topright", legend=unique(ProvLUs$rdDens_Ris), fill=c((names(plotclr))), cex=0.8, y.intersp=1.1, bty="n", title="Grizzly Bear-Rd Density")

text(1405000,1100000,AOI)
scalebar(100000, xy=c(1200000,1150000), type="bar",divs=4, below="kilometers", cex=0.8, lonlat=FALSE,label=c("0","5","10"))#, adj=c(0.5,-1.5))
north.arrow(xb=1000000,yb=1350000, len=10000, cex=0.8)

dev.off()


