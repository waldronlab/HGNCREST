
# HGNCREST

The `HGNCREST` package provides functions for querying the HGNC REST
API. The functions follow the HUGO Gene Nomenclature Committee (HGNC)
REST API documentation at <https://www.genenames.org/help/rest/>. There
are three main operations that can be performed with this package:

1.  fetching general information about the HGNC database (`hgnc_info`).
2.  fetching information about a specific gene (`hgnc_fetch`)
3.  searching for genes based on a query (`hgnc_search`)

# Installation

``` r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("waldronlab/HGNCREST")
```

## Package load

``` r
library(HGNCREST)
```

# General information

The `hgnc_info` function returns general information about the HGNC
database. It includes `searchableFields` and `storedFields` metadata.

``` r
hgnc_info()
#> $lastModified
#> [1] "2024-11-12T13:14:30.758Z"
#> 
#> $numDoc
#> [1] 45613
#> 
#> $responseHeader
#> $responseHeader$QTime
#> [1] 0
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> 
#> $searchableFields
#>  [1] "refseq_accession" "mgd_id"           "locus_group"      "vega_id"          "uniprot_ids"     
#>  [6] "ensembl_gene_id"  "alias_symbol"     "curator_notes"    "hgnc_id"          "omim_id"         
#> [11] "ucsc_id"          "rna_central_id"   "name"             "ena"              "prev_symbol"     
#> [16] "ccds_id"          "locus_type"       "alias_name"       "mane_select"      "rgd_id"          
#> [21] "location"         "symbol"           "entrez_id"        "status"           "prev_name"       
#> 
#> $storedFields
#>  [1] "snornabase"             "mirbase"                "prev_name"             
#>  [4] "enzyme_id"              "uuid"                   "pubmed_id"             
#>  [7] "prev_name"              "agr"                    "lsdb"                  
#> [10] "ccds_id"                "ena"                    "locus_type"            
#> [13] "bioparadigms_slc"       "rna_central_id"         "date_symbol_changed"   
#> [16] "cd"                     "alias_name"             "mamit-trnadb"          
#> [19] "alias_symbol"           "location"               "gencc"                 
#> [22] "uniprot_ids"            "mgd_id"                 "date_name_changed"     
#> [25] "entrez_id"              "status"                 "orphanet"              
#> [28] "location"               "symbol"                 "date_approved_reserved"
#> [31] "lncrnadb"               "gtrnadb"                "_version_"             
#> [34] "prev_symbol"            "pseudogene.org"         "homeodb"               
#> [37] "alias_name"             "mane_select"            "rgd_id"                
#> [40] "horde_id"               "ucsc_id"                "omim_id"               
#> [43] "name"                   "merops"                 "lncipedia"             
#> [46] "imgt"                   "iuphar"                 "date_modified"         
#> [49] "cosmic"                 "hgnc_id"                "curator_notes"         
#> [52] "gene_group_id"          "vega_id"                "ensembl_gene_id"       
#> [55] "refseq_accession"       "locus_group"            "gene_group"
```

# Searchable fields

The `searchableFields` function is a convenience function that returns a
character vector of searchable fields in the HGNC database.

``` r
searchableFields()
#>  [1] "alias_symbol"     "curator_notes"    "hgnc_id"          "uniprot_ids"      "vega_id"         
#>  [6] "ensembl_gene_id"  "refseq_accession" "mgd_id"           "locus_group"      "entrez_id"       
#> [11] "prev_name"        "status"           "symbol"           "location"         "locus_type"      
#> [16] "prev_symbol"      "ccds_id"          "ena"              "mane_select"      "rgd_id"          
#> [21] "alias_name"       "omim_id"          "ucsc_id"          "name"             "rna_central_id"
```

# Fetching gene information

The `hgnc_fetch` function returns a `tibble` with information about the
gene specified by the `searchableField` and `value` arguments.

``` r
hgnc_fetch("ena", "BC040926")
#> # A tibble: 3 × 26
#>   date_modified        date_approved_reserved locus_group    gene_group_id uuid       locus_type agr  
#>   <chr>                <chr>                  <chr>                  <int> <chr>      <chr>      <chr>
#> 1 2013-06-27T00:00:00Z 2009-07-20T00:00:00Z   non-coding RNA          1987 2d9067ca-… RNA, long… HGNC…
#> 2 2013-06-27T00:00:00Z 2009-07-20T00:00:00Z   non-coding RNA          1987 2d9067ca-… RNA, long… HGNC…
#> 3 2013-06-27T00:00:00Z 2009-07-20T00:00:00Z   non-coding RNA          1987 2d9067ca-… RNA, long… HGNC…
#> # ℹ 19 more variables: date_name_changed <chr>, ensembl_gene_id <chr>, symbol <chr>, entrez_id <chr>,
#> #   prev_name <chr>, prev_symbol <chr>, ucsc_id <chr>, name <chr>, ena <chr>, rna_central_id <chr>,
#> #   status <chr>, date_symbol_changed <chr>, hgnc_id <chr>, vega_id <chr>, refseq_accession <chr>,
#> #   lncipedia <chr>, alias_symbol <chr>, location <chr>, gene_group <chr>
```

# Searching for genes

The `hgnc_search` function searches for genes based on a query. It
returns a `data.frame` with information about the genes that match the
query.

``` r
hgnc_search("symbol", "BRCA1")
#>   symbol   hgnc_id    score
#> 1  BRCA1 HGNC:1100 4.692048
```

# Advanced search

The `hgnc_search` function also allows for more complex queries using
the `query` argument. The query should be a string that follows the HGNC
REST API query syntax.

``` r
hgnc_search("symbol", c("ZNF*", "AND", "status:Approved")) |>
    head()
#>         symbol    hgnc_id    score
#> 1         ZNF2 HGNC:12991 1.018264
#> 2         ZNF3 HGNC:13089 1.018264
#> 3         ZNF7 HGNC:13139 1.018264
#> 4         ZNF8 HGNC:13154 1.018264
#> 5      ZNF8-DT HGNC:55280 1.018264
#> 6 ZNF8-ERVK3-1 HGNC:56757 1.018264
```

# Searching for genes based on multiple criteria

In this example, we search for genes with the name “MAPK interacting”
and that have a locus type of “gene with protein product”. Note that
“locus_type” is a searchable field in the HGNC database that can be used
to filter the search results.

``` r
hgnc_search(
    "name",
    c("MAPK interacting", "AND", "locus_type:gene with protein product")
)
#>   symbol   hgnc_id    score
#> 1  MKNK1 HGNC:7110 8.759536
#> 2  MKNK2 HGNC:7111 8.759536
```

# Conclusion

The `HGNCREST` package provides a convenient way to query the HGNC REST
API from R. It allows users to fetch information about specific genes,
search for genes based on a query, and get general information about the
HGNC database.

# sessionInfo

<details>
<summary>
Click to expand
</summary>

``` r
sessionInfo()
#> R Under development (unstable) (2024-11-03 r87286)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.1 LTS
#> 
#> Matrix products: default
#> BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
#>  [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
#> [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: America/New_York
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] HGNCREST_0.99.0 httr2_1.0.6    
#> 
#> loaded via a namespace (and not attached):
#>  [1] rappdirs_0.3.3      utf8_1.2.4          generics_0.1.3      tidyr_1.3.1        
#>  [5] digest_0.6.37       magrittr_2.0.3      evaluate_1.0.1      pkgload_1.4.0      
#>  [9] fastmap_1.2.0       jsonlite_1.8.9      sessioninfo_1.2.2   pkgbuild_1.4.5     
#> [13] BiocAddins_0.99.21  urlchecker_1.0.1    promises_1.3.0      BiocManager_1.30.25
#> [17] purrr_1.0.2         fansi_1.0.6         codetools_0.2-20    cli_3.6.3          
#> [21] shiny_1.9.1         rlang_1.1.4         ellipsis_0.3.2      remotes_2.5.0      
#> [25] withr_3.0.2         cachem_1.1.0        yaml_2.3.10         devtools_2.4.5     
#> [29] BiocBaseUtils_1.9.0 tools_4.5.0         memoise_2.0.1       dplyr_1.1.4        
#> [33] httpuv_1.6.15       credentials_2.0.2   curl_6.0.0          vctrs_0.6.5        
#> [37] R6_2.5.1            mime_0.12           lifecycle_1.0.4     fs_1.6.5           
#> [41] htmlwidgets_1.6.4   usethis_3.0.0       miniUI_0.1.1.1      pkgconfig_2.0.3    
#> [45] desc_1.4.3          pillar_1.9.0        later_1.3.2         glue_1.8.0         
#> [49] profvis_0.4.0       Rcpp_1.0.13-1       gert_2.1.4          xfun_0.49          
#> [53] tibble_3.2.1        tidyselect_1.2.1    sys_3.4.3           rstudioapi_0.17.1  
#> [57] knitr_1.49          xtable_1.8-4        htmltools_0.5.8.1   rmarkdown_2.29     
#> [61] compiler_4.5.0      askpass_1.2.1       openssl_2.2.2
```

</details>
