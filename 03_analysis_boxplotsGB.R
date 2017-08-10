# ------------------------------------------------------------------------------
# BOXPLOTS For one RU at a time
#
# # Adapted from version 6.5
# ------------------------------------------------------------------------------
Boxplots <- function(Prov, AOI.name, GBPU.name, GBPU.abbrev, dir.figs, dir.data) {
source("03_analysis_BoxGB.r") 
outdir<- dir.figs

  #unit that is being evalauted - GBPU
	dataGBPU<-read.csv(paste(dir.data, GBPU.name, ".csv",sep=""), header=T)
  
	#compare individual GBPUs to either entire province or to TSA only
	if(Prov==1){
	  dataBC<- (read.csv(paste(dir.data,"AOIContext_LUs.csv",sep=""),header=T))
	  compUnit<-"BC"
	} else {
	  dataBC<- (read.csv(paste(dir.data, "AOIContext_LUs.csv",sep=""), header=T))
	  #compUnit<-paste(AOI.name,"'s intersecting GBPU's", sep="")
	  compUnit<-paste("All GBPU's", sep="")
	}
  
    # 1) ROAD density
  
	thresh<-c(.6,1.2) #passing in the thresholds for the indicator
	Box.2(dataframe1=dataGBPU, dataframe2=dataBC, 
	      use.field="OpenRoadUtil_KM_x_KM2_noWaterIceRock",
	      use.xlab=expression("Road density ("*km/km^2*")"),
	      use.units=quote(km/km^2), 
	      use.t=thresh, 
	      use.filename=paste(outdir,GBPU.abbrev,"_","RoadDensity",".png",sep=""), 
	      use.cuname=GBPU.name,
	      use.compUnit=compUnit) 
	
    # 2) Core Security
	
    thresh<-c(40,60)
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="NonCore",
          use.xlab=expression("UnSecure Core Habitat (%)"),
          use.units="%",
          use.t=thresh,
          use.filename=paste(outdir,GBPU.abbrev,"_","Core",".png",sep=""), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
    # 3) Front Country
    thresh<-c(20,40)
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="Front_Country_PCNT",
          use.xlab=expression("Front Country (%)"),
          use.t=thresh,
          use.units="%",
          use.filename=paste(outdir,GBPU.abbrev,"_","Front_Country",".png",sep=""), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
    # 4) Hunter Density
    thresh<-c(.6,1.5)
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="LU_hunterDays_annual_per_km2",
          use.xlab=expression("Hunter Density ("*no./km^2*")"),
          use.t=thresh,
          use.units=quote(days/km^2),
          use.filename=paste(outdir,GBPU.abbrev,"_","Hunter_Days",".png",sep=""), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
    # 5) Mid Seral
    thresh<-c(20,30)		#still need real values
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="BEC_High_mSeral_PCNT",
          use.xlab=expression("Mid Seral Conifer (%)"),
          use.t=thresh,
          use.units="%",
          use.filename=paste(outdir,GBPU.abbrev,"_","Mid_Seral",".png",sep=""), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
}