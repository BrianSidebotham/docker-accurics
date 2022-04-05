# Accurics CI Tooling

This repo contains the accurics Infrastructure as Code (IaC) scan tooling for Vulnerability Management of various IaC components.

It can be used as the basis for scanning during CI in order to fail builds that have vulnerabilities that exceed some threshold or configuration.

The tools included in the image are `accurics` cli tool and `terrascan`. Using this is CI can be done by running something like:

```
./accurics_linux scan -mode=pipeline -appurl=https://cloud.tenable.com/cns -token=${ACCURICS_TOKEN}
```

# Usage in Gitlab

In a Gitlab CI workflow you can use this container within an IaC repository like so:

> **NOTE:** This example uses Gitlab CI/CD variables to hold the accurics credentials in a config file

**.gitlab-ci.yml**
```
variables:
  ACCURICS_CONFIG: ${ACCURICS_CONFIG}

stages:
  - test

default:
  image: ghcr.io/briansidebotham/accurics-terrascan:latest
  tags:
    - docker
  before_script:
    - 'echo "Accurics: $(accurics version)"'
    - 'echo "Terrascan: $(terrascan version)"'

scan-code:
  stage: test
  artifacts:
    when: always
    paths:
      - accurics_report.html
      - accurics_report.json
  script:
    - cd ${CI_PROJECT_DIR} && echo "${ACCURICS_CONFIG}" > accurics.conf
    - accurics scan -mode=pipeline -config accurics.conf
```

Where accurics token will be the token value required to upload data.
