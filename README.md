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
make server
```

This will start the local Hugo server on port 8080. Open up your browser to <http://localhost:8080> to view the website.
As you make changes to the source files, Hugo updates the website and forces a browser refresh.

Note: Run `make static` to generate static contents without starting a server.

## Get involved with MicroShift

- Join us on [Slack](https://microshift.slack.com)! ([Invite to the Slack space](https://join.slack.com/t/microshift/shared_invite/zt-uxncbjbl-XOjueb1ShNP7xfByDxNaaA))

## Code of conduct

Participation in the MicroShift community is governed by the [CNCF Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).

## Thank you

MicroShift welcomes community participation, and we appreciate your contributions to [MicroShift](https://github.com/openshift/microshift) and to our documentation!
