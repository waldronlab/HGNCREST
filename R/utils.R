.HGNC_REST_URL <- "https://rest.genenames.org/"

.service_url <- function(service = c("HGNC", "VGNC")) {
    switch(
        service,
        HGNC = .HGNC_REST_URL,
        VGNC = paste0(.HGNC_REST_URL, "vgnc/")
    )
}

.info_req <- function(service) {
    service_url <- .service_url(service)
    request(service_url) |>
        req_template("/info/") |>
        req_headers(Accept = "application/json") |>
        req_perform() |>
        resp_body_json(simplifyVector = TRUE)
}

.fetch_req <- function(service, searchableField, value) {
    service_url <- .service_url(service)
    response <- request(service_url) |>
        req_template("/fetch/{searchableField}/{value}") |>
        req_headers(Accept = "application/json") |>
        req_perform() |>
        resp_body_json(simplifyVector = TRUE)

    res_data <- response[[c("response", "docs")]]

    tibble::as_tibble(res_data)
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

.search_req <- function(service, searchableField, query) {
    service_url <- .service_url(service)
    query <- vapply(query, .encode_string_dquote, character(1L))
    if (length(query) > 1L)
        query <- paste(query, collapse = "+")
    template <- paste0("/search/", searchableField, "/{query}")
    response <- request(service_url) |>
        req_template(template) |>
        req_headers(Accept = "application/json") |>
        req_perform() |>
        resp_body_json(simplifyVector = TRUE)

    response[[c("response", "docs")]]
}
