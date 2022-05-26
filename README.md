# The MicroShift documentation

This repository contains the assets required to build the [MicroShift website and documentation](https://microshift.io/). We welcome contributions.

## Prerequisites

To use this repository, you need the following installed locally:

**NOTE:**
`make server` command will install hugo-extended binary to the current directory

- [npm](https://www.npmjs.com/)
- [Hugo (Extended version)](https://gohugo.io/)

Clone the repository and navigate to the directory:

```bash
git clone https://github.com/redhat-et/microshift-documentation.git
cd microshift-documentation
```

## Running the website locally using Hugo

```bash
npm install
# if you do want to download and use hugo-extended in current directory
make server
# or if you already have hugo-extended installed in $PATH
hugo serve
```

This will start the local Hugo server on port 1313. Open up your browser to <http://localhost:1313> to view the website. As you make changes to the source files, Hugo updates the website and forces a browser refresh.

## Get involved with MicroShift

- Join us on [Slack](https://microshift.slack.com)! ([Invite to the Slack space](https://join.slack.com/t/microshift/shared_invite/zt-uxncbjbl-XOjueb1ShNP7xfByDxNaaA))

- Community meetings are held weekly, Tuesdays at 10:30AM - 11:30AM EST.
  - [📆 Check the community calendar](https://calendar.google.com/calendar/embed?src=nj6l882mfe4d2g9nr1h7avgrcs%40group.calendar.google.com&ctz=America%2FChicago) and click `➕ Google Calendar` button in the lower right hand corner to subscribe.

## Code of conduct

Participation in the MicroShift community is governed by the [CNCF Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).

## Thank you

MicroShift welcomes community participation, and we appreciate your contributions to [MicroShift](https://github.com/openshift/microshift) and to our documentation!
