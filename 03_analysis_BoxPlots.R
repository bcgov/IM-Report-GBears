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

#Summarizes Provincial LU indicators by AOI and by GBPU
#By Don Morgan, MoE

#############
# Based on aquatics summary R script generate box plots for gbears
#############

dir.data <- dataOutDir
dir.figs<- figsOutDir
#fileoutdir<- "/Users/Morgan/Dropbox/Values/GBearsProv/GBAtlas/TSA/PGTSA/" #output files
#dir.map <- paste("/Users/Morgan/Dropbox/Values/GBearsProv/GBAtlas/GISData/",sep="")

#read in functions first
#source("Functions.r")#for inserting maps - not currently used

#source files for each panel
source("03_analysis_boxplotsGB.r")

#source("histogram.r")
#source("Page1.r")
#source("Page2.r")
#source("Page3.r")
#source("Page4.r")
#source("ApdxMaps.r")
#source("Apdx.r")

Value.name<-"Grizzly Bears"
headcolor <- "lightskyblue2"
AOI.name <- AOI
Prov <- 0 #will compare against GBPUs that provide context for AOI.

#Put or read in full list here
nameGBPU <- read.csv(paste(dir.data,"GBPU_GB.csv",sep=''),header=T)

#Do a loop for each GBPU in the unit and one for the entire TSA

#i<-1
#i in 1:nrow(nameRU)
for (i in 1:nrow(nameGBPU)) {
  GBPU.name <- nameGBPU$GBPU_NAME[i]
  GBPU.abbrev <- nameGBPU$GBPU_CODE[i]
  
  #Histogram(RU.abbrev, dir.figs, dir.data)
  Boxplots(Prov, AOI, GBPU.name, GBPU.name, dir.figs, dir.data)
  
}


