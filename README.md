# README

URL Shortener MVP

## Features

### Free Users
- Allows users to shorten a long url
- When a user access the shortened url, he/she will be redirected to the long url
- The short code generated uses the following line of code:
> SecureRandom.urlsafe_base64 5

### Paid Users
- Paid users are manually set by setting the user field "paid" to true
- Paid users can create custom links for its counterpart long url
- Paid users can view all their custom links with the number of visits for each link

### Admin Users
- Admin users are manually set by setting the user field "admin" to true
- Admin users can access the admin page
- Admin page shows the list of all urls, their max allowed clicks, expiry date, and link to more details
- The details page shows the visit records for the url and a form to set the max clicks and expiry
- The details page also includes the delete button to permanently delete the url
- Max clicks is the allowed maximum visits for the url, once reached the url is expired
- Expiry date is the date the url expires
- If an expired url is accessed, the expired page is shown

## Getting Started

### Prerequisites
- Docker >= 19.03.8
- Docker Compose >= 1.25.5

### Setup

Copy environment variables
> cp docker_env.example .env

Build image and run
> docker-compose up --build

Create database, execute migration, and seed
> docker exec url-shortener_app_1 rake db:create db:migrate db:seed

You can now access the app at
> http://localhost:3000

Sample login credentials for admin and paid users can be found in seeds.rb
> db/seeds.rb

### Test

- docker exec url-shortener_app_1 rake db:create db:migrate RAILS_ENV=test
- docker exec url-shortener_app_1 rake TEST=test/integration/shorten_url_flow_test.rb RAILS_ENV=test
- docker exec url-shortener_app_1 rake TEST=test/models/url_test.rb RAILS_ENV=test

## Improvements

### Use modern front-end framework

Using Rails views has become cumbersome after working for quite sometime with several front-end frameworks like Backbone, Vue, and React.  It would be easier to just use Rails API and then use a Javascript framework like Vue, React, or Angular to handle the front-end.  Using a separate front-end framework will also make it easier to maintain.  Other options that can be used to handle backend are Django, Node.js, Spring Boot.

### Integration test

I created one integration test for the core functionality of shortening a long url and redirecting once the short url is accessed.  However, I encountered some issues with Rails test.  First is when running the test with RAILS_ENV=test, some Javascript files installed through a gem are not detected.  Second is when running the test without RAILS_ENV, the User table rows are deleted (Only this table is deleted even if it is not used in the test).

Maybe using React and its testing library is a better option.

### Add scheduled job

Add scheduled job that expires urls based on their expiry date. This will run at 12:00 AM everyday.

### Benchmark

Used:
- https://github.com/wg/wrk
- https://www.digitalocean.com/community/tutorials/how-to-benchmark-http-latency-with-wrk-on-ubuntu-14-04#step-3-—-install-wrk

> wrk -t2 -c5 -d30s [short url]

#### Before adding index to short code:

Average at around 565 requests in 30 seconds.

Run 1:
572 requests in 30.06s, 377.05KB read
Requests/sec:     19.03
Transfer/sec:     12.54KB

Run 2:
569 requests in 30.05s, 375.07KB read
Requests/sec:     18.94
Transfer/sec:     12.48KB

Run 3:
535 requests in 30.09s, 352.66KB read
Requests/sec:     17.78
Transfer/sec:     11.72KB

Run 4:
577 requests in 30.02s, 380.35KB read
Requests/sec:     19.22
Transfer/sec:     12.67KB

Run 5:
575 requests in 30.10s, 379.03KB read
Requests/sec:     19.10
Transfer/sec:     12.59KB

#### After adding index to short_code:

Average at around 633 requests in 30 seconds. (12% increase)

Run 1:
623 requests in 30.09s, 410.67KB read
Requests/sec:     20.71
Transfer/sec:     13.65KB

Run 2:
628 requests in 30.02s, 413.96KB read
Requests/sec:     20.92
Transfer/sec:     13.79KB

Run 3:
646 requests in 30.09s, 425.83KB read
Requests/sec:     21.47
Transfer/sec:     14.15KB

Run 4:
642 requests in 30.09s, 423.19KB read
Requests/sec:     21.34
Transfer/sec:     14.07KB

Run 5:
630 requests in 30.10s, 415.28KB read
Requests/sec:     20.93
Transfer/sec:     13.80KB

### Address edge case scenarios

### Use redis to cache frequently accessed links
