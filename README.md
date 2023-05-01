# *DESP*: Demixing Cell State Profiles in Bulk Omics

An algorithm for predicting single-cell 'omics from bulk 'omics.

*See our [pre-print](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v1)!*

## Download R package

```devtools::install_github("AhmedYoussef95/DESP")```

## Summary

* Biological systems are composed of heterogenous cell populations with distinct molecular profiles
* Single-cell methods like scRNA-Seq make it routinely feasible to charactize the cell type composition of samples, *but..*
* Experimental limitations make it difficult to directly measure many molecules (e.g. proteins) at the cell-level
* We developed *DESP* to predict cell-level omics profiles given bulk omics data and cell type composition of samples
* *DESP* offers a computational solution to experimental limitations

##  Visual summary

*From [(Youssef et al., 2023)](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v1)*

![](https://github.com/AhmedYoussef95/Image-dump/blob/main/Fig%201.png)

## How does it work?

For more details, see [Youssef et al. (2023)](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v1).

## Inputs

## Output

## Example applications

* Predicting omics profiles of transient cell states in timecourse studies of cell differentiation or disease progression
* Finding differences in cell type responses between disease subtypes
* Identifying biomarkers of tissue-specific and housekepeing cell types in global organism databases (e.g. the *Human Cell Atlas*)

## Case study

To see an application of *DESP* for identifying the proteomics profiles of transient celll states that occur in cancer progression, see [Youssef et al. (2023)](https://www.biorxiv.org/content/10.1101/2023.01.19.524460v1).
