terraform {
  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.3.0"
    }
  }
}

locals {
  paths = toset(distinct(flatten([for _, v in fileset(path.module, "./main-folder/**") : regex("main-folder/([-0-9A-Za-z]+).", "${dirname(v)}/")])))
}

output paths {
  value=local.paths
}

data "archive_file" "zip" {
  for_each    = local.paths
  type        = "zip"
  source_dir  = "${path.module}/main-folder/${each.key}"
  output_path = "${path.module}/zips/${each.key}.zip"
}

