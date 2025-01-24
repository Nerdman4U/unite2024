# README

<p align="center"><h1>Unite the Armies - Save the Planet needs Your help.</h1></p>

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

## Install

Should work just:
$ git clone / fork this repository
$ bundle install
$ (add environment variables)
$ rails s

### Environment

UNITE_GOOGLE_APP_PASSWORD (from Google)
UNITE_GMAIL_USERNAME (Gmail account used to send email)
UNITE_RUN_RECENT_VOTES (1 or 0)
UNITE_ADMIN_HASH (not in use, any string)

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
- $ rake gettext:pack

#### Tests

- $ rails test

#### Deployment

- $ cap production deploy

## Thanks!

### Pixabay

- vieleineinerhuelle
- Wolfgang65
- JamesDeMers
- many others!

### kuviasuomesta.fi

- Roine Piirainen
