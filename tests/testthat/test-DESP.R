#read in example bulk omics data
bulk <- read.csv("./data/bulk_EMT_proteome.csv", row.names = 1)

#read in example cell state proportions
proportions <- as.matrix(read.csv("./data/EMT_proportions.csv",
                                  row.names = 1))

#read in example cell state similarities
M <- as.matrix(read.csv("./data/EMT_cell_state_similarities.csv",
                        row.names = 1))

#DESP demixing to predict cell state profiles
prediction <- DESP(bulk, proportions)

test_that("DESP produces matrix with correct dimensions", {
  #does it return correct dimensions?
  expect_equal(nrow(prediction), nrow(bulk))
  expect_equal(ncol(prediction), ncol(proportions))
})

test_that("Cell state similarity regularization functional", {
  #DESP demixing to predict cell state profiles
  prediction <- DESP(bulk, proportions, similarities = M)

  #does it return correct dimensions?
  expect_equal(nrow(prediction), nrow(bulk))
  expect_equal(ncol(prediction), ncol(proportions))
})
