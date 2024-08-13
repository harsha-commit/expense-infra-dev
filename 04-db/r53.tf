module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name = "db-${var.environment}"
      type = "CNAME"
      ttl  = 1
      records = [
        module.db.db_instance_address,
      ]
    },
  ]
}
