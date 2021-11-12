---
modified: "2021-11-03T16:23:04.174+01:00"
---

## Contributing to MicroShift Documentation

Welcome to the MicroShift project and its documentation. Please help MicroShift users and developers by contributing to this repository! You can find current documentation bugs and needs [in the issues section](https://github.com/redhat-et/microshift-documentation/issues).

### Install Hugo

If you would like to contribute to MicroShift documentation, you'll need the
extended version of Hugo. Here is information on [installing Hugo](https://gohugo.io/getting-started/installing/).

### Review Changes Locally

Hugo provides an easy way to view rendered HTML files locally. Files are rendered every time a change is made.
To run the static site generator, after installing hugo extended version:

```
hugo serve
```

The site can be previewed at `localhost:1313`.

To run and fix documentation unit tests, install and run `pre-commit`, then commit the changes.
Go here for information on [pre-commit tool](https://pre-commit.com/).

```
pre-commit run -a
```
