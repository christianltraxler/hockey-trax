provider "google" {
  project = var.project_id
  region  = "northamerica-northeast2"
  zone    = "northamerica-northeast2-a"
}

resource "google_sql_database" "database" {
  name     = "postgres-sql-database"
  instance = google_sql_database_instance.instance.name
}

# See versions at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version
resource "google_sql_database_instance" "instance" {
  name             = "postgres-sql-instance"
  region           = var.region
  project   = var.project_id
  database_version = var.db_version
  settings {
    tier = var.instance_type

    disk_autoresize = lookup(var.disk, "autoresize", true)
    disk_type = lookup(var.disk, "type", "PD_SSD")
    disk_size = lookup(var.disk, "size", 10)

    dynamic "ip_configuration" {
      for_each = [var.ip_configuration]
      content {

        ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", true)
        private_network = lookup(ip_configuration.value, "private_network", null)
        require_ssl     = lookup(ip_configuration.value, "require_ssl", null)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }
      }
    }
  }

  deletion_protection  = "true"
}

resource "google_sql_user" "default" {
  name     = var.user_name
  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  password = var.user_password
}