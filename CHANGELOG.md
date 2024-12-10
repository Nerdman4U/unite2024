## 1.22.0 (2024-12-10)

### Feat

- **flash**: Close flash on click

## 1.21.1 (2024-12-09)

### Fix

- **footer**: Remove Googleplus icon

## 1.21.0 (2024-12-09)

### Feat

- **Show-vote**: Bootstrap cols and proper color variables
- **Views**: Bootstrap cols and updated styles
- **views**: Bootstrap cols, votes list with bootstrap cols
- **theme.core**: Unminified and removed troublesome before settings on rows
- **views**: Added bootstrap 5 col-x css selectors
- **footer**: copyright, css fixes, removed overlay navigation partial

### Fix

- **votes-list**: bootstrap cols
- **appeal**: columns fixed
- **header**: Added missing element properties for to make header background change

## 1.20.0 (2024-12-03)

### Feat

- **downloads**: download material is now stored locally

## 1.19.0 (2024-12-03)

### Feat

- **locales-and-captcha**: default locales, tests, private method for captcha
- **VoteCount**: target vote count rised to million

## 1.18.0 (2024-12-03)

### Feat

- **new-vote**: some error messages fixed
- **locales**: gettext find and pack

## 1.17.0 (2024-12-03)

### Feat

- **config**: I18n default locales, fast gettext locale, removed social share buttons and humanizer gems

## 1.16.0 (2024-12-03)

### Feat

- **votes_controller**: only confirmed votes listed at recent votes
- **vote**: Secret confirm hash tests, some problems with fixtures
- **renamed-a-variable**: Email confirmation renamed to email_repeat, linter also found something
- **confirm_emails.rake**: Set current votes confirmed with current timestamp
- **debugger**: Debugger support for vscode and smtp working production mode
- **test.rb**: Hopefully not anymore sending emails when running mailer tests
- **test**: some tests updated, some commented out
- **vote**: confirm vote with confirmation email from given address, not yet working
- **application.rb**: SMTP settings
- **Vote**: Confirm email address used to vote
- **votes_controller**: Emails confirmation fix and spam flag

### Fix

- **recaptcha**: working now
- **VoteMailer**: linting and removed extra variable
- **votes_controller**: recent votes wont list spam and duplicates are marked as spam instead destroyed
- **email-invite**: repeat email when send invite from show vote
- **fix.rake**: using ruby 1.9 syntax
- **test**: fixed config used in test file
- **admin**: admin hash to environment, using unite- namespace at config, fixed domain for development/production
- **constants**: production mode domain
- **application.rb**: Google app password
- **vote**: Check that email is typed two times correctly
- **deploy.rb**: Stage and rails_env

### Refactor

- **tests**: Updating tests, not working

## 1.15.0 (2024-11-22)

### Feat

- **rake-task**: new rake task to load comments
- **social-share-buttons**: Added social share button gem back and remove capistrano gems
- **capistrano**: capistrano bundler

### Fix

- **capistrano**: removed capistrano-rails

## 1.14.0 (2024-11-22)

### Feat

- **test/system**: System tests and test before deployment

## 1.13.0 (2024-11-22)

### Feat

- **_flags.html.erb**: Force use http instead of https currently

## 1.12.0 (2024-11-21)

### Feat

- **config**: disabled cache using database

### Fix

- **database**: missing migration files

## 1.11.0 (2024-11-21)

### Feat

- **config**: Reading backup email from environment

## 1.10.1 (2024-11-21)

### Fix

- **constants.rb**: Constant to allow javascript load votes

## 1.10.0 (2024-11-21)

### Feat

- **Commitizen**: Yay! Commitizen is installed \o/
