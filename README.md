Email address collector
===

Logic
---
- Search email address by regex in given URL and pages which is linked from the given URL.
- Outputs to standard output with given URL and email address in 1 row with tab separated.


Set up
---

```
% bundle install
```


Usage
---

1. Prepare list of start point URL
2. Pass the file path in the 1st parameter of the `main.rb` script.

```
% bundle exec ruby main.rb <url.txt>
```
