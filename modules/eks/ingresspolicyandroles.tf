provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.13"
}

# data "aws_eks_cluster" "cluster" {
#     name = var.cluster_id
# }

# data "aws_eks_cluster_auth" "cluster" {
#     name = var.cluster_id
# }

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "ALBIngressControllerIAMPolicy" {
  name   = "ALBIngressControllerIAMPolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVpcs",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "elasticloadbalancing:AddListenerCertificates",
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:CreateRule",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:DeleteListener",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:DeleteRule",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:DescribeListenerCertificates",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:DescribeSSLPolicies",
            "elasticloadbalancing:DescribeTags",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetGroupAttributes",
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:ModifyRule",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:RemoveListenerCertificates",
            "elasticloadbalancing:RemoveTags",
            "elasticloadbalancing:SetIpAddressType",
            "elasticloadbalancing:SetSecurityGroups",
            "elasticloadbalancing:SetSubnets",
            "elasticloadbalancing:SetWebACL"
        ],
        "Resource": "*"
        },
    {
        "Effect": "Allow",
        "Action": [
            "iam:CreateServiceLinkedRole",
            "iam:GetServerCertificate",
            "iam:ListServerCertificates"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "cognito-idp:DescribeUserPoolClient"
        ],
        "Resource": "*"
        },
    {
        "Effect": "Allow",
        "Action": [
            "waf-regional:GetWebACLForResource",
            "waf-regional:GetWebACL",
            "waf-regional:AssociateWebACL",
            "waf-regional:DisassociateWebACL"
        ],
        "Resource": "*"
        },
    {
        "Effect": "Allow",
        "Action": [
            "tag:GetResources",
            "tag:TagResources"
        ],
        "Resource": "*"
        },
        {
        "Effect": "Allow",
        "Action": [
            "waf:GetWebACL"
        ],
        "Resource": "*"
        },
        {
        "Effect": "Allow",
        "Action": [
        "wafv2:GetWebACL",
        "wafv2:GetWebACLForResource",
        "wafv2:AssociateWebACL",
        "wafv2:DisassociateWebACL"
    ],
    "Resource": "*"
    }
    ]
}
POLICY
}

resource "time_sleep" "wait4_20_seconds" {
  depends_on = [kubernetes_service_account.ingress]

  create_duration = "20s"
}

resource "aws_iam_role" "eks_alb_ingress_controller" {
  name        = "eks-alb-ingress-controller"
  description = "Permissions required by the Kubernetes AWS ALB Ingress controller."

  force_detach_policies = true

  assume_role_policy = <<ROLE
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
            "StringEquals": {
            "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:alb-ingress-controller"
            }
        }
        }
    ]
}
ROLE
}

resource "aws_iam_role_policy_attachment" "ALBIngressControllerIAMPolicy" {
  policy_arn = aws_iam_policy.ALBIngressControllerIAMPolicy.arn
  role       = aws_iam_role.eks_alb_ingress_controller.name
}

resource "kubernetes_cluster_role" "ingress" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "ingress" {
  metadata {
    name = "alb-ingress-controller"
    labels = {
      "app.kubernetes.io/name"       = "alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ingress.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.ingress.metadata[0].name
    namespace = kubernetes_service_account.ingress.metadata[0].namespace
  }

  depends_on = [kubernetes_cluster_role.ingress]
}