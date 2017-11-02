# Web Application

This application is experimental, and as such not intended for any particular use. Different ways of integrating a backend Rails web application with ReactJS client-side frontend are investigated.

As application, although it may be used as a starting point for a real world setup, it matches no particular operational needs in its current state.


## Features

 - ReactJS web frontend
 - Rails web backend


## Presentation

This application contains three branches demonstrating different features:

 - single_public_component - Frontend here is one integrated ReactJS application, incorporating login and application data presentation. The Rails backend serves as an API for authentication and data retrieval.

 - single_controlled_component - Login is rendered server-side (Rails), with a ReactJS frontend for presentation once user is authenticated. The Rails backend serves as an API data retrieval.

 - dual_controlled_component - Frontend is handled as two separate ReactJS applications, one for login and the other for data presentation once logged in. The Rails backend serves as an API for authentication and data retrieval.

Why would one want to split up ReactJS application into several disjoint component packages?

Having everything in one component served from a public directory (single_public_component) is the easiest to implement. It also allows a neat separation of concerns (different developers) between frontend and backend.

However, although data access is restricted by the backend API, the frontend component structure loads immediately and without authentication. This may not always be desirable. At the cost of meddling backend and frontend slightly (and the service worker redirect problem noted below), frontend components can be protected by backend authentication.

The last option, dual_controlled_component, while retaining protection of (internal) components by backend authentication, is closer to the separation of concerns as with all frontend in one single ReactJS package.

Thus joining two frontend packages via backend may seem over-complicated and contrived. That may well be the case. But - albeit being somewhat esoteric, it does present a way to "reactify" any already existing application:

 - Identify a part that would benefit from less server interaction, and run better on client (browser) side.
 - Create the ReactJS component(s).
 - Devise the (REST + JSON, typically) API towards the backend.
 - Integrate into application's work-flow.


# Installation

## Prerequisites

 - Ruby
 - Rubygems
 - Bundle
 - nodejs
 - npm

Server side was tested and verified on Linux 3.16.0 (Debian 8.9) during Oct 2017 using:

 - ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-linux]
 - Rubygems 2.6.6
 - Bundler version 1.13.1
 - Nodejs v6.11.4
 - Npm 3.10.10


Client side was tested and verified with Chromium 57.0.2987.98 (64-bit) and Firefox 56.0 (64-bit) during October 2017.


## Download

Download from GitHub repository:

 - 'git clone -b single_public_component https://github.com/per-garden/webapp.git'.

 - 'git clone -b single_controlled_component https://github.com/per-garden/webapp.git'.

 - 'git clone -b dual_controlled_component https://github.com/per-garden/webapp.git'.



# Frontend Setup

## Packages

From directory as created by git clone, go to web_frontend (or ext_frontend, int_frontend respectively for dual_controlled_component). Then type:

 - npm install


## Application Configuration

Adapt file `config.json` to your specific application instance. The URL for clients (web browsers) to use when retrieving data is set here.


## Application build

Make sure you are positioned in directory web_frontend (or ext_frontend, int_frontend respectively for dual_controlled_component). Then type:

 - npm run build


# Backend Setup

## Gems

From directory as created by git clone, go web_backend. Then type:

 - bundle install


## Setting up data

Initiate the database(s):

 - bundle exec rake db:migrate

There are currently no tasks to set up actual backend data. From directory web_backend use the rails console to add e.g.:

```html
$ rails c
Running via Spring preloader in process 7378
Loading development environment (Rails 5.1.4)
irb(main):001:0> Hub.create(name: 'Diap')
   (0.1ms)  begin transaction
  SQL (4.0ms)  INSERT INTO "hubs" ("name", "created_at", "updated_at") VALUES (?, ?, ?)  [["name", "Diap"], ["created_at", "2017-10-31 14:55:03.436355"], ["updated_at", "2017-10-31 14:55:03.436355"]]
   (17.0ms)  commit transaction
=> #<Hub id: 4, name: "Diap", created_at: "2017-10-31 14:55:03", updated_at: "2017-10-31 14:55:03">
irb(main):002:0>
```


## User Management

In order for users to be able to log in, at least one account needs to be set up.

There are two tasks to respectively add and delete individual users. From directory web_frontend do:

 - bundle exec rake add_user 'name' 'email' 'password' (e.g. bundle exec rake add_user 'Kalle Kula' 'kalle.kula@kula.org' 'qwerty123')

 - bundle exec rake delete_user 'name|email' (e.g. bundle exec rake delete_user 'kalle.kula@kula.org')


## Assets

Frontend is served to client (web browser) via the backend server. There are two tasks to set up (effectively just copying files) frontend assets and components to backend:

 - `rake npm:deploy` copies components and assets to the required backend locations

 - `rake npm:undeploy` clears backend locations of frontend assets and components. File names will vary between npm builds, so use this command to remove obsolete files, before deploying new frontend.


# Usage

Be positioned in the web_backend directory. Then start rails server:

 - `rails s`

Now access the application at e.g. 'http://my_host.my_domain:3000' (For local testing this will be 'http://localhost:3000')


# Tests

The application web_backend uses rspec for testing (presumes `rake npm:deploy` having been run):

 - bundle exec rspec spec

There should be no errors reported.


# Known Issues and Future Work

The three branches of the application are intended for demonstation and experimental purposes only. Focus is on integrating frontend and backend. Although fully working, both frontend design and data model are mere sketches.

Within the integrational scope, the most crucial open work items are:

 - Token rewrite and expiry. The same single token is used throughout complete session, and token never expires.
 - By letting client-side keep track of session id too, server-side could verify token without having to search all existing tokens.
 - Service worker precache does not work properly with backend redirects. There must be a better way of handling this than server stating `501 - Not implemented`.


# Licence

Copyright 2017 Per Gärdén per.garden@avaloninnovation.com

MIT licence. See separate licence file for details, or visit https://opensource.org/licenses/MIT
