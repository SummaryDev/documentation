# Documentation

Documentation for [Summary](https://summary.dev) blockchain indexer.

Install mkdocs from https://www.mkdocs.org/user-guide/installation.

Edit markdown in [docs](docs) folder, add pages to [mkdocs.yml](mkdocs.yml).

Customize html in [main.html](custom_theme/main.html). Note we add more recent versions of [highlight.js](https://highlightjs.org) for GraphQL.

Build with `mkdocs build`.

Deploy to GitHub pages https://SummaryDev.github.io/documentation with `mkdocs gh-deploy`.

Build and deploy to nginx in K8S cluster by `kubectl cp` with [deploy.sh](deploy.sh).

Build and deploy with GitHub action `Build mkdocs and deploy to nginx in EKS`.
