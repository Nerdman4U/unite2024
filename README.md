# README

<p align="center"><h1>Unite the Armies - Save the Planet needs Your help.</h1></p>

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

## Contribute

### Translate

1. Translate missing content

   At some languages there are missing translations. Translation files are located at config/locales/<name>/ and have name unite-the-armies.po. Fill in missing lines and send files to unitethearmies.org.

2. Translate new language

   Contact us.

### Code

If you have ideas how to make project amazing, contact us!

#### Commiting

Commitizen settings are at .cz.yaml.

- cz commit
- cz bump

#### Localization

- $ rake gettext:find
- Edit po files
- $ rake gettext:pack#### Tests

#### Tests

- $ rails test

#### Deployment

Environment:

- UNITE_GMAIL_USERNAME, UNITE_GMAIL_PASSWORD
- RECAPTHA_PRIVATE_KEY

- $ cap production deploy
