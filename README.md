# google-cloud-ruby

Idiomatic Ruby client for [Google Cloud Platform](https://cloud.google.com/) services.

[![Travis Build Status](https://travis-ci.org/GoogleCloudPlatform/google-cloud-ruby.svg)](https://travis-ci.org/GoogleCloudPlatform/google-cloud-ruby/)
[![Coverage Status](https://img.shields.io/coveralls/GoogleCloudPlatform/google-cloud-ruby.svg)](https://coveralls.io/r/GoogleCloudPlatform/google-cloud-ruby?branch=master)
[![Gem Version](https://badge.fury.io/rb/gcloud.svg)](http://badge.fury.io/rb/gcloud)

* [Homepage](http://googlecloudplatform.github.io/google-cloud-ruby/)
* [API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs)
* [google-cloud on RubyGems](https://rubygems.org/gems/google-cloud)

## Ruby API Client library for Google Cloud

This project supports the following Google Cloud Platform services:

* [BigQuery](#bigquery)
* [Cloud Datastore](#datastore)
* [Cloud DNS](#dns)
* [Stackdriver Logging](#logging)
* [Cloud Pub/Sub](#pubsub)
* [Cloud Resource Manager](#resource-manager)
* [Cloud Storage](#storage)
* [Google Translate API](#translate)
* [Cloud Vision API](#vision)

The support for each service is distributed as a separate gem. However, for your convenience, the `google-cloud` gem lets you install the entire collection.

If you need support for other Google APIs, check out the [Google API Ruby Client library](https://github.com/google/google-api-ruby-client).

## Quick Start

```sh
$ gem install google-cloud
```

The `google-cloud` gem shown above provides all of the individual service gems in the google-cloud-ruby project, making it easy to explore Google Cloud Platform. To avoid unnecessary dependencies, you can also install the service gems independently.

### Authentication

In general, the google-cloud-ruby library uses [Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts) credentials to connect to Google Cloud services. When running on Compute Engine the credentials will be discovered automatically. When running on other environments, the Service Account credentials can be specified by providing the path to the [JSON keyfile](https://cloud.google.com/iam/docs/managing-service-account-keys) for the account (or the JSON itself) in environment variables. Additionally, Cloud SDK credentials can also be discovered automatically, but this is only recommended during development.

General instructions, environment variables, and configuration options are covered in the general [Authentication guide](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud/guides/authentication) for the `google-cloud` umbrella package. Specific instructions and environment variables for each individual service are linked from the README documents listed below for each service.

The preview examples below demonstrate how to provide the **Project ID** and **Credentials JSON file path** directly in code.

### BigQuery

- [google-cloud-bigquery README](google-cloud-bigquery/README.md)
- [google-cloud-bigquery API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-bigquery)
- [google-cloud-bigquery on RubyGems](https://rubygems.org/gems/google-cloud-bigquery)
- [Google Cloud BigQuery documentation](https://cloud.google.com/bigquery/docs)

#### Quick Start

```sh
$ gem install google-cloud-bigquery
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
bigquery = gcloud.bigquery

# Create a new table to archive todos
dataset = bigquery.dataset "my-todo-archive"
table = dataset.create_table "todos",
          name: "Todos Archive",
          description: "Archive for completed TODO records"

# Load data into the table
file = File.open "/archive/todos/completed-todos.csv"
load_job = table.load file

# Run a query for the number of completed todos by owner
count_sql = "SELECT owner, COUNT(*) AS complete_count FROM todos GROUP BY owner"
data = bigquery.query count_sql
data.each do |row|
  puts row["name"]
end
```

### Datastore

- [google-cloud-datastore README](google-cloud-datastore/README.md)
- [google-cloud-datastore API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-datastore)
- [google-cloud-datastore on RubyGems](https://rubygems.org/gems/google-cloud-datastore)
- [Google Cloud Datastore documentation](https://cloud.google.com/datastore/docs)

*Follow the [activation instructions](https://cloud.google.com/datastore/docs/activate) to use the Google Cloud Datastore API with your project.*

#### Quick Start

```sh
$ gem install google-cloud-datastore
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
datastore = gcloud.datastore

# Create a new task to demo datastore
task = datastore.entity "Task", "sampleTask" do |t|
  t["type"] = "Personal"
  t["done"] = false
  t["priority"] = 4
  t["description"] = "Learn Cloud Datastore"
end

# Save the new task
datastore.save task

# Run a query for all completed tasks
query = datastore.query("Task").
  where("done", "=", false)
tasks = datastore.run query
```

### DNS

- [google-cloud-dns README](google-cloud-dns/README.md)
- [google-cloud-dns API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-dns)
- [google-cloud-dns on RubyGems](https://rubygems.org/gems/google-cloud-dns)
- [Google Cloud DNS documentation](https://cloud.google.com/dns/docs)

#### Quick Start

```sh
$ gem install google-cloud-dns
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new
dns = gcloud.dns

# Retrieve a zone
zone = dns.zone "example-com"

# Update records in the zone
change = zone.update do |tx|
  tx.add     "www", "A",  86400, "1.2.3.4"
  tx.remove  "example.com.", "TXT"
  tx.replace "example.com.", "MX", 86400, ["10 mail1.example.com.",
                                           "20 mail2.example.com."]
  tx.modify "www.example.com.", "CNAME" do |r|
    r.ttl = 86400 # only change the TTL
  end
end

```

### Logging

- [google-cloud-logging README](google-cloud-logging/README.md)
- [google-cloud-logging API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-logging)
- [google-cloud-logging on RubyGems](https://rubygems.org/gems/google-cloud-logging)
- [Stackdriver Logging documentation](https://cloud.google.com/logging/docs/)

#### Quick Start

```sh
$ gem install google-cloud-logging
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new
logging = gcloud.logging

# List all log entries
logging.entries.each do |e|
  puts "[#{e.timestamp}] #{e.log_name} #{e.payload.inspect}"
end

# List only entries from a single log
entries = logging.entries filter: "log:syslog"

# Write a log entry
entry = logging.entry
entry.payload = "Job started."
entry.log_name = "my_app_log"
entry.resource.type = "gae_app"
entry.resource.labels[:module_id] = "1"
entry.resource.labels[:version_id] = "20150925t173233"

logging.write_entries entry
```

### Pub/Sub

- [google-cloud-pubsub README](google-cloud-pubsub/README.md)
- [google-cloud-pubsub API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-pubsub)
- [google-cloud-pubsub on RubyGems](https://rubygems.org/gems/[google-cloud-pubsub)
- [Google Cloud Pub/Sub documentation](https://cloud.google.com/pubsub/docs)

#### Quick Start

```sh
$ gem install google-cloud-pubsub
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
pubsub = gcloud.pubsub

# Retrieve a topic
topic = pubsub.topic "my-topic"

# Publish a new message
msg = topic.publish "new-message"

# Retrieve a subscription
sub = pubsub.subscription "my-topic-sub"

# Pull available messages
msgs = sub.pull
```

### Resource Manager

- [google-cloud-resource_manager README](google-cloud-resource_manager/README.md)
- [google-cloud-resource_manager API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-resource_manager)
- [google-cloud-resource_manager on RubyGems](https://rubygems.org/gems/google-cloud-resource_manager)
- [Google Cloud Resource Manager documentation](https://cloud.google.com/resource-manager/)

#### Quick Start

```sh
$ gem install google-cloud-resource_manager
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new
resource_manager = gcloud.resource_manager

# List all projects
resource_manager.projects.each do |project|
  puts projects.project_id
end

# Label a project as production
project = resource_manager.project "tokyo-rain-123"
project.update do |p|
  p.labels["env"] = "production"
end

# List only projects with the "production" label
projects = resource_manager.projects filter: "labels.env:production"
```

### Storage

- [google-cloud-storage README](google-cloud-storage/README.md)
- [google-cloud-storage API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-storage)
- [google-cloud-storage on RubyGems](https://rubygems.org/gems/google-cloud-storage)
- [Google Cloud Storage documentation](https://cloud.google.com/storage/docs)

#### Quick Start

```sh
$ gem install google-cloud-storage
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
storage = gcloud.storage

bucket = storage.bucket "task-attachments"

file = bucket.file "path/to/my-file.ext"

# Download the file to the local file system
file.download "/tasks/attachments/#{file.name}"

# Copy the file to a backup bucket
backup = storage.bucket "task-attachment-backups"
file.copy backup, file.name
```

### Translate

- [google-cloud-translate README](google-cloud-translate/README.md)
- [google-cloud-translate API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-translate)
- [google-cloud-translate on RubyGems](https://rubygems.org/gems/google-cloud-translate)
- [Google Translate documentation](https://cloud.google.com/translate/docs)

#### Quick Start

```sh
$ gem install google-cloud-translate
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new
translate = gcloud.translate

translation = translate.translate "Hello world!", to: "la"

puts translation #=> Salve mundi!

translation.from #=> "en"
translation.origin #=> "Hello world!"
translation.to #=> "la"
translation.text #=> "Salve mundi!"
```

### Vision

- [google-cloud-vision README](google-cloud-vision/README.md)
- [google-cloud-ruby-vision API documentation](http://googlecloudplatform.github.io/google-cloud-ruby/#/docs/google-cloud-vision)
- [google-cloud-vision on RubyGems](https://rubygems.org/gems/google-cloud-vision)
- [Google Cloud Vision documentation](https://cloud.google.com/vision/docs)

#### Quick Start

```sh
$ gem install google-cloud-vision
```

#### Preview

```ruby
require "google/cloud"

gcloud = Google::Cloud.new
vision = gcloud.vision

image = vision.image "path/to/landmark.jpg"

landmark = image.landmark
landmark.description #=> "Mount Rushmore"
```

## Supported Ruby Versions

google-cloud-ruby is supported on Ruby 2.0+.

## Versioning

This library follows [Semantic Versioning](http://semver.org/).

It is currently in major version zero (0.y.z), which means that anything may change at any time and the public API should not be considered stable.

## Contributing

Contributions to this library are always welcome and highly encouraged.

See [CONTRIBUTING](CONTRIBUTING.md) for more information on how to get started.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms. See [Code of Conduct](CODE_OF_CONDUCT.md) for more information.

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](LICENSE).

## Support

Please [report bugs at the project on Github](https://github.com/GoogleCloudPlatform/google-cloud-ruby/issues).
Don't hesitate to [ask questions](http://stackoverflow.com/questions/tagged/google-cloud-ruby) about the client or APIs on [StackOverflow](http://stackoverflow.com).
