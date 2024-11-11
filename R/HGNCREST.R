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
    request("https://rest.genenames.org/") |>
        req_template("/info/") |>
        req_headers(Accept = "application/json") |>
        req_perform() |>
        resp_body_json(simplifyVector = TRUE)
}

#' @rdname HGNCREST
#'
#' @returns searchableFields: A character vector of searchable fields in the
#'   HGNC database.
#'
#' @examples
#' searchableFields()
#' @export
searchableFields <- function() {
    response <- hgnc_info()
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
    response <- request("https://rest.genenames.org/") |>
        req_template("/fetch/{searchableField}/{value}") |>
        req_headers(Accept = "application/json") |>
        req_perform() |>
        resp_body_json(simplifyVector = TRUE)

    res_data <- response[[c("response", "docs")]]

    lcols <- vapply(res_data, is.list, logical(1L))

    tidyr::unnest(res_data, cols = names(lcols[lcols]))
}

.encode_string_dquote <- function(string) {
    hasSpace <- grepl("\\s+", string)
    hasDquote <- grepl('"', string)
    hasColon <- grepl(":", string)
    if (hasSpace && !hasDquote) {
        if (hasColon) {
            splits <- strsplit(string, ":", fixed = TRUE) |> unlist()
            if (!identical(length(splits), 2L))
                stop("More than one colon in single query string")
            string <- paste0(splits[1L], ":", dQuote(splits[2L]))
        } else {
            string <- dQuote(string)
        }
    }
    utils::URLencode(string)
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
#' hgnc_search("symbol", "ZNF*")
#' hgnc_search("symbol", c("ZNF*", "AND", "status:Approved"))
#' hgnc_search("symbol", c("ZNF3", "OR", "ZNF12"))
#' hgnc_search("symbol", c("ZNF*", "NOT", "status:Approved"))
#' hgnc_search("symbol", c("ZNF*", "AND", 'status:Entry withdrawn'))
#' hgnc_search("name", c("MAPK interacting", "AND", "locus_type:gene with protein product"))
#' @export
hgnc_search <- function(searchableField = NULL, query) {
    if (!missing(searchableField))
        stopifnot(isScalarCharacter(searchableField))
    stopifnot(isCharacter(query))
    query <- vapply(query, .encode_string_dquote, character(1L))
    if (length(query) > 1L)
        query <- paste(query, collapse = "+")
    template <- paste0("/search/", searchableField, "/{query}")
    response <- request("https://rest.genenames.org/") |>
        req_template(template) |>
        req_headers(Accept = "application/json") |>
        req_perform() |>
        resp_body_json(simplifyVector = TRUE)

    response[[c("response", "docs")]]
}
