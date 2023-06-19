#' @name DESP
#' @title DESP: Demixing Cell State Profiles from Dynamic Bulk Molecular
#'  Measurements
#'
#' @description Predict cell state *'omics* profiles given dynamic bulk
#' *'omics* measurements and corresponding cell state proportions across
#'  samples.
#'
#' @param bulk Bulk omics measurements. Feature-by-sample numeric matrix.
#'  Features can correspond to genes (e.g. RNA-Seq data) or proteins (e.g.
#'  proteomics data). Note: *DESP* does not perform any pre-processing of the
#'  data.
#' @param proportions Cell state proportion matrix. Sample-by-cell state
#'  numeric matrix indicating either the number of cells or relative proportion
#'  of each cell state in each sample. These cell state proportions can be
#'  derived from techniques such as scRNA-Seq or FACS.
#' @param lambda Ridge regression normalization parameter.
#'  Default value is \code{1e-7} and should be suitable for most applications.
#' @param beta Cell state similarity normalization parameter.
#'  Default value is \code{1e-4} and should be suitable for most applications.
#' @param M (Optional) Cell state similarity matrix. State-by-state numeric
#'  matrix containing the similarity of the cell states to each other. Any
#'  similarity metric can be used (e.g. Pearson correlation) as long as the
#'  larger values indicate higher similarity (e.g. distances should be
#'  converted to similarities). An example is the correlation of per-state
#'  averaged scRNA-Seq gene expression values.
#' @return *DESP*-predicted cell state profiles. Feature-by-cell state
#'  numeric matrix containing the predicted feature levels for each of the
#'  pre-defined cell states, effectively demixing the measured bulk 'omics
#'  matrix into the underlying cell state 'omics profiles.
#'
#' @examples
#' desp <- DESP(bulk, proportions)
#'
#' @import quadprog
NULL
#' @export
DESP <- function(bulk, proportions, lambda = 1e-7, beta = 1e-4, M = NULL){
  #construct sample-by-feature bulk matrix
  bulk <- t(bulk)

  #define required matrices/vectors for the quadratic solver
  Dmat <- t(proportions) %*% proportions
  Amat <- diag(ncol(proportions))

  #add regularization parameters
  if (!is.null(M))
    Dmat <- Dmat + (lambda * diag(nrow(Dmat))) + (beta * solve(M))
  else
    Dmat <- Dmat + (lambda * diag(nrow(Dmat)))

  #to avoid overflow cause by large values, scale Dmat and dvec
  scalingFactor <- norm(Dmat, "2")

  #apply DESP for each feature
  prediction <- t(apply(bulk, 2, function(curFeature){
    #define required vector for the quadratic solver
    dvec <- t(proportions) %*% curFeature

    #solve quadratic equation
    predictedMeasurements <- quadprog::solve.QP(Dmat = Dmat / scalingFactor,
                                                dvec = dvec / scalingFactor,
                                                Amat = Amat)

    #return feature's predicted cell state-level profiles
    return(predictedMeasurements$solution)
  }))

  #set column names to input cell state names
  colnames(prediction) <- colnames(proportions)

  #return predicted cell state-level profiles
  return(prediction)
}
