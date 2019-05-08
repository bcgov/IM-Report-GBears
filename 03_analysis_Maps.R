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

#Maps Provincial LU indicators for AOI
#By Don Morgan, MoE

source("header.R")

GBPU_LU_Context.spatial$rdDens_map<-factor(GBPU_LU_Context.spatial$rdDens_Class)
mapRange1 <- c(range(st_coordinates(GBPU.AOI.spatial)[,1]),range(st_coordinates(GBPU.AOI.spatial)[,2]))

plot_title<-"Grizzly Bear - Road Density"
plot_legend<-"Road Density Class"
# because multiple data types of attribures in GBPU_LU_Context requires direct call from geom_sf insted of ggplot(data)
pdf(file=file.path(figsOutDir,paste("RdDens",AOI,".pdf",sep='')))
ggplot(GBPU_LU_Context.spatial) +
  geom_sf(data = GBPU_LU_Context.spatial, aes(fill = rdDens_map)) +
  #scale_fill_brewer(type='qual',palette="RdYlGn") +
  scale_fill_brewer(palette="RdYlGn", direction =-1) +
  labs(fill = plot_legend) +
  #theme(legend.title = element_blank()) +
  #theme(legend.title = element_text(plot_title)) +
  #library(viridis)
  #viridis::scale_fill_viridis(discrete = TRUE,option='viridis') +
  #geom_sf_label(data = GBPU_LU_Context, aes(label = plot_title)) +
  geom_sf(data = GBPU.spatial, col = "black", alpha = 0, size = 0.5)+
  geom_sf(data = AOI.spatial, col = "blue", alpha = 0, size = 0.75) +
  #geom_sf_label(data = GBPUs.used, label.size = 0.1, aes(label = POPULATION_NAME)) +
  coord_sf(xlim = mapRange1[c(1:2)], ylim = mapRange1[c(3:4)]) +
  ggtitle(plot_title) +
  annotation_scale(location = "br", width_hint = 0.5) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering)

dev.off()

GBPU_LU_Context.spatial$BEC_midSeral_Conifer_gt30_Flag_map<-factor(GBPU_LU_Context.spatial$BEC_midSeral_Conifer_gt30_Flag)
plot_title<-"Grizzly Bear - Mid Seral"
plot_legend<-"Mid Seral Class"
pdf(file=file.path(figsOutDir,paste("MidSeral_",AOI,".pdf",sep='')))
# because multiple data types of attribures in GBPU_LU_Context requires direct call from geom_sf insted of ggplot(data)
ggplot(GBPU_LU_Context.spatial) +
  geom_sf(data = GBPU_LU_Context.spatial, aes(fill = BEC_midSeral_Conifer_gt30_Flag_map)) +
  #scale_fill_brewer(type='qual',palette="RdYlGn") +
  scale_fill_brewer(palette="RdYlGn", direction =-1) +
  labs(fill = plot_legend) +
  #theme(legend.title = element_blank()) +
  #theme(legend.title = element_text(plot_title)) +
  #library(viridis)
  #viridis::scale_fill_viridis(discrete = TRUE,option='viridis') +
  #geom_sf_label(data = GBPU_LU_Context, aes(label = plot_title)) +
  geom_sf(data = GBPU.spatial, col = "black", alpha = 0, size = 0.5)+
  geom_sf(data = AOI.spatial, col = "blue", alpha = 0, size = 0.75) +
  #geom_sf_label(data = GBPUs.used, label.size = 0.1, aes(label = POPULATION_NAME)) +
  coord_sf(xlim = mapRange1[c(1:2)], ylim = mapRange1[c(3:4)]) +
  ggtitle(plot_title) +
  annotation_scale(location = "br", width_hint = 0.5) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering)
dev.off()


GBPU_LU_Context.spatial$LU_Secure_Core_BEI_Cap_PCNT_Class_map<-factor(GBPU_LU_Context.spatial$LU_Secure_Core_BEI_Cap_PCNT_Class)
plot_title<-"Grizzly Bears - Proportion of Capable Secure"
plot_legend<-"Capable Secure Class"
pdf(file=file.path(figsOutDir,paste("CoreSecure_",AOI,".pdf",sep='')))
# because multiple data types of attribures in GBPU_LU_Context requires direct call from geom_sf insted of ggplot(data)
ggplot(GBPU_LU_Context.spatial) +
  geom_sf(data = GBPU_LU_Context.spatial, aes(fill = LU_Secure_Core_BEI_Cap_PCNT_Class_map)) +
  #scale_fill_brewer(type='qual',palette="RdYlGn") +
  scale_fill_brewer(palette="RdYlGn", direction =-1) +
  labs(fill = plot_legend) +
  #theme(legend.title = element_blank()) +
  #theme(legend.title = element_text(plot_title)) +
  #library(viridis)
  #viridis::scale_fill_viridis(discrete = TRUE,option='viridis') +
  #geom_sf_label(data = GBPU_LU_Context, aes(label = plot_title)) +
  geom_sf(data = GBPU.spatial, col = "black", alpha = 0, size = 0.5)+
  geom_sf(data = AOI.spatial, col = "blue", alpha = 0, size = 0.75) +
  #geom_sf_label(data = GBPUs.used, label.size = 0.1, aes(label = POPULATION_NAME)) +
  coord_sf(xlim = mapRange1[c(1:2)], ylim = mapRange1[c(3:4)]) +
  ggtitle(plot_title) +
  annotation_scale(location = "br", width_hint = 0.5) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering)
dev.off()

