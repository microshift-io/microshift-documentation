# The MicroShift documentation

This repository contains the assets required to build the [MicroShift website and documentation](https://microshift.io/). We welcome contributions.

## Prerequisites

To use this repository, you need the following installed locally:

- [npm](https://www.npmjs.com/)
- [Hugo (Extended version)](https://gohugo.io/)

Before you start, install the dependencies. Clone the repository and navigate to the directory:

```bash
git clone https://github.com/redhat-et/microshift-documentation.git
cd microshift-documentation
```

## Running the website locally using Hugo

Make sure to install the Hugo extended version.

Also, install `PostCSS` for the docs site to create the CSS assets. Install by running the following from the
root directory:

```bash
sudo npm install -D --save autoprefixer
sudo npm install -D --save postcss-cli
sudo npm install
```

To build and test the site locally, run:

```bash
make server
```

This will start the local Hugo server on port 1313. Open up your browser to <http://localhost:1313> to view the website. As you make changes to the source files, Hugo updates the website and forces a browser refresh.

## Get involved with MicroShift

- Join us on [Slack](https://microshift.slack.com)! ([Invite to the Slack space](https://join.slack.com/t/microshift/shared_invite/zt-uxncbjbl-XOjueb1ShNP7xfByDxNaaA))

- Community meetings are held weekly, Tuesdays at 10:30AM - 11:30AM EST.
  - [📆 Check the community calendar](https://calendar.google.com/calendar/embed?src=nj6l882mfe4d2g9nr1h7avgrcs%40group.calendar.google.com&ctz=America%2FChicago) and click `➕ Google Calendar` button in the lower right hand corner to subscribe.

## Code of conduct

Participation in the MicroShift community is governed by the [CNCF Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).

## Thank you

MicroShift welcomes community participation, and we appreciate your contributions to [MicroShift](https://github.com/redhat-et/microshift) and to our documentation!

## Images used on this site

Images used as background images in this site are in the [public domain](https://commons.wikimedia.org/wiki/User:Bep/gallery#Wed_Aug_01_16:16:51_CEST_2018) and can be used freely or with attributes where indicated.

The temporary flower icon is by <a href="https://upload.wikimedia.org/wikipedia/commons/7/7c/Filled_flower_sewing_pattern.svg">Jooja</a> Attribution: Jooja, CC BY-SA 3.0 <https://creativecommons.org/licenses/by-sa/3.0>, via Wikimedia Commons
