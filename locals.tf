locals {
  common_tags = {
    Owner = local.Owner
    Name  = local.Name
    Env   = local.Env
  }
}

locals {
  Owner = "base"
  Name  = "Ugobase"
  Env   = "Development"
}