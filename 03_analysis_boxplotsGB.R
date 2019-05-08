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

# ------------------------------------------------------------------------------
# BOXPLOTS For one GBPU at a time
#
# ------------------------------------------------------------------------------
Boxplots <- function(Prov, AOI.name, GBPU.name, GBPU.abbrev, dir.figs, dir.data) {
source("03_analysis_BoxGB.R") 
outdir<- dir.figs

  #unit that is being evalauted - GBPU
	dataGBPU<-read.csv(file.path(dir.data,paste(GBPU.name, ".csv",sep="")), header=T)
  
	#compare individual GBPUs to either entire province or to TSA only
	if(Prov==1){
	  dataBC<- (read.csv(file.path(dir.data,"AOIContext_LUs.csv"),header=T))
	  compUnit<-"BC"
	} else {
	  dataBC<- (read.csv(file.path(dir.data,"AOIContext_LUs.csv"),header=T))
	  #compUnit<-paste(AOI.name,"'s intersecting GBPU's", sep="")
	  compUnit<-paste("All GBPU's", sep="")
	}
  
#Must have 2 thresholds in thresh c(0.6,1.25), if binary then repeat c(30,30)
    # 1) ROAD density
  
	thresh<-c(.6,0.75) #passing in the thresholds for the indicator
	Box.2(dataframe1=dataGBPU, dataframe2=dataBC, 
	      use.field="OpenRoadUtil_KM_x_KM2_noWaterIceRock",
	      use.xlab=expression("Road density ("*km/km^2*")"),
	      use.units=quote(km/km^2), 
	      use.t=thresh, 
	      use.filename=file.path(outdir,paste(GBPU.abbrev,"_","RoadDensity",".png",sep="")), 
	      use.cuname=GBPU.name,
	      use.compUnit=compUnit) 
	
    # 2) Core Security
	
    thresh<-c(40,60)
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="NonCore",
          use.xlab=expression("UnSecure Core Habitat (%)"),
          use.units="%",
          use.t=thresh,
          use.filename=file.path(outdir,paste(GBPU.abbrev,"_","Core",".png",sep="")), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
    # 3) Front Country
    thresh<-c(20,40)
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="Front_Country_PCNT",
          use.xlab=expression("Front Country (%)"),
          use.t=thresh,
          use.units="%",
          use.filename=file.path(outdir,paste(GBPU.abbrev,"_","Front_Country",".png",sep="")), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
    # 4) Hunter Density
    thresh<-c(.6,1.5)
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="LU_hunterDays_annual_per_km2",
          use.xlab=expression("Hunter Density ("*no./km^2*")"),
          use.t=thresh,
          use.units=quote(days/km^2),
          use.filename=file.path(outdir,paste(GBPU.abbrev,"_","Hunter_Days",".png",sep="")), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
    # 5) Mid Seral
    thresh<-c(30,30)		#still need real values
    Box.2(dataframe1=dataGBPU, dataframe2=dataBC,
          use.field="BEC_High_mSeral_PCNT",
          use.xlab=expression("Mid Seral Conifer (%)"),
          use.t=thresh,
          use.units="%",
          use.filename=file.path(outdir,paste(GBPU.abbrev,"_","Mid_Seral",".png",sep="")), 
          use.cuname=GBPU.name,
          use.compUnit=compUnit)
    
}