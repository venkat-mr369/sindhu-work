provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project_id
  region      = var.region
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "google_pubsub_topic" "topic" {
  name = var.topic_name
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/function_source"
  output_path = "${path.module}/function_source/function.zip"
}

resource "google_storage_bucket" "function_source" {
  name          = "${var.bucket_name}-${random_id.bucket_suffix.hex}-source"
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "function_zip" {
  name   = var.object_name
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions2_function" "function" {
  name        = var.function_name
  location    = var.region
  project     = var.project_id
  description = "Cloud Function triggered by Pub/Sub"

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.function_zip.name
      }
    }
  }

  service_config {
    max_instance_count    = 1
    min_instance_count    = 0
    available_memory      = "${var.memory_mb}M"
    timeout_seconds       = tonumber(regex("\\d+", var.timeout)) # Assumes timeout like "540s"
    service_account_email = var.service_account_email
  }

  event_trigger {
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = "projects/${var.project_id}/topics/${var.topic_name}"
    trigger_region = var.region
  }
}

resource "google_cloud_scheduler_job" "job" {
  name      = var.scheduler_job_name
  schedule  = var.schedule
  time_zone = var.time_zone

  pubsub_target {
    topic_name = "projects/${var.project_id}/topics/${var.topic_name}"
    data       = base64encode(var.message_body)
  }

  region = var.region
}
