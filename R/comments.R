#' Comment on a project on the OSF
#'
#' Provide comments on an OSF project. Please be respectful and inclusive in doing
#' so and see the Terms of Use of the OSF.
#' \url{https://github.com/CenterForOpenScience/cos.io/blob/master/TERMS_OF_USE.md}
#'
#' @param id OSF id (osf.io/XXXX; just XXXX)
#' @param txt Contents of the comment
#'
#' @return Boolean, posting succeeded?
#' @export
#'
#' @examples
#' \dontrun{comment_osf(id = '12345', txt = 'This is an example')}

comment_osf <- function(id, txt) {

  config <- get_config(TRUE)

  if (process_type(id) != "nodes") {
      stop("Currently unable to post comments to files.")
  }

  url_osf <- construct_link(sprintf("nodes/%s/comments/", id))

  # Create the JSON body
  comment <- list(
    data = list(
      type = "comments",
      attributes = list(
        content = txt),
      relationships = list(
        target = list(
          data = list(type = "nodes", id = id)
        )
      )
    )
  )

  call <- httr::POST(url = url_osf, body = comment, encode = "json", config)

  if (!call$status_code == 201) {
      stop(sprintf("Posting comment to node %s failed.", id))
    }

  return(TRUE)
}
