<h1 style="text-align:center">Hello there amazing person!</h1>

[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

# Table of Contents.

1. What is <span style="color:orange">Save the Planet - Unite the Armies</span>.
2. How to Participate?
3. Instuctions.
4. Run your own <span style="color:orange">Save the Planet - Unite the Armies</span> server.
5. Credits.

## 1. What is <span style="color:orange">Save the Planet - Unite the Armies</span>.

This is a web service for collecting votes in support of our <a href="http://unitethearmies.org/en/initiative_presented_to_the_united_nations_to_save_the_world_by_redeploying_armed_forces_of_the_world" target="_blank">Initiative</a> to <b style="color:orange">SAVE THE PLANET!</b>

## 2. How to Participate?

Get involved with <span style="color:orange">Save the Planet - Unite the Armies</span> in a variety of ways:

<dl>
<dt><b>Visit our site</b></dt>
<dd>Its here: <a href="http://unitethearmies.org" target="_blank">http://unitethearmies.org</a>.</dd>

<dt><b>Cast your vote!</b></dt>
<dd>Read the <a href="http://unitethearmies.org/en/initiative_presented_to_the_united_nations_to_save_the_world_by_redeploying_armed_forces_of_the_world" target="_blank">Initiative</a> and Vote for it \o/ It will be sent to United Nations when it has million votes or more!</dd>

<dt><b>Translate</b></dt>
<dd>If you can translate english to other language, feel free to do so. Instuctions below.</dd>

<dt><b>Install & Develop</b></dt>
<dd>Contribute your skills and expertise to help drive the initiative forward.</dd>

<dt><b>Run your own service!</b></dt>
<dd>Rent space and start collecting votes at your neighborhood.</dd>

<dt><b>Social media</b></dt>
<dd>Spread the word on social media.</dd>

</dl>

## 3. Instructions.

This repository is found at https://github.com/Nerdman4U/unite2024.

### 3.1 Translate.

Note: We are moving to use AI on translations.

1. Locate the translation file.

   /config/locales/&lt;language-identifier&gt;/unite-the-armies.po

   That is the file!

2. Download

   Click "Download raw file" in Github.

3. Translate

   Open the file with your favourite text editor and write translations.

   At translation file translations are shown as (example from finnish file):

   msgid "Name"
   msgstr "Nimi"

   msgid contains native and msgstr contains translation.

   If native contains variables, include them in translation!

   Example:

   msgid "Greetings %{name}!"
   msgstr "Tervehdys %{name}!"

   %{name} is a variable where name in time is added.

4. Send translated file to us

   You can send it to me, info@jonitoyryla.eu

### 3.2 Install.

You need ruby 3.3.6. Install Ruby version manager and run $ rvm install 3.3.6

Then should work just by:

1. Get the code

   $ git clone git@github.com:Nerdman4U/unite2024.git
   (or preferably fork and clone)

2. Install libraries

   $ bundle install

3. Create database

   install mysql server and create databases.

   $ sudo apt install mysql-server

   $ rails db:create:all

4. Create tables

   $ rake db:migrate

5. Environment

   Add variables (below)

6. Start rails server

   $ rails s

7. If you have problems

   Let me know: info@jonitoyryla.eu

#### 3.2.1 Environment

- UNITE_GMAIL_USERNAME=my.gmail.username (Gmail account)
- UNITE_GOOGLE_APP_PASSWORD=stringoftext (You get this from Google, for username above)
- UNITE_RUN_RECENT_VOTES=1 (or 0, do you want show recent votes at footer)
- UNITE_DEPLOY_PATH_STAGING=path.to.folder
- UNITE_DEPLOY_PATH_PRODUCTION=path.to.other.folder

### 3.3 Start developing.

We're looking for a talented developers to join develop future versions of <span style="color:orange">Save the World - Unite the Armies</span>. Are you interested in collaborating with us?

#### Commiting.

Commitizen settings are at .cz.yaml.

- cz commit
- cz bump

#### Localization.

- $ rake gettext:find
- Edit po files
- $ rake gettext:pack

#### Tests.

Using Capybara, Cuprite and SitePrism.

Javascript tests are currently missing.

#### Deployment.

Currently with Capistrano.

- $ cap production deploy

## 4. Run your own <span style="color:orange">Save the Planet - Unite the Armies</span> server.

Feel free to install and deploy this service as your own.

- You need a way to host your service. It maybe PaaS like Heroku or virtual/dedicated private server.
- Then you need to reserve a domain name, i.e. unitethearmies.ru.

In future versions, <span style="color:orange">Save the Planet - Unite the Armies</span> services will be able to share data and display votes from multiple servers, enabling a unified and global view of the initiative's progress.

## 5. Credits.

Thank you for images and other support.

### Theme.

Based on Sartre Skin Barber Shop by ThemeMountain.

### Images.

<dl>
<dt>United Nations, Ourworldindata.org</dt>
<dd>

https://ourworldindata.org/population-growth

</dd>
</dl>

https://pixabay.com/photos/earth-planet-space-world-11008/

https://pixabay.com/photos/forest-trees-fir-trees-woods-6874717/

https://pixabay.com/photos/monkeys-infant-forest-fire-fear-4273153/

https://pixabay.com/photos/trash-trash-land-trash-dump-4897847/

https://pixabay.com/photos/mining-coal-industry-energy-4838141/

https://pixabay.com/photos/characters-crowd-model-train-4273081/

https://pixabay.com/illustrations/person-silhouettes-people-540262/

https://pixabay.com/photos/vancouver-british-columbia-canada-216595/

https://pixabay.com/illustrations/earth-world-planet-globe-1303628/

<dl>
<dt>JanBrzezinski</dt>
<dd>

https://pixabay.com/photos/winter-trail-forest-trees-wintry-5644263/

</dd>
</dl>

<dl>
<dt>Pexels</dt>
<dd>

https://pixabay.com/photos/cosmos-milky-way-stars-night-sky-1866820/

</dd>
</dl>

<dl>
<dt>StockSnap</dt>
<dd>

https://pixabay.com/photos/constellations-galaxy-stars-sky-2609647/

</dd>
</dl>

<dl>
<dt>TheOtherKev:</dt>
<dd>

https://pixabay.com/photos/woodland-forest-moss-sunset-8479979/

</dd>
</dl>

<dl>
<dt>Danganhfoto:</dt>
<dd>

https://pixabay.com/photos/seascape-landscape-beach-coast-4844697/

</dd>
</dl>

<dl>
<dt>WikiImages:</dt>
<dd>

https://pixabay.com/photos/earth-blue-planet-erball-earth-rise-11005/

https://pixabay.com/photos/earth-globe-planet-world-space-11015/

</dd>

https://pixabay.com/photos/tickseed-coreopsis-calliopsis-2729137/

https://pixabay.com/photos/wildlife-park-poing-wolf-2646376/

https://pixabay.com/users/vieleineinerhuelle-18495/

https://pixabay.com/users/jamesdemers-3416/

<dl>
<dt>kuviasuomesta.fi: Roine Piirainen</dt>
<dd>Snowy landspace from Koli, finland. Also duckboard picture at new vote.</dd>
</dl>
