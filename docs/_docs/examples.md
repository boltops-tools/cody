---
title: Examples
---

<ul>
  {% assign docs = site.docs | where: "categories","example" %} {% for doc in docs -%}
  <li><a href='{{doc.url}}'>{{doc.nav_text}}</a></li>
  {% endfor %}
</ul>