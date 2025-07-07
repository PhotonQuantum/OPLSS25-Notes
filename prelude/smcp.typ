#let __smcp_options = state("smcp-options", false)

#let set-smcp(simulate: false) = {
  __smcp_options.update(o => simulate)
}

#let smcp(s) = context {
  if __smcp_options.get() {
    show selector(regex("[a-z]")): el => {
      text(size: 0.8em, upper(el.text))
    }
    s
  } else {
    smallcaps(s)
  }
}

#let msmcp(s) = $upright(#text(size: 0.8em, smcp(s)))$