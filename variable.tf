variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "service_account_email" {
  type        = string
  description = "Service account email to run the function"
}

variable "bucket_name" {
  type        = string
  description = "GCS bucket to store function source"
}

variable "object_name" {
  type        = string
  description = "Name of the zipped function object"
}

variable "function_name" {
  type        = string
  description = "Cloud Function name"
}

variable "entry_point" {
  type        = string
  description = "Function entry point"
}

variable "runtime" {
  type        = string
  description = "Runtime for the Cloud Function"
}

variable "memory_mb" {
  type        = number
  description = "Memory allocated to the function"
}

variable "timeout" {
  type        = string
  description = "Function timeout"
}

variable "topic_name" {
  type        = string
  description = "Pub/Sub topic name"
}

variable "scheduler_job_name" {
  type        = string
  description = "Cloud Scheduler job name"
}

variable "schedule" {
  type        = string
  description = "Cron schedule for the job"
}

variable "time_zone" {
  type        = string
  description = "Time zone for the schedule"
}

variable "message_body" {
  type        = string
  description = "Payload sent to Pub/Sub from Cloud Scheduler"
}

variable "credentials_file" {
  description = "Path to the service account key JSON file"
  type        = string
}

