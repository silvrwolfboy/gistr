<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{gistr vignette}
%\VignetteEncoding{UTF-8}
-->



gistr tutorial
============

## Install

Stable version from CRAN


```r
install.packages("gistr")
```

Development version from GitHub


```r
devtools::install_github("ropensci/gistr")
```


```r
library("gistr")
```

## Authentication

There are two ways to authorise gistr to work with your GitHub account:

* Generate a personal access token (PAT) at [https://help.github.com/articles/creating-an-access-token-for-command-line-use](https://help.github.com/articles/creating-an-access-token-for-command-line-use) and record it in the `GITHUB_PAT` envar.
* Interactively login into your GitHub account and authorise with OAuth.

Using the PAT is recommended.

Using the `gist_auth()` function you can authenticate seperately first, or if you're not authenticated, this function will run internally with each functionn call. If you have a PAT, that will be used, if not, OAuth will be used.


```r
gist_auth()
```

## Workflow

In `gistr` you can use pipes, introduced perhaps first in R in the package `magrittr`, to pass outputs from one function to another. If you have used `dplyr` with pipes you can see the difference, and perhaps the utility, of this workflow over the traditional workflow in R. You can use a non-piping or a piping workflow with `gistr`. Examples below use a mix of both workflows. Here is an example of a piping wofklow (with some explanation):


```r
file <- system.file("examples", "stuff.Rmd", package = "gistr")
gists(what = "minepublic")[[1]] %>% # List my public gists, and index 1st
  add_files(file) %>% # Add new file to that gist
  update() # update sends a PATCH command to Gists API to add file to your gist
```

And a non-piping workflow that does the same exact thing:


```r
file <- system.file("examples", "example1.md", package = "gistr")
g <- gists(what = "minepublic")[[1]]
g <- add_files(g, file)
update(g)
```

Or you could string them all together in one line (but it's rather difficult to follow what's going on because you have to read from the inside out)


```r
update(add_files(gists(what = "minepublic")[[1]], file))
```

## Rate limit information


```r
rate_limit()
```

```
#> Rate limit: 5000
#> Remaining:  4224
#> Resets in:  43 minutes
```


## List gists

Limiting to a few results here to keep it brief


```r
gists(per_page = 2)
```

```
#> [[1]]
#> <gist>4baa80440a1e0cdb4b195872762c6251
#>   URL: https://gist.github.com/4baa80440a1e0cdb4b195872762c6251
#>   Description: Elimination (PuzzleScript Script)
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:06Z / 2019-07-18T17:39:06Z
#>   Files: readme.txt, script.txt
#>   Truncated?: FALSE, FALSE
#> 
#> [[2]]
#> <gist>9f15e4d4c5f02b56cc634c31dd9f4153
#>   URL: https://gist.github.com/9f15e4d4c5f02b56cc634c31dd9f4153
#>   Description: rubberduck v1.4.3 - Passed - Package Tests Results
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:05Z / 2019-07-18T17:39:06Z
#>   Files: 1.RegistrySnapshot.xml, FilesSnapshot.xml, Install.txt, Uninstall.txt, _Summary.md
#>   Truncated?: FALSE, FALSE, FALSE, FALSE, FALSE
```

Since a certain date/time


```r
gists(since = '2014-05-26T00:00:00Z', per_page = 2)
```

```
#> [[1]]
#> <gist>4baa80440a1e0cdb4b195872762c6251
#>   URL: https://gist.github.com/4baa80440a1e0cdb4b195872762c6251
#>   Description: Elimination (PuzzleScript Script)
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:06Z / 2019-07-18T17:39:06Z
#>   Files: readme.txt, script.txt
#>   Truncated?: FALSE, FALSE
#> 
#> [[2]]
#> <gist>9f15e4d4c5f02b56cc634c31dd9f4153
#>   URL: https://gist.github.com/9f15e4d4c5f02b56cc634c31dd9f4153
#>   Description: rubberduck v1.4.3 - Passed - Package Tests Results
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:05Z / 2019-07-18T17:39:06Z
#>   Files: 1.RegistrySnapshot.xml, FilesSnapshot.xml, Install.txt, Uninstall.txt, _Summary.md
#>   Truncated?: FALSE, FALSE, FALSE, FALSE, FALSE
```

Request different types of gists, one of public, minepublic, mineall, or starred.


```r
gists('minepublic', per_page = 2)
```

```
#> [[1]]
#> <gist>52f6dab219e0f2ca3f71cf70cafa11a3
#>   URL: https://gist.github.com/52f6dab219e0f2ca3f71cf70cafa11a3
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2019-04-24T16:38:20Z / 2019-04-24T16:38:43Z
#>   Files: crul-eg.R
#>   Truncated?: FALSE
#> 
#> [[2]]
#> <gist>79507e3c5b905f605648797d849c1126
#>   URL: https://gist.github.com/79507e3c5b905f605648797d849c1126
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2019-02-22T20:31:58Z / 2019-02-22T20:31:58Z
#>   Files: classification_munging.md
#>   Truncated?: FALSE
```


## List a single gist


```r
gist(id = 'f1403260eb92f5dfa7e1')
```

```
#> <gist>f1403260eb92f5dfa7e1
#>   URL: https://gist.github.com/f1403260eb92f5dfa7e1
#>   Description: Querying bitly from R 
#>   Public: TRUE
#>   Created/Edited: 2014-10-15T20:40:12Z / 2015-08-29T14:07:43Z
#>   Files: bitly_r.md
#>   Truncated?: FALSE
```

## Create gist

You can pass in files

First, get a file to work with


```r
stuffpath <- system.file("examples", "stuff.md", package = "gistr")
```


```r
gist_create(files = stuffpath, description = 'a new cool gist')
```


```r
gist_create(files = stuffpath, description = 'a new cool gist', browse = FALSE)
```

```
#> <gist>9984709a30889023bd79e489a7d50860
#>   URL: https://gist.github.com/9984709a30889023bd79e489a7d50860
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:09Z / 2019-07-18T17:39:09Z
#>   Files: stuff.md
#>   Truncated?: FALSE
```

Or, wrap `gist_create()` around some code in your R session/IDE, like so, with just the function name, and a `{'` at the start and a `'}` at the end.


```r
gist_create(code = {'
x <- letters
numbers <- runif(8)
numbers

[1] 0.3229318 0.5933054 0.7778408 0.3898947 0.1309717 0.7501378 0.3206379 0.3379005
'}, browse = FALSE)
```

```
#> <gist>46b8f33a29f14f7c71fc409020cd6e43
#>   URL: https://gist.github.com/46b8f33a29f14f7c71fc409020cd6e43
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:11Z / 2019-07-18T17:39:11Z
#>   Files: code.R
#>   Truncated?: FALSE
```

You can also knit an input file before posting as a gist:


```r
file <- system.file("examples", "stuff.Rmd", package = "gistr")
gist_create(file, description = 'a new cool gist', knit = TRUE)
#> <gist>4162b9c53479fbc298db
#>   URL: https://gist.github.com/4162b9c53479fbc298db
#>   Description: a new cool gist
#>   Public: TRUE
#>   Created/Edited: 2014-10-27T16:07:31Z / 2014-10-27T16:07:31Z
#>   Files: stuff.md
```

Or code blocks before (note that code blocks without knitr block demarcations will result in unexecuted code):


```r
gist_create(code = {'
x <- letters
(numbers <- runif(8))
'}, knit = TRUE)
#> <gist>ec45c396dee4aa492139
#>   URL: https://gist.github.com/ec45c396dee4aa492139
#>   Description:
#>   Public: TRUE
#>   Created/Edited: 2014-10-27T16:09:09Z / 2014-10-27T16:09:09Z
#>   Files: file81720d1ceff.md
```

## knit code from file path, code block, or gist file

knit a local file


```r
file <- system.file("examples", "stuff.Rmd", package = "gistr")
run(file, knitopts = list(quiet = TRUE)) %>% gist_create(browse = FALSE)
```

```
#> <gist>43b3e21059b86fef954eb08a3d3286ee
#>   URL: https://gist.github.com/43b3e21059b86fef954eb08a3d3286ee
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:13Z / 2019-07-18T17:39:13Z
#>   Files: stuff.md
#>   Truncated?: FALSE
```



knit a code block (`knitr` code block notation missing, do add that in) (result not shown)


```r
run({'
x <- letters
(numbers <- runif(8))
'}) %>% gist_create()
```

knit a file from a gist, has to get file first (result not shown)


```r
gists('minepublic')[[1]] %>% run() %>% update()
```

## List commits on a gist


```r
gists()[[1]] %>% commits()
```

```
#> [[1]]
#> <commit>
#>   Version: 470b3fbdf638a083ede94d7ae7fd42f0560180dd
#>   User: ereastman616
#>   Commited: 2019-07-18T17:39:13Z
#>   Commits [total, additions, deletions]: [123,123,0]
```

## Star a gist

Star


```r
gist('b564093d359eb735138a97258d03f333') %>% star()
```

```
#> <gist>b564093d359eb735138a97258d03f333
#>   URL: https://gist.github.com/b564093d359eb735138a97258d03f333
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2018-10-03T19:07:37Z / 2018-10-03T19:07:37Z
#>   Files: rcrossref-references.md
#>   Truncated?: FALSE
```

Unstar


```r
gist('b564093d359eb735138a97258d03f333') %>% unstar()
```

```
#> <gist>b564093d359eb735138a97258d03f333
#>   URL: https://gist.github.com/b564093d359eb735138a97258d03f333
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2018-10-03T19:07:37Z / 2019-07-18T17:39:15Z
#>   Files: rcrossref-references.md
#>   Truncated?: FALSE
```

## Update a gist

Add files

First, path to file


```r
file <- system.file("examples", "alm.md", package = "gistr")
```


```r
gists(what = "minepublic")[[1]] %>%
  add_files(file) %>%
  update()
```

```
#> <gist>46b8f33a29f14f7c71fc409020cd6e43
#>   URL: https://gist.github.com/46b8f33a29f14f7c71fc409020cd6e43
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:11Z / 2019-07-18T17:39:16Z
#>   Files: alm.md, code.R
#>   Truncated?: FALSE, FALSE
```

Delete files


```r
gists(what = "minepublic")[[1]] %>% 
  delete_files(file) %>%
  update()
```

```
#> <gist>46b8f33a29f14f7c71fc409020cd6e43
#>   URL: https://gist.github.com/46b8f33a29f14f7c71fc409020cd6e43
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:11Z / 2019-07-18T17:39:18Z
#>   Files: code.R
#>   Truncated?: FALSE
```

## Open a gist in your default browser


```r
gists()[[1]] %>% browse()
```

> Opens the gist in your default browser

## Get embed script


```r
gists()[[1]] %>% embed()
```

```
#> [1] "<script src=\"https://gist.github.com/ereastman616/edbc570a99738505d4eef196e4ae7cba.js\"></script>"
```

### List forks

Returns a list of `gist` objects, just like `gists()`


```r
gist(id = '1642874') %>% forks(per_page = 2)
```

```
#> [[1]]
#> <gist>1642989
#>   URL: https://gist.github.com/1642989
#>   Description: Spline Transition
#>   Public: TRUE
#>   Created/Edited: 2012-01-19T21:45:20Z / 2019-04-30T00:23:48Z
#>   Files: 
#>   Truncated?: 
#> 
#> [[2]]
#> <gist>1643051
#>   URL: https://gist.github.com/1643051
#>   Description: Line Transition (Broken)
#>   Public: TRUE
#>   Created/Edited: 2012-01-19T21:51:30Z / 2018-09-29T06:16:06Z
#>   Files: 
#>   Truncated?:
```

## Fork a gist

Returns a `gist` object


```r
g <- gists()
(forked <- g[[ sample(seq_along(g), 1) ]] %>% fork())
```

```
#> <gist>8f9f96b67c67fd4a3a6b352674f95602
#>   URL: https://gist.github.com/8f9f96b67c67fd4a3a6b352674f95602
#>   Description: 
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T17:39:22Z / 2019-07-18T17:39:22Z
#>   Files: gistfile1.txt
#>   Truncated?: FALSE
```



## Example use cases

_Working with the Mapzen Pelias geocoding API_

The API is described at [https://github.com/pelias/pelias](https://github.com/pelias/pelias), and is still in alpha they say. The steps: get data, make a gist. The data is returned from Mapzen as geojson, so all we have to do is literally push it up to GitHub gists and we're done b/c GitHub renders the map.


```r
library('httr')
base <- "http://pelias.mapzen.com/search"
res <- httr::GET(base, query = list(input = 'coffee shop', lat = 45.5, lon = -122.6))
json <- httr::content(res, "text")
gist_create(code = json, filename = "pelias_test.geojson")
#> <gist>017214637bcfeb198070
#>   URL: https://gist.github.com/017214637bcfeb198070
#>   Description:
#>   Public: TRUE
#>   Created/Edited: 2014-10-28T14:42:36Z / 2014-10-28T14:42:36Z
#>   Files: pelias_test.geojson
```

And here's that gist: [https://gist.github.com/sckott/017214637bcfeb198070](https://gist.github.com/sckott/017214637bcfeb198070)

![](img/gistr_ss.png)

_Round-trip storage of a data frame_

Maybe you want to use a gist to share some data as an alternative to `dput`? We can do this by writing our `data.frame` to a temporary buffer and passing it to `gist_create`. We can read the data back from the gist by passing its content to `read.csv`.


```r
data(iris)

str <- ''
tc  <- textConnection('str', 'w', local = TRUE)
write.csv(iris, file = tc, row.names = FALSE)
close(tc)

content <- list(content=paste(as.character(str), collapse='\n'))

gistr::gist_create(code = {
  content$content
}, description = "using a gist as a data store", 
filename = "iris.csv")
#> <gist>c7dfe593f4944df4818df884689734f9
#>   URL: https://gist.github.com/c7dfe593f4944df4818df884689734f9
#>   Description: using a gist as a data store
#>   Public: TRUE
#>   Created/Edited: 2019-07-18T14:23:23Z / 2019-07-18T14:23:23Z
#>   Files: iris.csv
#>   Truncated?: FALSE

output <- read.csv(
  text = gist(gists(what = "minepublic", per_page = 1)[[1]]$id)$
    files$iris.csv$content)

identical(output, iris)
#> TRUE
```
