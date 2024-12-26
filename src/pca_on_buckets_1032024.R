library(readxl)
library(kohonen)
library(fields)
library (dplyr)
library(ggfortify)
##set directory to where our data is 
setwd("C:/SOM_Nebraska/Final_Char_10032024/")
df=read_excel("merged_df_final.xlsx")
##############################################################################
##############################1st Bucket (SF, FF, ER)
###############################################################################
df_buck_1=df %>% select(SF, FF, ER)
set.seed(123)
df_buck_1_pca= prcomp(df_buck_1, scale=TRUE)
pca_summary=summary(df_buck_1_pca)
proportion_variance=pca_summary$importance[2,]
rotation= df_buck_1_pca$rotation
############################### the eigenvalues for PC1 and PC2
pc1_loadings = abs(rotation[,1])
pc2_loadings= abs(rotation[,2])
pc1_variance=proportion_variance[1]
pc2_variance=proportion_variance[2]

PC1_load_variance=pc1_loadings*pc1_variance
PC2_load_variance=pc2_loadings*pc2_variance

TOTAL_PC_LOAD_VAR= (PC1_load_variance+PC2_load_variance)/(pc1_variance+pc2_variance)
top_features_pc1 = names(sort(TOTAL_PC_LOAD_VAR,decreasing = TRUE))[1]

bar_plot=barplot(TOTAL_PC_LOAD_VAR, main = " Bar Plot of Wighted Average Loading of Variables",
       ylab= "Wighted Average Loading", col="skyblue",
        las=2, ylim = c(0,max(TOTAL_PC_LOAD_VAR)+0.1))
text(x=bar_plot,
     y=TOTAL_PC_LOAD_VAR,
     label=format(round(TOTAL_PC_LOAD_VAR,4),nsmall = 4),
     pos=3,
     cex=0.8,
     col="black")

###########################################################################
########## Top feature for bucket 1 is : "FF"
###########################################################################

##############################################################################
##############################2ND Bucket (CR,CC,II)
###############################################################################
df_buck_1=df %>% select(CR,CC,II)
set.seed(123)
df_buck_1_pca= prcomp(df_buck_1, scale=TRUE)
pca_summary=summary(df_buck_1_pca)
proportion_variance=pca_summary$importance[2,]
rotation= df_buck_1_pca$rotation
############################### the eigenvalues for PC1 and PC2
pc1_loadings = abs(rotation[,1])
pc2_loadings= abs(rotation[,2])
pc1_variance=proportion_variance[1]
pc2_variance=proportion_variance[2]

PC1_load_variance=pc1_loadings*pc1_variance
PC2_load_variance=pc2_loadings*pc2_variance

TOTAL_PC_LOAD_VAR= (PC1_load_variance+PC2_load_variance)/(pc1_variance+pc2_variance)
top_features_pc1 = names(sort(TOTAL_PC_LOAD_VAR,decreasing = TRUE))[1]

bar_plot=barplot(TOTAL_PC_LOAD_VAR, main = " Bar Plot of Wighted Average Loading of Variables",
                 ylab= "Wighted Average Loading", col="skyblue",
                 las=2, ylim = c(0,max(TOTAL_PC_LOAD_VAR)+0.1))
text(x=bar_plot,
     y=TOTAL_PC_LOAD_VAR,
     label=format(round(TOTAL_PC_LOAD_VAR,4),nsmall = 4),
     pos=3,
     cex=0.8,
     col="black")

###########################################################################
########## Top feature for bucket 2 is : "11"
###########################################################################

##############################################################################
##############################3RD Bucket (TSS_FtpMi,MCS_FtpMi)
###############################################################################
df_buck_1=df %>% select(TSS_FtpMi,MCS_FtpMi)
set.seed(123)
df_buck_1_pca= prcomp(df_buck_1, scale=TRUE)
pca_summary=summary(df_buck_1_pca)
proportion_variance=pca_summary$importance[2,]
rotation= df_buck_1_pca$rotation
############################### the eigenvalues for PC1 and PC2
pc1_loadings = abs(rotation[,1])
pc2_loadings= abs(rotation[,2])
pc1_variance=proportion_variance[1]
pc2_variance=proportion_variance[2]

PC1_load_variance=pc1_loadings*pc1_variance
PC2_load_variance=pc2_loadings*pc2_variance

TOTAL_PC_LOAD_VAR= (PC1_load_variance+PC2_load_variance)/(pc1_variance+pc2_variance)
top_features_pc1 = names(sort(TOTAL_PC_LOAD_VAR,decreasing = TRUE))[1]

bar_plot=barplot(TOTAL_PC_LOAD_VAR, main = " Bar Plot of Wighted Average Loading of Variables",
                 ylab= "Wighted Average Loading", col="skyblue",
                 las=2, ylim = c(0,max(TOTAL_PC_LOAD_VAR)+0.1))
text(x=bar_plot,
     y=TOTAL_PC_LOAD_VAR,
     label=format(round(TOTAL_PC_LOAD_VAR,4),nsmall = 4),
     pos=3,
     cex=0.8,
     col="black")

###########################################################################
########## Top feature for bucket 3 is : "MCS_FtpMi"
###########################################################################

##############################################################################
##############################4TH Bucket (MeanBE_Ft, PRISM_01_mm, PRISM_02_mm,PRISM_03_mm,PRISM_04_mm,PRISM_05_mm,PRISM_06_mm,PRISM_07_mm,PRISM_08_mm,PRISM_09_mm,PRISM_10_mm,PRISM_11_mm,PRISM_12_mm,PRISM_yr_mm )
###############################################################################
df_buck_1=df %>% select(MeanBE_Ft, PRISM_01_m, PRISM_02_m,
                        PRISM_03_m,PRISM_04_m,PRISM_05_m,
                        PRISM_06_m,PRISM_07_m,PRISM_08_m,
                        PRISM_09_m,PRISM_10_m,PRISM_11_m,
                        PRISM_12_m,PRISM_yr_m )
set.seed(123)
df_buck_1_pca= prcomp(df_buck_1, scale=TRUE)
pca_summary=summary(df_buck_1_pca)
proportion_variance=pca_summary$importance[2,]
rotation= df_buck_1_pca$rotation
############################### the eigenvalues for PC1 and PC2
pc1_loadings = abs(rotation[,1])
pc2_loadings= abs(rotation[,2])
pc1_variance=proportion_variance[1]
pc2_variance=proportion_variance[2]

PC1_load_variance=pc1_loadings*pc1_variance
PC2_load_variance=pc2_loadings*pc2_variance

TOTAL_PC_LOAD_VAR= (PC1_load_variance+PC2_load_variance)/(pc1_variance+pc2_variance)
top_features_pc1 = names(sort(TOTAL_PC_LOAD_VAR,decreasing = TRUE))[1]

bar_plot=barplot(TOTAL_PC_LOAD_VAR, main = " Bar Plot of Wighted Average Loading of Variables",
                 ylab= "Wighted Average Loading", col="skyblue",
                 las=2, ylim = c(0,max(TOTAL_PC_LOAD_VAR)+0.1))
text(x=bar_plot,
     y=TOTAL_PC_LOAD_VAR,
     label=format(round(TOTAL_PC_LOAD_VAR,4),nsmall = 4),
     pos=3,
     cex=0.8,
     col="black")

###########################################################################
########## Top feature for bucket 4 is : "PRISM_yr_m"
###########################################################################

##############################################################################
##############################5TH Bucket (MeanNDVI,MeanEVI )
###############################################################################
df_buck_1=df %>% select(MeanNDVI,MeanEVI )
set.seed(123)
df_buck_1_pca= prcomp(df_buck_1, scale=TRUE)
pca_summary=summary(df_buck_1_pca)
proportion_variance=pca_summary$importance[2,]
rotation= df_buck_1_pca$rotation
############################### the eigenvalues for PC1 and PC2
pc1_loadings = abs(rotation[,1])
pc2_loadings= abs(rotation[,2])
pc1_variance=proportion_variance[1]
pc2_variance=proportion_variance[2]

PC1_load_variance=pc1_loadings*pc1_variance
PC2_load_variance=pc2_loadings*pc2_variance

TOTAL_PC_LOAD_VAR= (PC1_load_variance+PC2_load_variance)/(pc1_variance+pc2_variance)
top_features_pc1 = names(sort(TOTAL_PC_LOAD_VAR,decreasing = TRUE))[1]

bar_plot=barplot(TOTAL_PC_LOAD_VAR, main = " Bar Plot of Wighted Average Loading of Variables",
                 ylab= "Wighted Average Loading", col="skyblue",
                 las=2, ylim = c(0,max(TOTAL_PC_LOAD_VAR)+0.1))
text(x=bar_plot,
     y=TOTAL_PC_LOAD_VAR,
     label=format(round(TOTAL_PC_LOAD_VAR,4),nsmall = 4),
     pos=3,
     cex=0.8,
     col="black")

###########################################################################
########## Top feature for bucket 5 is : "MeanEVI"
###########################################################################

