# Function that takes a list of files and creates payload for API
# :param filenames names of files to post
# :param description brief description of gist (optional)
payload <- function(filenames, description = "") {
  add <- filenames$add
  update <- filenames$update
  delete <- filenames$delete
  rename <- filenames$rename
  fnames <- c(unl(add), unl(update), unl(delete), unr(rename))
  add_update <- lapply(c(add, update), function(file) {
    list(content = paste(readLines(file, warn = FALSE), collapse = "\n"))
  })
  # del <- lapply(delete, function(file) structure(list(NULL), names = basename(file)))
  del <- do.call("c", unname(Map(function(x) stats::setNames(list(NULL), x), 
                                 sapply(delete, basename))))
  ren <- lapply(rename, function(f) {
    tt <- f[[1]]
    list(filename = basename(f[[2]]),
         content = paste(readLines(tt, warn = FALSE), collapse = "\n"))
  })
  files <- c(add_update, del, ren)
  names(files) <- base::basename(fnames)
  body <- list(description = description, files = files)
  jsonlite::toJSON(body, auto_unbox = TRUE, null = "null")
}

creategist <- function(filenames, description = "", public = TRUE) {
  filenames <- files_exist(filenames)
  files <- lapply(filenames, function(file) {
    list(content = paste(readLines(file, warn = FALSE, encoding = "UTF-8"), 
                         collapse = "\n"))
  })
  names(files) <- sapply(filenames, basename)
  body <- list(description = description, public = public, files = files)
  jsonlite::toJSON(body, auto_unbox = TRUE)
}

creategist_obj <- function(z, description = "", public = TRUE, pretty = TRUE,
                           filename = "file.txt") {
  nm <- deparse(substitute(z))
  if (pretty && any(is.data.frame(z) || is.matrix(z))) {
    z <- list(list(content = paste0(knitr::kable(z), collapse = "\n")))
  } else {
    z <- list(list(content = as.character(jsonlite::toJSON(z, 
                                                           auto_unbox = TRUE))))
  }
  names(z) <- filename
  body <- list(description = description, public = public, files = z)
  jsonlite::toJSON(body, auto_unbox = TRUE)
}

unl <- function(x) if (!is.null(x)) do.call(c, x) else NULL
unr <- function(x) 
  if (!is.null(x)) unname(sapply(x, function(z) z[[1]])) else NULL

mssg <- function(x, y) if (x) message(y)

gist_compact <- function(l) Filter(Negate(is.null), l)

gc <- function(x) {
  x <- gist_compact(x)
  x[rapply(x, length) != 0]
}

ghbase <- function() 'https://api.github.com'

ghead <- function(){
  add_headers(`User-Agent` = "gistr", 
              `Accept` = 'application/vnd.github.v3+json')
}

gist_GET <- function(url, auth, headers, args=NULL, ...){
  response <- GET(url, auth, headers, query = args, ...)
  process(response)
}

gist_PATCH <- function(id, auth, headers, body, ...){
  response <- PATCH(paste0(ghbase(), '/gists/', id), auth, headers, 
                    body = body, encode = "json")
  process(response)
}

gist_POST <- function(url, auth, headers, body, ...){
  response <- POST(url, auth, headers, body = body, encode = "json", ...)
  process(response)
}

gist_PUT <- function(url, auth, headers, ...){
  PUT(url, auth, headers, ...)
}

gist_DELETE <- function(url, auth, headers, ...){
  res <- DELETE(url, auth, headers, ...)
  stopstatus(res, 204)
  res
}

process <- function(x){
  stopstatus(x)
  stopifnot(x$headers$`content-type` == 'application/json; charset=utf-8')
  temp <- httr::content(x, as = "text", encoding = "UTF-8")
  jsonlite::fromJSON(temp, FALSE)
}

stopstatus <- function(x, status_stop = 203) {
  if (x$status_code > status_stop) {
    res <- jsonlite::fromJSON(httr::content(x, as = "text", 
                                            encoding = "UTF-8"), FALSE)
    errs <- sapply(res$errors, function(z) paste(names(z), z, sep = ": ", 
                                                 collapse = "\n"))
    # check for possible oauth scope problems
    scopes_problem <- ""
    if (is.null(x$headers$`x-oauth-scopes`)) {
      scopes_problem <- "  GitHub response headers suggest no or insufficient scopes\n  To create gists you need the `gist` OAuth scope on your token."
    }
    stop(res$message, "\n", errs, "\n", scopes_problem, call. = FALSE)
  }
}

check_auth <- function(x) if (!missing(x)) x else gist_auth()

strextract <- function(str, pattern) {
  regmatches(str, regexpr(pattern, str))
}

strtrim <- function(str) {
  gsub("^\\s+|\\s+$", "", str)
}

# pop columns or named elements out of lists
pop <- function(x, topop, ...) {
  UseMethod("pop")
}

pop.data.frame <- function(x, topop, ...) {
  x[ !names(x) %in% topop, ]
}

pop.list <- function(x, topop, ...) {
  x[ !names(x) %in% topop ]
}
