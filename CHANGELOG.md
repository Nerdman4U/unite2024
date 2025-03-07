## 2.3.0 (2025-02-02)

### Feat

- New images, css fixes
- Translations
- French translations
- Chinese translations
- Spanish translations
- English translations
- German translations
- Arabic translation

### Fix

- Layout fixes
- Mail headers fix test
- Mail headers update
- Copyright translation line fix
- Translated language version line
- Translated copyright
- Missing gettext function
- Slideshow slide captions css fixes and diashow text fixes
- Restart carousel after click navigation buttons
- **votes_controller.rb**: Show only if count is positive
- Vote count test fix

### Refactor

- Removed unused commented code

## 2.2.3 (2025-01-31)

### Fix

- **vote_count.rb**: Allow count to be zero

## 2.2.2 (2025-01-30)

### Fix

- **start.js**: Load recent votes at minute interval

## 2.2.1 (2025-01-30)

### Fix

- Render new instead redirect to serve typed form values intact
- Vote counts were added for unconfirmed votes

## 2.2.0 (2025-01-30)

### Feat

- Added test for admin primary navigation link
- Removed email addresses from appeal page
- Admin view
- Link to initiative at main navigation, color

### Fix

- **unitethearmies.js**: js wont crash on page without slideshows
- Deploy paths as environment variables
- Returned application cache

## 2.1.0 (2025-01-28)

### Feat

- Signatures at initiative
- Staging and production logs to file
- Deployment to staging, allow to use environments at workstation
- Staging deployment
- Work to have deployment to staging
- Mailer view unite layout and txt mail views
- Started to create a bit nicer mailer layout
- **Rails**: Using rails 8.0.1
- Added order to stylesheets
- Possibility to add custom css classes to flash container

### Fix

- Removed previous cache
- Flash fix to allow nested arrays
- Flash messages update
- Removed use of asset_host
- **application.scss**: Renamed back
- **comment.rb**: Using StringExtensions library

## 2.0.0 (2025-01-25)

### Feat

- **README.md**: Up to date readme file.
- **application.html.erb**: Using application cache
- **lib/string_extensions.rb**: Added emotify method to String and started to use it at flash messages

### Fix

- Slideshow container max-height cannot be full screen if instrinct height is larger than full screen

## 1.70.0 (2025-01-24)

### Feat

- Slideshow fullscreen hides footer, footer layout fixes
- Slideshow next and previous button hidden when mouse off area
- Slideshow double click bug, fixed next and previous buttons css
- Slideshow controls calibration on resize
- Slideshow update to fit images if screen width is larger
- Slideshow update, custom css classes to slides, css fixes, next and previous buttons
- Slider next and previous buttons
- **votes/new.html.erb**: Link to Initiative

## 1.69.0 (2025-01-23)

### Feat

- Slideshow fullscreen and minimize
- SVG support for slideshow

### Fix

- Slideshow settings for diashow and welcome carousel

## 1.68.0 (2025-01-22)

### Feat

- Slideshow fixes

### Fix

- Changed why vote dia texts

## 1.67.0 (2025-01-22)

### Feat

- Header earth images from America and Asia
- Why vote diashow update
- Play and pause buttons at carousel, slideshow fixes, added more informative slug for Initiative
- Mobiletests working
- Mobile navigation
- Header css fixes for mobile navigation
- **_header.html.erb**: Transparent planet earth image at header

### Fix

- **welcome/index.html.erb**: Carousel
- Flash under construction-  messages

## 1.66.0 (2025-01-18)

### Feat

- Removed old theme css, header css fixes
- Slideshow container css, headers for different medias
- Flash message item padding after marker
- Interval class, longer intervals at carousels
- Flash messages update: multiple submessages, icons and even smilie
- Video position and size

## 1.65.0 (2025-01-15)

### Feat

- Carousel images, old and new
- JS Slider decorator names

### Fix

- Carousel headers correctly

## 1.64.0 (2025-01-15)

### Feat

- Slider helper takes css classes
- Slide header text shadows
- Slider additional html, fixes welcome index voting button
- **Bootstrap-icons**: Locally

### Fix

- Welcome carousel working
- Slider html helper fix if no block was given

## 1.63.0 (2025-01-14)

### Feat

- Sliders working, new quality images
- Slider headers update
- Slider class, improved slider helper to support responsive images
- Slider refactoring, new image
- Added a bit larger landing image for resolutions max 2048w
- New informative sentence at landing top, buttons css update
- Sliders basics ok, added images with different resolutions
- Slider carusel interval working
- Testing how to change images intervally at carousel
- SlideShow proceed fixes, Carusel decorator
- Comments and load functions out fron constructors
- Slideshow Slide upgrade from data without decorator
- Slide decorators
- More work with slider js class
- Animated info divs
- Moved styles to css file
- Slider working
- Slider javascript study and update
- Initiative text border image and landing page header padding

### Fix

- Style fixes, mainly to header
- **header.html.erb**: Added missing locale parameter to link

## 1.62.0 (2025-01-08)

### Feat

- Comment confirmed_at, allowing all UI languages, show random comment at landing page
- **_head.html.erb**: Asynchronous Google fonts load
- Tests to show vote, comment and logout

### Fix

- **sitePrism-tests**: Tests are all ran with test:system and working
- **language.rb**: A small comment about last commit

## 1.61.0 (2025-01-06)

### Feat

- Language classes for UI and valid UN languages (of the letter)

## 1.60.0 (2025-01-06)

### Feat

- Route update and tests

## 1.59.0 (2025-01-05)

### Feat

- **System-tests**: Added SitePrism and some tests
- Header working better with different resolutions
- Flash message update
- Recent votes ago string update
- **votes_controller.rb**: Using scopes to find votes
- Link colors and smaller paddings
- SVG Flag icons in recent votes and votes index
- Fixed locales and added translations, se is changed to proper identifier sv

## 1.58.0 (2025-01-01)

### Feat

- Using language names instead flags in navigation

### Fix

- testfile update

## 1.57.0 (2025-01-01)

### Feat

- Rails edge \o/
- Fixed padding for welcome index bottom button area

### Fix

- **Language**: Simplified code

## 1.56.1 (2025-01-01)

### Fix

- Two bugs from previous commit fixed

## 1.56.0 (2025-01-01)

### Feat

- **footer**: Footer layout and recent votes table update
- Layout fixes
- Studying Rails configuration options
- Added user email to logs if logged in

### Fix

- **_head.html.erb**: Recent votes flag to integer

## 1.55.1 (2024-12-31)

### Fix

- **comment_test.rb**: Default locale at setup

## 1.55.0 (2024-12-31)

### Feat

- Layout update
- Check production server and print Google Analytics only at production server

## 1.54.0 (2024-12-31)

### Feat

- **Gemfile**: Ruby dependency

## 1.53.0 (2024-12-30)

### Feat

- Posting a comment, new field - anonymous - added to database
- **votes/show.html.erb**: Red heart icon
- Comments update, not yet working

### Fix

- Layout fixes. Studying how to remove core theme

## 1.52.0 (2024-12-29)

### Feat

- **application_controller.rb**: Open graph tags
- Page title update
- Add comment update, not working yet

### Fix

- **Language**: Sorted UN languages, rewritten methods
- Typos and other fixes

## 1.51.0 (2024-12-27)

### Feat

- diary
- Slides helpers, theme layout changes
- Langugea, Recaptcha and Country under lib

## 1.50.0 (2024-12-27)

### Feat

- **application_system_test_case.rb**: MobileSystemTestCase

### Fix

- Special case if vote is missing while session has logged in

## 1.49.0 (2024-12-27)

### Feat

- **header**: Added login link to header
- Notify email methods in UaSetting. Notify rake task.
- Logged_in? and logout!

### Fix

- **header**: My vote instead Login

## 1.48.0 (2024-12-26)

### Feat

- **models/vote.rb**: Four model scopes

## 1.47.0 (2024-12-26)

### Feat

- Using private and public tokens. Welcome action uses also token instead of id

### Fix

- **votes_controller_test.rb**: Needs to be logged in before invite

## 1.46.0 (2024-12-25)

### Feat

- Invite

## 1.45.0 (2024-12-25)

### Feat

- Invite using vote

## 1.44.0 (2024-12-25)

### Feat

- email_invite renamed to invite

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
