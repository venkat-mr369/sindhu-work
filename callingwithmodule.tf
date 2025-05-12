module "cloud_sql_backup" {
  source               = "../path-to-parent-module" # Update this to the relative path of your parent module
  project_id           = "your-project-id"
  region               = "us-central1"
  pubsub_topic_name    = "test-backup-pubsub-message-topic"
  bucket_suffix_byte_length = 4
  bucket_location      = "us-central1"
  cloud_function_name  = "test-process-pubsub-message"
  cloud_function_location = "us-central1"
  cloud_function_description = "Test Cloud Function triggered by Pub/Sub"
  runtime              = "python310"
  entry_point          = "process_pubsub_message"
  max_instance_count   = 1
  min_instance_count   = 0
  available_memory     = "256M"
  timeout_seconds      = 540
  service_account_email = "test-svc-account@your-project-id.iam.gserviceaccount.com"
  ingress_settings     = "ALLOW_INTERNAL_ONLY"
  event_type           = "google.cloud.pubsub.topic.v1.messagePublished"
  trigger_region       = "us-central1"
  retry_policy         = "RETRY_POLICY_RETRY"
  scheduler_job_name   = "test-backup-trigger-job"
  schedule             = "*/30 * * * *"
  time_zone            = "Asia/Kolkata"
  scheduler_message    = "Testing Cloud Scheduler job"
  instance_id          = "test-instance-id"
  scheduler_job_region = "us-central1"
}
