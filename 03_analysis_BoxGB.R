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

# Box.2 for displaying 2 horizontal boxplots on the same graph
#
# Developed by ESSA technologies under contract to the Province of BC
# 

Box.2<-function(dataframe1, dataframe2, use.field="", use.xlab="", use.units="", use.t, use.filename="", use.cuname="", use.compUnit=""){
  use.df1<-as.numeric(unlist(dataframe1[use.field]))
  use.df2<-as.numeric(unlist(subset(dataframe2[use.field],dataframe2[use.field]!="-")))
  n.df1<-length(use.df1)
  n.df2<-length(use.df2)
  use.xlim<-round(max(use.df2)+.1*max(use.df2))
  
  # set-up 8 x 1.5 inch PNG output file and plot margins
  png(use.filename,width=8,height=1.5,units="in",res=150)
  par(pin=c(8.5, 1.5),mai=c(0.6,2.7,0.1,1.8),
  #par(pin=c(8.5, 1.5),mai=c(0.6,2.2,0.1,1.8),
          cex=1,mgp=c(1.6,0.5,0),ljoin=1,las=1)
  
  # force to not use scientific notation for numbers
  options(scipen=50) 
  
  # empty plot
  boxplot(list(use.df1,use.df2),horizontal=TRUE,las=1,
          medlty='blank',boxlty="blank",whisklty="blank",names=c("",""),
          staplelty='blank',outlty='blank',outpch=NA)

  # draw shaded green/yellow/red background based on threshold values
  cust.green <- rgb(101,163, 0, alpha=150, maxColorValue=255)   
  cust.yellow<-rgb(255, 255, 0, alpha=150, maxColorValue=255)
  cust.red<-rgb(255, 90, 0, alpha=250, maxColorValue=255)
  #The names haven't changes, but the colours are now very light blue, medium blue, and dark blue
  #cust.green <- rgb(240,249,232, alpha=150, maxColorValue=255)   
  #cust.yellow<-rgb(186,228,188, alpha=250, maxColorValue=255)
  #cust.red<-rgb(123,204,196, alpha=250, maxColorValue=255)
 

 # set left limit of green to -50000 so there is no white space in Water Allocation graphs
  rect(-50000,-1,use.t[1],100,col=cust.green,border=NA) 
  rect(use.t[1],-1,use.t[2],100,col=cust.yellow,border=NA)
  rect(use.t[2],-1,use.xlim+100,100,col=cust.red,border=NA)
  
  # set-up and draw legend
  leg.pos<-"topleft"
  # if indicator has binary use.t...
  if (use.t[1]==0 & use.t[2]==0){
    use.leg1<-c("Lower Risk",as.expression(bquote("(="~.(use.t[1])~.(use.units)*")")))
    use.leg2<-c("Higher Risk",as.expression(bquote("(>"~.(use.t[1])~.(use.units)*")")))
    legend(leg.pos,inset=c(1,0),xpd=TRUE,fill=c(cust.green,"white"),border=c("black","white"),
           legend=use.leg1, bty='n',y.intersp=.75)
    legend(leg.pos,inset=c(1,0.5),xpd=TRUE,fill=c(cust.red,"white"),border=c("black","white"),
           legend=use.leg2, bty='n',y.intersp=.75)
  } else {
    if(use.t[1]==0){
      use.leg1<-c("Low Risk",as.expression(bquote("(="~.(use.t[1])~.(use.units)*")")))
      use.leg2<-c("Moderate Risk",as.expression(bquote("(>"~.(use.t[1])~.(use.units)*")")))
      use.leg3<-c("High Risk",as.expression(bquote("(>="~.(use.t[2])~.(use.units)*")")))
    } else {
      use.leg1<-c("Low Risk",as.expression(bquote("(<"~.(use.t[1])~.(use.units)*")")))
      use.leg2<-c("Moderate Risk",as.expression(bquote("(>="~.(use.t[1])~.(use.units)*")")))
      use.leg3<-c("High Risk",as.expression(bquote("(>="~.(use.t[2])~.(use.units)*")")))
    }
    legend(leg.pos,inset=c(1,0),xpd=TRUE,fill=c(cust.green,"white"),border=c("black","white"),
           legend=use.leg1, bty='n',y.intersp=.75)
    legend(leg.pos,inset=c(1,0.5),xpd=TRUE,fill=c(cust.yellow,"white"),border=c("black","white"),
           legend=use.leg2, bty='n',y.intersp=.75)
    legend(leg.pos,inset=c(1,1),xpd=TRUE,fill=c(cust.red,"white"),border=c("black","white"),
           legend=use.leg3, bty='n',y.intersp=.75)
  }
  
  # set boxplot colours
  cust.bpcol<-rgb(0,0,0,alpha=100,maxColorValue=255)
  cust.medcol<-rgb(0, 0, 0, maxColorValue=255)
  col.box<-cust.bpcol
  col.out<-cust.bpcol
  col.wsk<-cust.bpcol
  col.spl<-cust.bpcol
  col.med<-cust.medcol
  
  # draw boxplot
  boxplot(list(use.df1,use.df2),horizontal=TRUE,las=1,
          medcol=col.med,medlwd=3,boxwex=0.5,boxlty="blank",boxfill=col.box,whisklty="solid",whiskcol=col.wsk,
          whisklwd=2,staplecol=col.spl,staplelwd=2,outcol=col.out,outcex=.75,outpch=19,
          #names=c(paste(use.cuname," LUs\n (n=",n.df1,")",sep=""),paste("All ", use.compUnit, " LUs\n(n=",n.df2,")",sep="")),
          names=c(paste(use.cuname," LUs\n (n=",n.df1,")",sep=""),paste(use.compUnit, " LUs\n(n=",n.df2,")",sep="")),
          #For long CU names, use this:
          #names=c(paste("\n",use.cuname,"\nspawning watersheds\n(n=",n.df1,")",sep=""),paste("All Skeena watersheds\n(n=",n.df2,")",sep="")),cex.axis=.9,
          xlab=use.xlab,add=TRUE,ljoin=1)
  
  dev.off()
  
}

