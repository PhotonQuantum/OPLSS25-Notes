
#import "@preview/shiroa:0.2.3": *

#show: book

#book-meta(
  title: "shiroa",
  summary: [
    #prefix-chapter("src/paige.typ")[Notes for _Introduction to Category Theory_]
  ]
)

// re-export page template
// #import "/templates/page.typ": project
// #let book-page = project