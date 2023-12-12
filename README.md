# *DESP*: Demixing Cell State Profiles in Bulk Omics

An algorithm for predicting single-cell 'omics from bulk 'omics.

*See the [pre-print](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v2)!*

## Summary

* Biological systems are composed of heterogenous cell populations with distinct molecular profiles
* Single-cell methods like scRNA-Seq make it feasible to characterize the cell type composition of samples, *but..*
* Experimental limitations make it difficult to directly measure many molecules (e.g. proteins) at the cell-level
* We developed *DESP* to predict cell-level omics profiles from bulk omics and cell type composition of samples
* *DESP* overcomes experimental resolution limitations to enable the study of proteomes and other molecular profiles at the cell-level using established bulk-level workflows

##  Visual summary

*From [(Youssef et al., 2023)](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v2)*

![](https://github.com/AhmedYoussef95/Image-dump/blob/main/Fig%201.png)

## How does it work?

![](https://github.com/AhmedYoussef95/Image-dump/blob/main/DESP%20model.png)

* **Premise**: Model bulk data as product of cell type expression profiles and cell type proportions
* **Method**: Use regression-based approach to predict single-cell matrix *X* given bulk omics matrix *Y* and proportions matrix *A*
* **Output**: Map bulk data *Y* onto the cell types/states/populations defined in the mixture matrix *A*

For more details, including how we avoid relying on correlations between different omics types like proteomics and RNA-Seq, see [Youssef et al. (2023)](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v1).

## Inputs

* Bulk omics data
  * Feature-by-sample matrix *(pre-processed by user)*
* Cell population composition
  * Cell type-by-sample matrix containing number of cells or proportion of each cell type in each sample

Note: samples should be consistently named/ordered between the two datasets.

## Output

Cell type-by-feature matrix.

For example, a matrix with relative protein levels across cell types if the input data consisted of bulk proteomics data and cell type proportions of the same samples.

**Note:** the output resolution corresponds to the resolution of the input proportions matrix. Biologically, this could correspond to cell types, cell states, or even individual cells, depending on the user input in the `proportions` input matrix.

## Download R package

*DESP* is currently available through GitHub. To download R packages from GitHub, we suggest using the `install_github` function from the `devtools` package as below.

```devtools::install_github("AhmedYoussef95/DESP")```

## Example code

Given pre-processed matrices with the bulk omics data and cell type proportions of the samples, *DESP* can be run with just one line of code:

`cellStateProfiles <- DESP(bulk = bulkProfiles, proportions = cellTypeProportions)`

The output matrix can then be used for standard downstream analysis such as differential expression analysis and gene set enrichment analysis.

For a more detailed user-friendly tutorial, see the [vignette](https://htmlpreview.github.io/?https://github.com/AhmedYoussef95/DESP/blob/main/doc/DESP-vignette.html).

## Example applications

* Predicting omics profiles of transient cell states in studies of cell differentiation or disease progression
* Finding differences in cell type responses between disease subtypes
* Identifying biomarkers of tissue-specific and housekeeping cell types from organism-level databases

## What is *"demixing"*?

We use the term *demixing* to refer to separating cell type contributions to bulk omics measurements. Although the term *deconvolution* also applies to our method, we wanted to avoid that term to avoid comparisons to established *deconvolution* algorithms that have a different goal than ours, since the term *deconvolution* in bioinformatics is strongly associated with algorithms that aim to infer cell type proportions given single-cell and bulk profiles, as opposed to *DESP* which aims to predict single-cell profiles given cell type proportions and bulk profiles.

## Case study

To see an application of *DESP* for identifying the proteomics profiles of transient cell states that occur in cancer progression, see [Youssef et al. (2023)](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v2).

## Cite *DESP*

Youssef, Ahmed, et al. “DESP: Demixing Cell State Profiles from Dynamic Bulk Molecular Measurements.” 2023, https://doi.org/10.1101/2023.01.19.524460. 
