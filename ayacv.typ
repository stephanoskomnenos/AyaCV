// 简历的样式和排版组件。
#import "@preview/booticons:0.0.1": bsicon
#let colors = (
  purple: rgb("#8054cc"), blue: rgb("#3873b3"), black: black,
  burgundy: rgb("#980000"), green: rgb("#59b34d"), grey: rgb("#555555"),
  orange: rgb("#f28c26"), red: rgb("#f23333"),
)

// 默认字号、颜色和间距。
// 在 resume.typ 的 style 中填写同名参数，即可修改对应设置。
#let default-style = (
  page-margin: (x: 10%, top: 25mm, bottom: 10%),
  body-size: 11pt, small-size: 10pt,
  name-size: 25pt, section-size: 14.5pt, intent-size: 12pt,
  leading: 8.5pt, tracking: 0pt, word-spacing: 100%,
  section-above: 19pt,
  section-below: 10.5pt, rule-gap: 5pt, rule-width: 0.35pt,
  entry-gap: 9pt, row-gap: 8pt, body-gap: 7.5pt, entry-text-height: 0.75em,
  simple-body-gap: 9pt, table-row-gap: 8pt,
  list-top-gap: 3pt, list-row-gap: 7.5pt, list-body-indent: 7.5pt,
  marker-radius: 1.8pt, marker-stroke: 0.65pt, marker-baseline: 1pt,
  double-top-gap: 4pt, double-body-indent: 4pt,
  contact-gap: 8.5pt, extra-gap: 8.5pt, intent-gap: 13pt,
  contact-icon-size: 11pt, contact-icon-baseline: 1pt, contact-icon-gap: 0.25em,
  phone-icon: "phone", email-icon: "envelope",
  header-color: rgb("#777777"), title-color: rgb("#888888"),
  header-name-gap: 0.12em, contact-separator-gap: 0.7em, column-gap: 1em,
)
#let settings = state("ayacv-settings", default-style)
#let emphasis-font-state = state("ayacv-emphasis-font", ("Libertinus Serif", "AR PL UKai"))

#let kai(body) = context text(font: emphasis-font-state.get(), body)
#let date(body) = {
  set text(style: "italic")
  show regex("\\p{Han}+"): it => kai(text(style: "normal", it))
  body
}

// 联系方式：图标名称、显示内容和可选链接。
#let contact(icon, body, href: none) = (icon: icon, body: body, href: href)

#let ayacv(
  body,
  name: none, title: none, phone: none, email: none, extra: none, intent: none,
  phone-label: [手机:], email-label: [邮箱:], contacts: (),
  color: "purple",
  font: ("Libertinus Serif", "Source Han Serif"),
  emphasis-font: ("Libertinus Serif", "AR PL UKai"),
  paper: "a4",
  style: (:),
) = {
  assert(name != none, message: "请在 resume.typ 中设置 name")
  let s = default-style + style
  s += (
    page-margin: default-style.page-margin + s.page-margin,
  )
  let contact-items = ()
  if phone != none { contact-items.push(contact(s.phone-icon, [#phone-label #phone])) }
  if email != none { contact-items.push(contact(s.email-icon, [#email-label #email], href: "mailto:" + email)) }
  contact-items += contacts
  let accent = if type(color) == str { colors.at(color) } else { color }
  set document(title: name + if title == none { "" } else { " – " + title }, author: name)
  set page(paper, margin: s.page-margin, numbering: none)
  set text(font: font, size: s.body-size, lang: "zh", region: "CN", fill: black,
    tracking: s.tracking, spacing: s.word-spacing,
    top-edge: "cap-height", bottom-edge: "baseline")
  set par(justify: true, leading: s.leading, spacing: 0pt)
  set block(spacing: 0pt)
  set list(
    marker: box(baseline: s.marker-baseline, circle(radius: s.marker-radius, stroke: s.marker-stroke + accent)),
    indent: 0pt, body-indent: s.list-body-indent, tight: false, spacing: s.list-row-gap,
  )
  show heading.where(level: 1): it => context {
    block(above: s.section-above, below: s.section-below, sticky: true,
      stack(dir: ttb, spacing: s.rule-gap,
        text(size: s.section-size, weight: "bold", fill: accent, it.body),
        line(length: 100%, stroke: s.rule-width + accent),
      ),
    )
  }
  settings.update(s)
  emphasis-font-state.update(emphasis-font)
  align(center)[
    #text(size: s.name-size, weight: "bold", fill: accent, name)
    #if title != none [#h(s.header-name-gap)#text(size: s.name-size, fill: s.title-color)[| #title]]
    #if contact-items.len() > 0 [
      #v(s.contact-gap)
      #text(fill: s.header-color)[
        #for (index, item) in contact-items.enumerate() {
          if index > 0 [#h(s.contact-separator-gap) • #h(s.contact-separator-gap)]
          bsicon(item.icon, height: s.contact-icon-size, color: s.header-color, baseline: s.contact-icon-baseline)
          h(s.contact-icon-gap)
          if item.href == none { item.body } else { link(item.href, item.body) }
        }
      ]
    ]
    #if extra != none [#v(s.extra-gap)#text(fill: s.header-color, extra)]
    #if intent != none [#v(s.intent-gap)#text(size: s.intent-size, fill: accent, kai(intent))]
  ]
  body
}

// 完整经历：第一行放标题和标签，第二行放说明和日期。日期可省略。
#let entry(title, role, when: none, degree: none, detail: none, body: none, items: ()) = context {
  let s = settings.get()
  block(above: s.entry-gap)[
    #block(breakable: false)[
      #set text(top-edge: s.entry-text-height)
      #grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
        column-gutter: s.column-gap, row-gutter: s.row-gap,
        strong(title), strong(role),
        ..if degree == none and when == none { () } else {
          (
            if degree == none { [] } else { kai(if detail == none { degree } else { [#degree, #detail] }) },
            if when == none { [] } else { date(when) },
          )
        },
      )
    ]
    #if body != none [#v(s.body-gap)#text(size: s.small-size, body)]
    #if items.len() > 0 [
      #v(s.body-gap + s.list-top-gap)
      #text(size: s.small-size, list(..items))
    ]
  ]
}

// 简洁经历：一行标题和日期，下接正文。
#let simple-entry(title, body, when: none) = context {
  let s = settings.get()
  block(above: s.entry-gap)[
    #block(breakable: false)[
      #set text(top-edge: s.entry-text-height)
      #grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
        column-gutter: s.column-gap,
        strong(title),
        if when == none { [] } else { date(when) })
    ]
    #v(s.simple-body-gap)
    #text(size: s.small-size, body)
  ]
}

// 左右对齐的条目列表，每项填写（内容，日期或来源）。
#let dated-items(..items) = context {
  let s = settings.get()
  set text(top-edge: s.entry-text-height)
  grid(columns: (1fr, auto), align: (left + bottom, right + bottom),
    column-gutter: s.column-gap, row-gutter: s.table-row-gap,
    ..items.pos().map(item => (item.at(0), kai(item.at(1)))).flatten(),
  )
}

// 两栏列表，每栏放一项内容。
#let double-item(left, right) = context {
  let s = settings.get()
  v(s.double-top-gap)
  set list(body-indent: s.double-body-indent)
  grid(columns: (1fr, 1fr), column-gutter: s.column-gap, list(left), list(right))
}
