## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  message = FALSE,
  warning = FALSE,
  comment = "#>"
)

## ----installPackage-----------------------------------------------------------
#install DESP package from GitHub
library(devtools)
devtools::install_github("AhmedYoussef95/DESP")

#load package
library(DESP)

## ----bulkData-----------------------------------------------------------------
#read in bulk omics data included with package
data(bulk_EMT_proteome)

#check first few rows of data
head(bulk_EMT_proteome)

## ----cellTypeCompositions-----------------------------------------------------
#read in cell state proportions included with package
data(EMT_proportions)

#examine data
EMT_proportions

## ----cellStateSimilarities----------------------------------------------------
#read in cell state similarities included with package
data(EMT_cell_state_similarities)

#examine data
EMT_cell_state_similarities

## ----runDESP------------------------------------------------------------------
#DESP demixing to predict cell state profiles
prediction <- DESP(bulk = bulk_EMT_proteome,
                   proportions = EMT_proportions,
                   similarities = EMT_cell_state_similarities)

#examine first few rows of prediction
head(prediction)

## ----visualize, fig.width=8, fig.height = 6-----------------------------------
#visualize results for example protein 'AAK1'
visualizeDESP(bulk = bulk_EMT_proteome,
              prediction = prediction,
              proportions = EMT_proportions,
              feature = "AAK1")

