resource "aws_security_group" "am-es-sg" {
  name        = var.es_sg
  description = "Managed by Terraform"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
}



resource "aws_elasticsearch_domain" "am-es-domain" {
  domain_name           = var.es_domain_name
  elasticsearch_version = "6.5"
  cluster_config {
    instance_type = var.instance_type
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }
  vpc_options {
    security_group_ids = [
      aws_security_group.am-es-sg.id
    ]
    subnet_ids = [
      "${lookup(var.public_subnets[0], "id")}",
    ]
  }
  access_policies = <<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Action": [
        "es:*"
      ],
        "Resource"  : "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain_name}/*"
        }
    ]
    }
POLICY
}

#Update the ES vpc end point in parameter store 

resource "aws_ssm_parameter" "es_vpccendpoint_url" {
  name  = "/fuse/ELASTICSEARCH_URL"
  type  = "String"
  value = "https://${aws_elasticsearch_domain.am-es-domain.endpoint}"
  overwrite = true
}