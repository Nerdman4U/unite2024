## 1.43.0 (2024-12-24)

### Feat

- Animations for headers below image
- show_link_to_vote? helper method for footer
- Button css fixes
- **_footer.html.erb**: Ruby and Rails version
- **votes/show.html.erb**: Comments column and more polished english

## 1.42.0 (2024-12-24)

### Feat

- **_header.html.erb**: Removed facebook and twitter share buttons

## 1.41.0 (2024-12-24)

### Feat

- **_share_vote.html.erb**: Styles and text

## 1.40.0 (2024-12-24)

### Feat

- **votes/show.html.erb**: More information, bootstrap styles

### Refactor

- **VotesController**: removed unused confirm email time block

## 1.39.0 (2024-12-23)

### Feat

- Deployment tasks to install and migrate
- Bootstrap icons, fixed indentation

## 1.38.0 (2024-12-23)

### Feat

- **footer**: Bootstrap icons at footer

## 1.37.0 (2024-12-23)

### Feat

- **Gemfile**: Rails 8.0.1

## 1.36.0 (2024-12-21)

### Feat

- **favicon.ico**: new favicon, the earth
- **assets**: Megacommit of assets because paths and locations did change. Removed images from public

## 1.35.0 (2024-12-19)

### Feat

- **vote_mailer**: confirm vote url as parameter

## 1.34.0 (2024-12-19)

### Feat

- **voting**: Logout. New token, show vote and logout icons. Testing header positions so that main image can be better seen
- **votes_show**: background image and header position
- **welcome_helper**: heart icon to show vote link

### Fix

- **token_controller**: token is now created create action instead of mailer view

### Refactor

- **vote**: Removed old token methods

## 1.33.0 (2024-12-18)

### Feat

- **tokens_controller**: Get vote token by email. If vote id is at session, can go back to vote from index

### Fix

- **unitethearmies.js**: Recent votes env flag check properly if zero
- **rake-tasks**: confirm already added emails working, duplicate votes are now removed again

## 1.32.0 (2024-12-17)

### Feat

- **new-vote**: Slower animation. Added sunrise image to slider and removed unused video view

## 1.31.1 (2024-12-17)

### Fix

- **votes_test**: Fixed test

## 1.31.0 (2024-12-17)

### Feat

- **Images**: new images, renamed some slides

## 1.30.0 (2024-12-17)

### Feat

- **VotesHelper**: waiting_time_left helper method to calculate offset before send new confirmation email

### Fix

- **Waiting.erb**: Better header text

## 1.29.0 (2024-12-16)

### Feat

- **Mailers**: Using "with" to pass parameters

## 1.28.0 (2024-12-16)

### Feat

- **constants**: UNITE_RUN_RECENT_VOTES from ENV. Title from constants

## 1.27.0 (2024-12-16)

### Feat

- **VoteMailer**: Confirmation email with url and waiting action test

## 1.26.0 (2024-12-14)

### Feat

- **token**: Secret token with jwt library, confirm vote working

### Fix

- **confirm-email**: letter content and unite title

## 1.25.0 (2024-12-14)

### Feat

- **votes_controller**: Confirm vote email, waiting view, system test for voting

### Fix

- **votes_controller**: Send bad request if failing

## 1.24.1 (2024-12-14)

### Fix

- **votes_controller_test**: Test for previous change
- **flash**: Proper bootstrap alert css classes

## 1.24.0 (2024-12-13)

### Feat

- **constants**: unified unite emails

## 1.23.2 (2024-12-12)

### Fix

- **overlay-menu**: removed and renamed logo id

## 1.23.1 (2024-12-12)

### Fix

- **vote-emails-to-admins**: Added mailer tests

## 1.23.0 (2024-12-12)

### Feat

- **Vote**: Multiple saves do not add vote count
- **VoteCount**: Total votes cached. Also linter made changes
- **tasks**: rake tasks and script to run all tasks when deploying first time with old data
- **Vote-counts**: Task to count votes, removed sent_count from ua_settings table and renamed send to sent

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
