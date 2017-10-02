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

#Clean up LU data for analysis and write out AOI and AOI_GBPU_context data sets for analysis

#Select LUs that are in the context GBPUs
MapGBPU<-subset(ProvLUs, MAX_GBPU_P %in% GBPU.context)
AOI_GBPUContext <- gUnaryUnion(MapGBPU, id = NULL)

#Select the LUs that are in the AOI
df<-data.frame(over(AOIShp,ProvLUs,returnList=TRUE)[1])
LU1<-unique(df$LANDSCAPE_)
AOI_LU<-subset(ProvLUs, LANDSCAPE_ %in% LU1)

#Subset out only those LUs with >overlap% of their area in AOI
AOIOver<-raster::union(ProvLUs,AOIShp)
#subset out the LU fragements that intersect the AOI
AOILU1<-subset(AOIOver, LANDSCAPE_ %in% LU1)
#Calculate area of each resultant
AOILU1@data$InArea<-(gArea(AOILU1, byid = TRUE))
#identify those LUs that have at least x overlap with AOI
AOILU2<-subset(AOILU1, (InArea > (Overlap*(Shape_Area)) & !is.na(AOILU1@data[,AOI.id])))

LU<-unique(AOILU2@data$LANDSCAPE_)
AOILU3<-subset(AOI_LU, LANDSCAPE_ %in% LU)
#length(AOILU3@data$LANDSCAPE_)

#Write out LUs for AOI
write.table(data.frame(LU), file = paste(dataOutDir, "AOI_LU_Names.csv",sep=""),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")

#Check results
pdf(file=paste(dataOutDir,"LUSelect_",AOI,".pdf",sep=""))
plot(MapGBPU)
lines(AOI_LU, col='blue')
lines(AOILU3, col='green')
lines(AOIShp,col='yellow',lwd=2.5)
lines(AOI_GBPUContext, col='red')
dev.off()

#Make a csv for all unique names of GBPUs in AOI + row for AOI
GBPUsOnly<-unique(data.frame(LU_Summ_in$MAX_GRIZZLY_BEAR_POP_UNIT_ID, LU_Summ_in$MAX_GBPU_POPULATION_NAME))
colnames(GBPUsOnly)<-c("GBPU_CODE", "GBPU_NAME")
GBPUsOut<-subset(GBPUsOnly,GBPU_NAME %in% GBPU.context)
colnames(GBPUsOut)<-c("GBPU_CODE", "GBPU_NAME")
AOIRow<-data.frame(GBPU_CODE=AOI.Name,GBPU_NAME=AOI)
GBPUs<-rbind(GBPUsOut,AOIRow)

#Use only AOI
GBPUs<-GBPUs[nrow(GBPUs),]

write.table((GBPUs), file = paste(dataOutDir ,"GBPU_GB.csv",sep=""), append=FALSE, quote = FALSE, row.names = FALSE, col.names = TRUE, sep=",")#sep="\t")

#####
#calc some new variables so consistent Pass/Fail 
LU_Summ_in$AOIOnly<-ifelse(LU_Summ_in$LANDSCAPE_UNIT_PROVID %in% LU, 1,0)
LU_Summ_in$Mort_Flag<-ifelse((LU_Summ_in$Pop_Mort_Flag_Hunt== 'Fail' | LU_Summ_in$Pop_Mort_Flag_NoHunt== 'Fail'), 'Fail', 'Pass')
LU_Summ_in$rdDens_Flag<-ifelse(LU_Summ_in$rdDens_Flag_ge_pt6=='Yes', 'Fail','Pass')
LU_Summ_in$Core_Flag<-ifelse(LU_Summ_in$LU_Secure_Core_PCNT <60, 'Fail', 'Pass')
LU_Summ_in$NonCore<-100-LU_Summ_in$LU_Secure_Core_PCNT
LU_Summ_in$Protected_Flag<-ifelse(LU_Summ_in$Protected_PCNT <30, 'Fail', 'Pass')
LU_Summ_in$Q_Food<-ifelse(LU_Summ_in$Quality_Food_Flag=='Yes', 'Pass','Fail')
LU_Summ_in$WHA_Flag<-ifelse(LU_Summ_in$WHA_EBM_Flag=='Yes', 'Pass','Fail')

#Subset out those LUs to be considered part of AOI
AOI_LU<-(subset(LU_Summ_in, LANDSCAPE_UNIT_PROVID %in% LU))
write.table(AOI_LU, file = paste(dataOutDir, "AOI_LUs.csv",sep=""),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")

GBPU_LU_Context<-subset(LU_Summ_in, MAX_GBPU_POPULATION_NAME %in% GBPU.context)
#Subset all LUs in GBPU context area
write.table(GBPU_LU_Context, file = paste(dataOutDir, "AOIContext_LUs.csv",sep=""),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")

#####
#Loop through GBPUs, AOI and indicators and output analysis ready data sets
gbpu<-1
num<-length(GBPU.context)+1
for (gbpu in 1:num) {
  #subset the GBPU
  GBSubset <- AOI
  
  GBPU1 <-if(gbpu<num) {
    GBSubset <- GBPU.context[gbpu] 
    subset(GBPU_LU_Context,MAX_GBPU_POPULATION_NAME == GBSubset)
  } else 
    #GBPU1 <-TSA_RU
    #GBPU1 <-GBPU_RU
    GBPU1 <- AOI_LU
  #nrow(GBPU1)
  
  #subset the TSA portion of the GBPU
  AOI_GBPU1<-subset(GBPU_LU_Context,MAX_GBPU_POPULATION_NAME== GBSubset & AOIOnly==1)
  #noTSALU<-nrow(TSA_GBPU1)
  #compare the number of LUs in each
  #nrow(GBPU1)
  #nrow(TSA_GBPU1)
  
  #Calc the area of the GBPU - may change to area that is not rock/ice
  GBPUArea<-GBPUArea<-sum(GBPU1$Shape_Area)/10000
  #Calc the area of the AOI portion of the GBPU
  AOIOnly<-subset(GBPU1, AOIOnly==1 )
  AOIArea<-sum(AOIOnly$Shape_Area)/10000
  #Calc %of GBPU that is TSA
  pcAOIofGBPU<-AOIArea/GBPUArea*100
  
  #loop through each of the flags
  Flagno<-1
  for (Flagno in 1:num_indicators){
    
    FlagInd<-paste('GBPU1$',Indicators[Flagno],sep='')
    #round(sum(GBPU1$Mort_Flag=='Fail')/noLU*100)c
    noGBPULU<-nrow(GBPU1)
    IndicatorList[Flagno]<-round(sum(eval(parse(text = FlagInd))=='Fail')/noGBPULU*100)
    
    #do another items for AOI portion
    FlagInd<-paste('AOI_GBPU1$',Indicators[Flagno],sep='')
    noAOILU<-nrow(AOI_GBPU1)
    AOIIndicatorList[Flagno]<-round(sum(eval(parse(text = FlagInd))=='Fail')/noAOILU*100)
    
  }
  
  #Create new data frame containing the summary numbers for AOI portion and GBPU
  GBPU2<-data.frame(GBSubset,round(GBPUArea),round(AOIArea),round(pcAOIofGBPU),IndicatorList[1],AOIIndicatorList[1], IndicatorList[2],AOIIndicatorList[2],IndicatorList[3],AOIIndicatorList[3],IndicatorList[4],AOIIndicatorList[4],IndicatorList[5],AOIIndicatorList[5],IndicatorList[6],AOIIndicatorList[6],IndicatorList[7],AOIIndicatorList[7],IndicatorList[8],AOIIndicatorList[8],IndicatorList[9],AOIIndicatorList[9])
  colnames(GBPU2)<-c('GBPU','GBPUArea','TSAArea','pcTSAofGBPU','Mortality','TSAMortality','RoadDensity','TSARoadDensity','CoreSercurityAreas','TSACoreSercurityAreas','FrontCountry','TSAFrontCountry','HunterDensity','TSAHunterDensity','QaulityFood','TSAQaulityFood','MidSeral','TSAMidSeral','HabitatProtection','TSAHabitatProtection','WHA','TSAWHA')
  
  #Create new data frame containing the summary numbers for GBPUs only
  GBPU3<-data.frame(GBSubset,round(GBPUArea),IndicatorList[1], IndicatorList[2],IndicatorList[3],IndicatorList[4],IndicatorList[5],IndicatorList[6],IndicatorList[7],IndicatorList[8],IndicatorList[9])
  colnames(GBPU3)<-c('GBPU','GBPUArea','Mortality','RoadDensity','CoreSercurityAreas','FrontCountry','HunterDensity','QaulityFood','MidSeral','HabitatProtection','WHA')
  
  ifelse(gbpu == 1, appendcolvar<-FALSE, appendcolvar<-TRUE)
  write.table((GBPU3), file = paste(dataOutDir ,"GBPUOut.csv",sep=""),append = appendcolvar, quote = FALSE, row.names = FALSE, col.names = !appendcolvar, sep=",")#sep="\t") ifelse(gbpu == 1, appendcolvar<-FALSE, appendcolvar<-TRUE)
  
  ifelse(gbpu == 1, appendcolvar<-FALSE, appendcolvar<-TRUE)
  write.table((GBPU2), file = paste(dataOutDir ,"GBPUTSAOut.csv",sep=""),append = appendcolvar, quote = FALSE, row.names = FALSE, col.names = !appendcolvar, sep=",")#sep="\t")
  
  #Create a data frame for each data set (GBPU) and write out individually
  write.table((GBPU1), file = paste(dataOutDir, GBSubset, ".csv",sep=""),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")
  
}  

