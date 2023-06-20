#read in example bulk omics data
bulk <- read.csv("./data/bulk_EMT_proteome.csv", row.names = 1)

#read in example cell state proportions
proportions <- as.matrix(read.csv("./data/EMT_proportions.csv",
                                  row.names = 1))

#DESP demixing to predict cell state profiles
prediction <- DESP(bulk, proportions)

test_that("Base visualization works", {
  #visualize results for example protein 'AAK1'
  p <- visualizeDESP(bulk, prediction, proportions, feature = "AAK1")

  #does it return ggplot2 object?
  expect_s3_class(p, "ggplot")
})

test_that("Highlighting sample in visualization works", {
  #visualize results for example protein 'AAK1'
  p <- visualizeDESP(bulk, prediction, proportions,
                     feature = "AAK1", highlightSample = "T8")

  #does it return ggplot2 object?
  expect_s3_class(p, "ggplot")
})
