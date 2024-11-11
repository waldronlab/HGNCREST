
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
#> [1] "2024-10-25T11:04:11.271Z"
#> 
#> $numDoc
#> [1] 45609
#> 
#> $responseHeader
#> $responseHeader$QTime
#> [1] 1
#> 
#> $responseHeader$status
#> [1] 0
#> 
#> 
#> $searchableFields
#>  [1] "location"         "entrez_id"        "alias_name"       "hgnc_id"         
#>  [5] "alias_symbol"     "vega_id"          "curator_notes"    "mgd_id"          
#>  [9] "rgd_id"           "refseq_accession" "uniprot_ids"      "prev_symbol"     
#> [13] "omim_id"          "name"             "ucsc_id"          "prev_name"       
#> [17] "status"           "symbol"           "ensembl_gene_id"  "rna_central_id"  
#> [21] "locus_type"       "locus_group"      "ena"              "ccds_id"         
#> [25] "mane_select"     
#> 
#> $storedFields
#>  [1] "mgd_id"                 "bioparadigms_slc"       "uniprot_ids"           
#>  [4] "rgd_id"                 "homeodb"                "agr"                   
#>  [7] "cd"                     "curator_notes"          "orphanet"              
#> [10] "horde_id"               "lncrnadb"               "gene_group"            
#> [13] "ena"                    "locus_group"            "_version_"             
#> [16] "pubmed_id"              "mamit-trnadb"           "snornabase"            
#> [19] "locus_type"             "ensembl_gene_id"        "mirbase"               
#> [22] "lsdb"                   "date_symbol_changed"    "status"                
#> [25] "date_approved_reserved" "alias_name"             "location"              
#> [28] "prev_name"              "ucsc_id"                "name"                  
#> [31] "enzyme_id"              "refseq_accession"       "imgt"                  
#> [34] "pseudogene.org"         "hgnc_id"                "vega_id"               
#> [37] "alias_symbol"           "alias_name"             "entrez_id"             
#> [40] "uuid"                   "date_name_changed"      "location"              
#> [43] "lncipedia"              "cosmic"                 "ccds_id"               
#> [46] "mane_select"            "rna_central_id"         "gtrnadb"               
#> [49] "prev_name"              "symbol"                 "gencc"                 
#> [52] "omim_id"                "date_modified"          "merops"                
#> [55] "prev_symbol"            "iuphar"                 "gene_group_id"
```

# Searchable fields

The `searchableFields` function is a convenience function that returns a
character vector of searchable fields in the HGNC database.

``` r
searchableFields()
#>  [1] "omim_id"          "prev_symbol"      "name"             "prev_name"       
#>  [5] "ucsc_id"          "status"           "symbol"           "rna_central_id"  
#>  [9] "ensembl_gene_id"  "locus_type"       "ena"              "locus_group"     
#> [13] "mane_select"      "ccds_id"          "location"         "alias_name"      
#> [17] "entrez_id"        "curator_notes"    "alias_symbol"     "hgnc_id"         
#> [21] "vega_id"          "mgd_id"           "rgd_id"           "uniprot_ids"     
#> [25] "refseq_accession"
```

# Fetching gene information

The `hgnc_fetch` function returns a `tibble` with information about the
gene specified by the `searchableField` and `value` arguments.

``` r
hgnc_fetch("ena", "BC040926")
#> # A tibble: 3 × 26
#>   locus_type       gene_group_id symbol date_approved_reserved date_name_changed
#>   <chr>                    <int> <chr>  <chr>                  <chr>            
#> 1 RNA, long non-c…          1987 A1BG-… 2009-07-20T00:00:00Z   2012-08-15T00:00…
#> 2 RNA, long non-c…          1987 A1BG-… 2009-07-20T00:00:00Z   2012-08-15T00:00…
#> 3 RNA, long non-c…          1987 A1BG-… 2009-07-20T00:00:00Z   2012-08-15T00:00…
#> # ℹ 21 more variables: vega_id <chr>, date_modified <chr>, status <chr>,
#> #   name <chr>, alias_symbol <chr>, agr <chr>, ena <chr>, prev_symbol <chr>,
#> #   entrez_id <chr>, locus_group <chr>, ensembl_gene_id <chr>, lncipedia <chr>,
#> #   date_symbol_changed <chr>, hgnc_id <chr>, rna_central_id <chr>,
#> #   ucsc_id <chr>, prev_name <chr>, uuid <chr>, location <chr>,
#> #   refseq_accession <chr>, gene_group <chr>
```

# Searching for genes

The `hgnc_search` function searches for genes based on a query. It
returns a `data.frame` with information about the genes that match the
query.

``` r
hgnc_search("symbol", "BRCA1")
#>   symbol   hgnc_id    score
#> 1  BRCA1 HGNC:1100 4.692007
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
#> R Under development (unstable) (2024-11-01 r87285)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 22.04.5 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0 
#> LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
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
#>  [1] vctrs_0.6.5         cli_3.6.3           knitr_1.49         
#>  [4] rlang_1.1.4         xfun_0.49           purrr_1.0.2        
#>  [7] generics_0.1.3      jsonlite_1.8.9      glue_1.8.0         
#> [10] htmltools_0.5.8.1   BiocBaseUtils_1.9.0 fansi_1.0.6        
#> [13] rmarkdown_2.29      rappdirs_0.3.3      tibble_3.2.1       
#> [16] evaluate_1.0.1      fastmap_1.2.0       yaml_2.3.10        
#> [19] lifecycle_1.0.4     BiocManager_1.30.25 compiler_4.5.0     
#> [22] dplyr_1.1.4         codetools_0.2-20    pkgconfig_2.0.3    
#> [25] tidyr_1.3.1         rstudioapi_0.17.1   digest_0.6.37      
#> [28] R6_2.5.1            tidyselect_1.2.1    utf8_1.2.4         
#> [31] pillar_1.9.0        curl_6.0.0          magrittr_2.0.3     
#> [34] withr_3.0.2         tools_4.5.0
```

</details>
