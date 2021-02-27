---
layout: default
title: Child Title
parent: Parent Title
has_children: true
---
# Child Title

This is a child page. A parent page must have `has_children: true` in the front matter (triple-dashed section above), and the child pages must have `parent: [title of parent]` in the front matter. If the child has grand-children pages, it must also have `has_children: true`.
