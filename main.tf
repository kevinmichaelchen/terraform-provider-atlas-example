terraform {
  required_providers {
    atlas = {
      source  = "ariga/atlas"
      version = "~> 0.8.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "atlas" {
  dev_url = "docker://postgres/15/dev"
}

resource "docker_image" "this" {
  name         = "postgres:15"
  keep_locally = true
}

resource "docker_container" "dev" {
  name  = "devdb"
  image = docker_image.this.repo_digest
  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres",
    "POSTGRES_DB=dev",
  ]
  ports {
    external = 5433
    internal = 5432
  }
}

resource "docker_container" "prod" {
  name  = "proddb"
  image = docker_image.this.repo_digest
  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres",
    "POSTGRES_DB=prod",
  ]
  ports {
    external = 5432
    internal = 5432
  }
}

data "atlas_schema" "this" {
  depends_on = [docker_container.dev]
  src        = "file://${abspath("./schema.sql")}"
  dev_url    = "postgres://postgres:postgres@localhost:5433/dev?sslmode=disable"
}

resource "atlas_schema" "this" {
  depends_on = [docker_container.prod]
  hcl        = data.atlas_schema.this.hcl
  url        = "postgres://postgres:postgres@localhost:5432/prod?sslmode=disable"
  dev_url    = "postgres://postgres:postgres@localhost:5433/dev?sslmode=disable"
}
