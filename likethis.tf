module "public-facing-app-cf" {
  source               = "app.terraform.io/fig-tlz/live-cloud-function-gen2/google"
  version              = "1.0.4"
  project_id           = local.project_id
  region               = var.region
  name                 = "public-facing-app"
  description          = "CF for Public Facing App"
  bucket_name          = "pfa-cf-live-bucket"
  bucket_force_destroy = true

  bucket_config = {
    lifecycle_delete_age_days = 1
  }
  bundle_config = {
    source_dir  = "./pfa"
    output_path = "pfa-cf.zip"
  }
  function_config = {
    entry_point        = "pfa_cf"
    instance_count     = 1
    memory_mb          = 256
    cpu                = "0.167"
    runtime            = "python312"
    timeout_seconds    = 300
    max_instance_count = 100
    min_instance_count = 1
  }
  service_account_create = false
  service_account        = "600829541275-compute@developer.gserviceaccount.com"
  ingress_settings       = "ALLOW_INTERNAL_ONLY"
  # label_application-name = "test-rlb-app"
  # label_description      = "test-rlb-cf"
}
