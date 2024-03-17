# 🌥️ Greysky

This is a simple web application that displays the current weather and
seven-day forecast for a give ZIP code or City, State. It caches the
results for a particular ZIP code for 30 minutes.

You can try it [here on
Heroku](https://greysky-21447b0393eb.herokuapp.com). You can either use
the search box or type in a URL like [`/forecasts/90210`](https://greysky-21447b0393eb.herokuapp.com/forecasts/90210).

## Technical details

### Tech stack

* Ruby on Rails 7.1.3 with most of the subsystems disabled as they're
  not used. For example, ActiveRecord isn't used in this app and there's
  no database.
* Ruby 3.3.0
* Bootstrap 5.3
* RSpec for testing
* [Geocodio](http://geocod.io) is used to convert the City and State to a ZIP code. It's
  also used to convert a City and State or ZIP code to a latitude and
  longitude.
* [The National Weather Service
  API](https://www.weather.gov/documentation/services-web-api) is used
  to get the current weather and forecast data.

### Commentary
 
This app is a simple example of a web application that uses a couple of web APIs and the Rails cache.

Because it's so simple, it deals with the external APIs pretty naively.
It doesn't do any real error handling, retries, and etc.  Before calling
this done, I'd want to add some eroor handling, and exploring whether
some of the calls can be done as a background worker. (There are an
awful lot of external services being accessed in a single web request!)

Again, because it's so simple, we only use Rails' in-memory cache. This
caching is local to a single process, and doesn't last between server
restarts. To make the app production-ready, we'd want to use a more
robust caching system like Memcached or Redis.

If you're interested about how the code was developed, you can follow
along [commit by
commit](https://github.com/mjbellantoni/greysky/commits).

I also spent some time upfront exploring available APIs. I used that
info to firm up the app's requirements as I saw what was available.##

## Developing

This is a standard Rails app, and is quite easy to get running.

### Prerequisites

Clone the repo:

```sh
git clone git@github.com:mjbellantoni/greysky.git
```

Install the dependencies:

```sh
bundle install
```
The app doesn't use a database, so there's no need to run migrations.

### Environment variables

You will need a Codio API key for the development environment and that
will need to be present in `GEOCODIO_API_KEY`. We're using the
[`dotenv`](https://github.com/bkeepers/dotenv) gem, so you can put the
API key in a `.env` file in the root of the project.

### Running the tests

Run the tests:

```sh
./bin/rails spec
```

Run the server:

```sh
./bin/rails server
```
You can now visit the app at [http://localhost:3000](http://localhost:3000).


## Deploying

This is a standard Rails app, so you can deploy it to Heroku or any similar service pretty easily. It does not require a database, a queueing system, or anything like that.

It make use of a couple external systems that require API keys that should be present in environment variabls.

| Service                     | Variable           | Purpose      |
|:----------------------------|:-------------------|:-------------|
| Codio                       | `GEOCODIO_API_KEY` | Geocoding    |
| [Sentry](https://sentry.io) | `SENTRY_DSN`       | Bug snagging |

The National Weather Service API doesn't require an API key.

## TODO

### Future work

Here are some things I'd want to do if I continued to push this work
forward.

* More tests. Lots more tests.
* Use Memcached or Redis for caching.
* Check for errors and rate limits from external services and retry or
  otherwise handle them gracefully.
* Explore using a background worker for the NWS API calls. We'd use a
  polling Stimulus controller or TurboStreams along with that.
* Explore other opportunities for caching.
* Add search box into the menu bar.
* Make the app work without JavaScript.
