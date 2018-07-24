Ruby version: `2.3.3p222`
Rails version: `5.1.6`

To run application:
- `bundle install`
- `rake db:create`
- `rake db:migrate`
- `rake db:seed` - to create 3 products
- rename `local_env.example.yml` to `local_env.yml` under `config` directory
- put your Fakepay API key in `local_env.yml`
- and run `rails s` to start the app :)

To run tests:
- `bundle exec rspec`
- remember to call `rake db:seed RAILS_ENV=test` before!

About this app:
App contains one route resposible for creating subscriptions. Two views were added just to simplify manual testing. To create subscription we have to send `POST` request to `/api/subscriptions` with appropriate parameters. Example parameters hash:
```
{
  product: 1,
  shipping: {
    client_name: 'John Doe',
    client_address: 'Oxford Street 1, London',
    client_zip_code: '12345'
  },
  billing: {
    card_number: '4242424242424242',
    exp_month: '06',
    exp_year: '2020',
    cvv: '123',
    zip_code: '12345'
  }
}
```

Corresponding controller action:
- checks if parameters are not empty
- saves customer to database if it is valid
- creates credit card object for outer API request
- calls Fakepay API
- returns hash with either subscription object (under key `subscription`) or error_code (under key `code`)


When payment ends with success Subscription object is saved to database with a returned token and next month billing date. This token can be used for bill the customer on given billing date. A rake task was created (`subscriptions:charge`) for finding all subscriptions with given billing date (or today's date if no date was given) and it schedules jobs to charge customers. This rake task can be put in cron job to do it daily.
