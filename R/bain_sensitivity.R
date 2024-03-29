#' @title Sensitivity analysis for bain
#' @description Conducts a sensitivity analysis for \code{\link[bain]{bain}}.
#' @param x An R object containing the outcome of a statistical analysis.
#' Currently, the following objects can be processed: \code{lm()},
#' \code{t_test()}, \code{lavaan} objects created with the
#' \code{sem()}, \code{cfa()}, and \code{growth()} functions, and named
#' vector objects. See the vignette for elaborations.
#' @param hypothesis	A character string containing the informative hypotheses
#' to evaluate. See the vignette for elaborations.
#' @param fractions A number representing the fraction of information
#' in the data used to construct the prior distribution.
#' The default value 1 denotes the
#' minimal fraction, 2 denotes twice the minimal fraction, etc. See the
#' vignette for elaborations.
#' @param ... Additional arguments passed to \code{\link[bain]{bain}}.
#' @return A \code{data.frame} of class \code{"bain_sensitivity"}.
#' @details The Bayes factor for equality constraints is sensitive to a
#' scaling factor applied to the prior distribution. The argument
#' \code{fraction} adjusts this scaling factor. The function
#' \code{bain_sensitivity}
#' is a wrapper for \code{\link[bain]{bain}}, which accepts a vector for the
#' \code{fractions} argument, and returns a list of bain results objects.
#' A table with a sensitivity analysis for specific statistics can be obtained
#' using the \code{summary()} function, which accepts the argument
#' \code{summary(which_stat = ...)}. The available statistics are elements of
#' the \code{$fit} table (Fit_eq, Com_eq, Fit_in, Com_in, Fit, Com, BF, PMPa,
#' and PMPb), and elements of the
#' \code{BFmatrix}, which can be accessed by matrix notation, e.g.:
#' \code{summary(bain_sens, which_stat = "BFmatrix[1,2]")}.
#' @examples
#' sesamesim$site <- as.factor(sesamesim$site)
#' res <- lm(sesamesim$postnumb~sesamesim$site-1)
#' set.seed(4583)
#' bain_sens <- bain_sensitivity(res, "site1=site2;
#'                                     site2>site5",
#'                                     fractions = c(1,2,3))
#' summary(bain_sens, which_stat = "BF.c")
#' summary(bain_sens, which_stat = "BFmatrix[1,2]")
#' @rdname bain_sensitivity
#' @export
bain_sensitivity <- function(x, hypothesis, fractions = 1, ...){
  Args <- as.list(match.call()[-1])
  if(!exists(".Random.seed")) set.seed(NULL)
  the_seed <- .Random.seed[1]
  Args$x <- force(x)
  outlist <- lapply(fractions, function(this_frac){
    Args[["fraction"]] <- this_frac
    set.seed(the_seed)
    out <- do.call(bain, Args)
    out[["fraction"]] <- this_frac
    out
  })
  class(outlist) <- c("bain_sensitivity", class(outlist))
  outlist
}

#' @method print bain_sensitivity
#' @export
print.bain_sensitivity <- function(x, ...){
  print(summary(x))
}

#' @method summary bain_sensitivity
#' @export
summary.bain_sensitivity  <- function(object, which_stat = "BF.c", ...){
  which_stat <- as.character(which_stat)[1]
  if(!grepl("BFmatrix\\[", which_stat)){
    outlist <- lapply(object, function(this_output){
      this_output[["fit"]][which_stat]
    })
    outlist <- tryCatch({
      lapply(object, function(this_output){
        this_output[["fit"]][which_stat]
      })
    }, error = function(e){stop("Requested statistic is not part of the 'fit' table. The fit table has the following columns: ", paste0(names(object[[1]]$fit), collapse = ", "), ".", call. = FALSE)})
  } else {
    outlist <- tryCatch({
      lapply(object, function(this_output){
        if(!grepl("drop", which_stat)){
          which_stat <- gsub("\\]", ", drop = FALSE\\]", which_stat)
        }
        out <- eval(parse(text = which_stat), envir = this_output)
        if(!is.null(dim(out))){
          tmp <- as.data.frame.table(out)
          out <- tmp$Freq
          names(out) <- paste0(tmp$Var1, ".", tmp$Var2)
        }
        out
      })
    }, error = function(e){stop("Requested cells that are not part of BFmatrix. BFmatrix has ", dim(object[[1]]$BFmatrix)[1], " rows and ", dim(object[[1]]$BFmatrix)[2], " columns.", call. = FALSE)})
  }
  out_tab <- data.frame(Fraction = sapply(object, `[[`, "fraction"),
                        t(do.call(cbind,
                                  outlist)))
  empty_rows <- apply(out_tab, 1, function(x){all(is.na(x))})
  empty_cols <- apply(out_tab, 2, function(x){all(is.na(x))})
  out_tab <- out_tab[!empty_rows, !empty_cols]
  rownames(out_tab) <- NULL
  class(out_tab) <- c("sum_sensitivity", class(out_tab))
  out_tab
}
