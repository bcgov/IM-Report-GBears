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

#GB_AOI_MapsGBPU_Rank - Don Morgan, MoE
#Script creates a map of NatureServe rank

#M1 M1M2 M2  orange        high management concern
#M3         yellow        moderate management concern
#M3M4 M4     light green   low m'anagement concern
#M45M M5     dark green    very low management concern

#pull the AOI GBPUs for mapping
GBPUM<-merge(GBPU.spatial,GBRe_Rank,by.x='POPULATION_NAME',by.y='GBPU_Name')
subGBPU <- subset (GBPUM,POPULATION_NAME %in% GBPU.context )
#use all the GBPUs for the coloured map
subGBPU <-GBPUM

#factor the mapped attribute 'RankCode'
subGBPU$RankCode_map<-factor(subGBPU$RankCode)
#set map extent to GBPU.AOI, otherwise maps entire province
mapRange1 <- c(range(st_coordinates(GBPU.AOI.spatial)[,1]),range(st_coordinates(GBPU.AOI.spatial)[,2]))

plot_title<-"Grizzly Bear - Management Rank"
plot_legend<-'Management Rank'
#write out map to figure directory
pdf(file=file.path(figsOutDir,paste("GBPU_",AOI,".pdf",sep='')))
ggplot(subGBPU) +
  geom_sf(data = subGBPU, aes(fill = RankCode_map)) +
  scale_fill_brewer(palette="RdYlGn", direction =1) +
  labs(fill = plot_legend) +
  geom_sf(data = subGBPU1, col = "red", alpha = 0, size = 0.5)+
  geom_sf(data = AOI.spatial, col = "blue", alpha = 0, size = 0.75) +
  geom_sf_label(data = subGBPU1, label.size = 0.1, 
                aes(label = POPULATION_NAME)) +
  #geom_sf_text(aes(label = POPULATION_NAME), colour = "black") +
  coord_sf(xlim = mapRange1[c(1:2)], ylim = mapRange1[c(3:4)]) +
  ggtitle(plot_title) +
  annotation_scale(location = "br", width_hint = 0.5) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering)
dev.off()

