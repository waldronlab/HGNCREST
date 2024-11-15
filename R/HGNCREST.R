#' @name HGNCREST
#'
#' @title Functions for querying the HGNC REST API
#'
#' @description
#' The functions follow the HGNC REST API documentation at
#' <https://www.genenames.org/help/rest/>. There are three main operations
#' that can be performed with this package: fetching information about a
#' specific gene (`hgnc_fetch`), searching for genes based on a query
#' (`hgnc_search`), and fetching general information about the HGNC database
#' (`hgnc_info`).
#'
#' @returns hgnc_info: A list of general information about the HGNC database. It
#'   includes `searchableFields` and `storedFields` metadata.
#'
#' @import httr2
#' @examples
#' hgnc_info()
#' @export
hgnc_info <- function() {
    .info_req("HGNC")
}

#' @rdname HGNCREST
#'
#' @param service `character(1)` Either "HGNC" or "VGNC".
#'
#' @returns searchableFields: A character vector of searchable fields in the
#'   HGNC or VGNC database.
#'
#' @examples
#' searchableFields()
#' @export
searchableFields <- function(service = c("HGNC", "VGNC")) {
    service <- match.arg(service)
    response <- .info_req(service)
    response[["searchableFields"]]
}


#' @rdname HGNCREST
#'
#' @param searchableField `character(1)` A field as provided by
#'   `searchableFields()`.
#'
#' @param value `character(1)` A value to search for in the `searchableField`.
#'
#' @returns hgnc_fetch: A `tibble` with information about the gene specified by
#'   the `searchableField` and `value` arguments.
#'
#' @importFrom BiocBaseUtils isScalarCharacter
#' @examples
#' hgnc_fetch("ena", "BC040926")
#' @export
hgnc_fetch <- function(searchableField, value) {
    stopifnot(isScalarCharacter(searchableField), isScalarCharacter(value))
    .fetch_req("HGNC", searchableField, value)
}

#' @rdname HGNCREST
#'
#' @param query `character()` A query string to search for in the HGNC database.
#'   The query string can be a single string or a vector of strings. If the
#'   query is a vector, the strings are concatenated with a "+". The query
#'   string can contain logical operators such as "AND", "OR", and "NOT". The
#'   query string can also contain field-value pairs separated by a colon. For
#'   example, to search for genes with the symbol starting with "ZNF" and the
#'   status "Approved", the query string would be c("ZNF*", "AND",
#'   "status:Approved").
#'
#' @returns hgnc_search: A `data.frame` with information about the genes that
#'   match the query.
#'
#' @importFrom BiocBaseUtils isCharacter
#' @examples
#' hgnc_search(query = "BRAF")
#' hgnc_search("symbol", "ZNF*") |>
#'     head()
#' hgnc_search("symbol", c("ZNF*", "AND", "status:Approved")) |>
#'     head()
#' hgnc_search("symbol", c("ZNF3", "OR", "ZNF12"))
#' hgnc_search("symbol", c("ZNF*", "NOT", "status:Approved")) |>
#'     head()
#' hgnc_search("symbol", c("ZNF*", "AND", 'status:Entry withdrawn')) |>
#'     head()
#' hgnc_search(
#'     "name",
#'     c("MAPK interacting", "AND", "locus_type:gene with protein product")
#' )
#' @export
hgnc_search <- function(searchableField = NULL, query) {
    if (!missing(searchableField))
        stopifnot(isScalarCharacter(searchableField))
    stopifnot(isCharacter(query))
    .search_req("HGNC", searchableField, query)
}
