#' @name visualizeDESP
#' @title Visualize DESP demixing of a given feature
#'
#' @description Create plot visualizing *DESP*'s predicted cell state
#' contributions to bulk measurements for a given feature (e.g. gene/protein).
#'
#' Blocks on the left side of the plot correspond to input bulk measurements
#'  of given feature, while blocks on the right correspond to the predicted
#'  cell state levels. Thickness of lines connecting blocks correspond to
#'  relative contribution of cell state (right) to bulk sample (left), with
#'  labels for contributions greater than 15%.
#'
#'  Note: This function requires the output of the \code{DESP()} function.
#'  Make sure to run *DESP* on your data first!
#'
#' @param bulk Bulk omics measurements. Feature-by-sample numeric matrix.
#'  Features can correspond to genes (e.g. RNA-Seq data) or proteins (e.g.
#'  proteomics data). Note: *DESP* does not perform any pre-processing of the
#'  data.
#' @param prediction *DESP*-predicted cell state profiles. Feature-by-cell
#'  state numeric matrix containing the *DESP*-predicted feature levels for
#'  each of the pre-defined cell states.
#' @param proportions Cell state proportion matrix. Sample-by-cell state
#'  numeric matrix indicating either the number of cells or relative proportion
#'  of each cell state in each sample. These cell state proportions can be
#'  derived from techniques such as scRNA-Seq or FACS.
#' @param feature Feature to visualize the associated *DESP* demixing.
#'  Feature must be present in both input matrices
#'  (\code{bulk} & \code{prediction}).
#' @param highlightSample (Optional) Sample to highlight in plot.
#' Must correspond to one of the column names in \code{bulk} input matrix.
#'
#' @return Plot visualizing *DESP*'s predicted cell state
#' contributions to bulk measurements for a given feature (e.g. gene/protein).
#' Plot is created using the ggplot2, ggsankey, and ggalluvial packages.
#'
#' @examples
#' #read in example bulk omics data
#' bulk <- read.csv("data/bulk_EMT_proteome.csv", row.names = 1)
#'
#' #read in example cell state proportions
#' proportions <- as.matrix(read.csv("data/EMT_proportions.csv", row.names = 1))
#'
#' #DESP demixing to predict cell state profiles
#' prediction <- DESP(bulk, proportions)
#'
#' #visualize results for example protein 'AAK1'
#' visualizeDESP(bulk, prediction, proportions, feature = "AAK1")
#'
#' @import magrittr dplyr ggplot2 ggalluvial ggsankey RColorBrewer
NULL
#' @export
visualizeDESP <- function(bulk, prediction, proportions,
                          feature, highlightSample = NULL){
  #dataframe with links between bulk samples and cell states
  links <- expand.grid(colnames(bulk), colnames(prediction),
                       stringsAsFactors = FALSE) %>%
    set_colnames(c("Sample", "Cell State"))

  #find contribution of each state to each sample's expression
  links$Contribution <- apply(links, 1, function(curPair){
    sample <- curPair[["Sample"]]
    population <- curPair[["Cell State"]]
    return(proportions[sample, population] * prediction[feature, population])
  })

  #convert cell state contributions to percentages
  links <- links %>%
    dplyr::group_by(Sample) %>%
    dplyr::mutate(Percentage = Contribution / sum(Contribution)) %>%
    #add bulk abundance
    dplyr::mutate(Bulk = bulk[feature, Sample])

  #color palette to use
  palette_info <- RColorBrewer::brewer.pal.info[
    brewer.pal.info$category == "qual", ]
  palette_all <- unlist(mapply(brewer.pal,
                               palette_info$maxcolors,
                               rownames(palette_info)))

  #highlight contributions for selected sample
  alphaValues <- rep(0.3, nrow(links))
  if(!is.null(highlightSample))
    alphaValues[which(links$Sample == highlightSample,)] <- 0.5

  #alluvial plot
  ggplot2::ggplot(links, aes(y = Contribution, axis1 = Sample, axis2 = `Cell State`)) +
    ggalluvial::geom_alluvium(aes(fill = Sample, alpha = alphaValues), knot.pos = 0.3) +
    ggalluvial::geom_stratum(width = 1/12, aes(fill = after_stat(stratum)),
                 color = "grey", alpha = 0.9) +
    geom_text(aes(label = ifelse(Percentage >= 0.15,
                                 paste0(round(Percentage, 2)*100,"%"), "")),
              stat = "flow", size = 2, alpha = 0.5, nudge_x = -0.07) +
    geom_label(stat = "stratum", aes(label = after_stat(stratum)), size = 4) +
    scale_x_discrete(limits = c("Sample", "Cell State"), expand = c(0, 0.1)) +
    scale_alpha(range = c(0.2, 0.9)) +
    scale_fill_manual(values = palette_all) +
    ggsankey::theme_sankey(base_size = 15) +
    theme(legend.position = "none") +
    ggtitle(paste("DESP demixing of", feature))
}
