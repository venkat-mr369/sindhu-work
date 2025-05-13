# Terraform Module for Cloud Function with Pub/Sub and Scheduler to automate the SQLbackups

This Terraform module creates a Google Cloud Function that is triggered by a Pub/Sub topic and integrates with Cloud Scheduler. It also provisions necessary resources like a Pub/Sub topic, a storage bucket for the function source, and a Cloud Scheduler job.

## Features

- Creates a Pub/Sub topic.
- Creates a Cloud Storage bucket to store the source code for the Cloud Function.
- Deploys a Cloud Function with customizable runtime, memory, and timeout settings.
- Configures the Cloud Function to be triggered by a Pub/Sub topic.
- Schedules the Cloud Function using Cloud Scheduler to publish messages to the Pub/Sub topic.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Contributing](#contributing)
- [License](#license)

---

## Prerequisites

- Terraform 1.0 or newer installed.
- Google Cloud SDK installed and authenticated.
- A GCP project with necessary permissions to create the following resources:
  - Pub/Sub Topics
  - Cloud Storage Buckets
  - Cloud Functions
  - Cloud Scheduler Jobs

---

## Usage

### Example Configuration

Below is an example of how to use this module in your Terraform configuration:

```bash
module "cloud_function_with_pubsub" {
  source = "./path-to-this-module"

  project_id             = "my-gcp-project-id"
  region                 = "us-central1"
  service_account_email  = "my-service-account@my-gcp-project-id.iam.gserviceaccount.com"
  bucket_name            = "my-function-source-bucket"
  object_name            = "function.zip"
  function_name          = "my-cloud-function"
  entry_point            = "main"
  runtime                = "nodejs16"
  memory_mb              = 256
  timeout                = "540s"
  scheduler_job_name     = "my-scheduler-job"
  schedule               = "*/5 * * * *"
  time_zone              = "America/Los_Angeles"
  message                = "Hello from Cloud Scheduler"
  topic_name             = "my-pubsub-topic"
  event_type             = "google.cloud.pubsub.topic.v1.messagePublished"
  bucket_suffix_byte_length = 4
  max_instance_count     = 5
  min_instance_count     = 1
  retry_policy           = "RETRY_POLICY_RETRY"
  instance_id            = "my-cloud-sql-instance"
  ingress_settings       = "ALLOW_ALL"
}
```

### Steps:
1. *Initialize Terraform*:
   bash
   terraform init
   

2. *Validate the Configuration*:
   bash
   terraform validate
   

3. *Apply the Configuration*:
   bash
   terraform apply
   

---

## Inputs

| Name                       | Type   | Description                                                                 | Default              |
|----------------------------|--------|-----------------------------------------------------------------------------|----------------------|
| project_id               | string | The GCP project ID.                                                        | n/a (required)       |
| region                   | string | The region where resources will be created.                                | n/a (required)       |
| service_account_email    | string | The email of the service account to be used for the Cloud Function.         | n/a (required)       |
| bucket_name              | string | The base name of the Cloud Storage bucket.                                  | n/a (required)       |
| object_name              | string | The name of the zipped function object.                                    | n/a (required)       |
| function_name            | string | The name of the Cloud Function.                                            | n/a (required)       |
| entry_point              | string | The entry point for the Cloud Function.                                    | n/a (required)       |
| runtime                  | string | The runtime for the Cloud Function (e.g., nodejs16).                     | n/a (required)       |
| memory_mb                | number | The memory allocated to the Cloud Function in MB.                          | n/a (required)       |
| timeout                  | string | The timeout for the Cloud Function (e.g., 540s).                         | n/a (required)       |
| scheduler_job_name       | string | The name of the Cloud Scheduler job.                                       | n/a (required)       |
| schedule                 | string | The cron schedule for the Cloud Scheduler job.                             | n/a (required)       |
| time_zone                | string | The time zone for the Cloud Scheduler job.                                 | n/a (required)       |
| message                  | string | The payload sent to Pub/Sub when the scheduler triggers.                   | n/a (required)       |
| event_type               | string | The type of event that triggers the Cloud Function.                        | n/a (required)       |
| bucket_suffix_byte_length| number | The number of random bytes to generate for the bucket name suffix.         | 4                  |
| max_instance_count       | number | The maximum number of instances for the Cloud Function.                    | n/a (required)       |
| min_instance_count       | number | The minimum number of instances for the Cloud Function.                    | n/a (required)       |
| retry_policy             | string | The retry policy for the Cloud Function's event trigger.                   | n/a (required)       |
| instance_id              | string | The ID of the Cloud SQL instance to be included in the Pub/Sub message.    | n/a (required)       |
| ingress_settings         | string | The ingress settings for the Cloud Function.                               | ALLOW_ALL          |
| topic_name               | string | The name of the Pub/Sub topic.                                             | n/a (required)       |

---

## Outputs

| Name           | Description                                                                   |
|----------------|-------------------------------------------------------------------------------|
| topic_name   | The name of the Pub/Sub topic created by the module.                         |
| function_url | The name of the Cloud Function created by the module (URL is not provided).  |

---

## Contributing

Contributions are welcome! Please fork the repository, create a branch, and submit a pull request.

---

## License

This project is licensed under the MIT License.
