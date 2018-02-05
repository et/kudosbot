WIP

# Kudosbot

Kudos bot is a way of automatically giving kudos to your friends.

## Setup


* Clone this repo
* Create a file at the root of the repo called `.env` with the following:

```
STRAVA_EMAIL=YOUR_STRAVA_EMAIL
STRAVA_PASSWORD=YOUR_STRAVA_PASSWORD
```

## Installation

```
bundle
```

## Run

```
bundle exec rackup
bundle exec sidekiq -r ./app.rb
```

## Notes

Creating an activity

```
{"aspect_type"=>"create", "event_time"=>1517462692, "object_id"=>1385765264, "object_type"=>"activity", "owner_id"=>4489804, "subscription_id"=>120864, "updates"=>{}}
```

Deleting an activity

```
{"aspect_type"=>"delete", "event_time"=>1517462715, "object_id"=>1385765264, "object_type"=>"activity", "owner_id"=>4489804, "subscription_id"=>120864, "updates"=>{}}
```

Updating an activity

```
{"aspect_type"=>"update", "event_time"=>1517462388, "object_id"=>1363900173, "object_type"=>"activity", "owner_id"=>4489804, "subscription_id"=>120864, "updates"=>{"title"=>"Avoiding the muddd"}}
```
