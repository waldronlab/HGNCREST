#' @name VGNCREST
#'
#' @title Functions for querying the VGNC REST sister API
#'
#' @description
#' The functions follow the VGNC REST API documentation at
#' <https://www.genenames.org/help/rest/>. There are three main operations
#' that can be performed with this package: fetching information about a
#' specific gene (`vgnc_fetch`), searching for genes based on a query
#' (`vgnc_search`), and fetching general information about the VGNC database
#' (`vgnc_info`).
#'
#' @returns vgnc_info: A list of general information about the VGNC database. It
#'   includes `searchableFields` and `storedFields` metadata.
#'
#' @inheritParams HGNCREST
#'
#' @examples
#' vgnc_info()
#' @export
vgnc_info <- function() {
    .info_req("VGNC")
}

#' @rdname VGNCREST
#'
#' @returns vgnc_fetch: A `tibble` with information about the gene specified by
#'   the `searchableField` and `value` arguments.
#'
#' @examples
#' vgnc_fetch("symbol", "ZNF3")
#' @export
vgnc_fetch <- function(searchableField, value) {
    stopifnot(isScalarCharacter(searchableField), isScalarCharacter(value))
    .fetch_req("VGNC", searchableField, value)
}

#' @rdname VGNCREST
#'
#' @returns vgnc_search: A `data.frame` with information about the genes that
#'   match the `query` in the `searchableField`.
#'
#' @examples
#' vgnc_search(query = "BRAF")
#' vgnc_search("symbol", "ZNF*") |>
#'     head()
#' vgnc_search("symbol", c("ZNF*", "AND", "status:Approved")) |>
#'     head()
#' @export
vgnc_search <- function(searchableField = NULL, query) {
    if (!missing(searchableField))
        stopifnot(isScalarCharacter(searchableField))
    stopifnot(isCharacter(query))
    .search_req("VGNC", searchableField, query)
}
