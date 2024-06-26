#' The Effect of Prior Interaction on Trust
#'
#' These data were published in Kuiper and colleagues (2013), who set out to
#' aggregate evidence for the effect of prior interactions between partners on
#' trust in (economic) exchange relations across four heterogeneous replication
#' studies. Batenburg et al. (2003) analyzed survey data using linear regression
#' with covariates; Buskens and Raub (2002) analyzed experimental data using
#' linear regression; Buskens and Weesie (2000) used an experimental design with
#' a binary outcome, analyzed using probit regression; and Buskens, Raub, and
#' Van der Veer (2010) used a longitudinal experimental design, analyzing the
#' data with a three-level logistic regression. These studies each provide a
#' regression coefficient (beta) assessing the effect of past experience on
#' trust, and its estimated sampling variance (squared standard error). The
#' sample sizes (n) were derived from the original publications.
#'
#' \tabular{lll}{
#'   \strong{Study} \tab \code{character} \tab Reference of the original publication.\cr
#'   \strong{beta} \tab \code{numeric} \tab Regression coefficient for the effect of prior interaction on trust.\cr
#'   \strong{vi} \tab \code{numeric} \tab Sampling variance of `beta`.\cr
#'   \strong{n} \tab \code{integer} \tab Sample size.
#' }
#' @docType data
#' @keywords datasets
#' @name kuiper2013
#' @usage data(kuiper2013)
#' @references Kuiper, R. M., Buskens, V., Raub, W., & Hoijtink, H. (2013).
#' Combining Statistical Evidence From Several Studies: A Method Using Bayesian
#' Updating and an Example From Research on Trust Problems in Social and
#' Economic Exchange. Sociological Methods & Research, 42(1), 60–81.
#' <doi:10.1177/0049124112464867>
#'
#' Batenburg, R. S., W. Raub, and C. Snijders. 2003. Contacts and Contracts:
#' Temporal Embeddedness and the Contractual Behavior of Firms. Research in
#' the Sociology of Organizations 20:135-88.
#'
#' Buskens, V. and W. Raub. 2002. Embedded Trust: Control and Learning.
#' Advances in Group Processes 19:167-202.
#'
#' Buskens, V., W. Raub, and J. van der Veer. 2010. Trust in Triads: An
#' Experimental Study. Social Networks 32:301-12.
#'
#' Buskens, V. and J. Weesie. 2000. An Experiment on the Effects of
#' Embeddedness in Trust Situations: Buying a Used Car. Rationality and
#' Society 12:227-53.
#' @format A data frame with 4 rows and 4 variables.
NULL
