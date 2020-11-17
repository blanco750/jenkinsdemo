data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "ServiceaccountSecretsManagerAccess" {
  name   = "ServiceaccountSecretsManagerAccess"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}


resource "aws_iam_policy" "ServiceaccountParameterStoreAccess" {
  name   = "ServiceaccountParameterStoreAccess"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ssm:GetParameter",
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "Serviceaccountaccesstos3" {
  name   = "Serviceaccounts3access"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role" "ServiceaccountRoleParamaetersandSecrets" {
  name        = "ServiceaccountRoleParamaetersandSecrets"
  description = "Permissions required by the Kubernetes pods to s3, Parameter Store and Secrets Manager"

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
            "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:${var.namespace}:${var.app}-kubernetes-external-secrets"
            }
        }
        }
    ]
}
ROLE
}

resource "aws_iam_role_policy_attachment" "ServiceaccountParameterStorePolicy" {
  policy_arn = aws_iam_policy.ServiceaccountParameterStoreAccess.arn
  role       = aws_iam_role.ServiceaccountRoleParamaetersandSecrets.name
}

resource "aws_iam_role_policy_attachment" "ServiceaccountSecretsManagerPolicy" {
  policy_arn = aws_iam_policy.ServiceaccountSecretsManagerAccess.arn
  role       = aws_iam_role.ServiceaccountRoleParamaetersandSecrets.name
}

resource "aws_iam_role_policy_attachment" "Serviceaccounts3Policy" {
  policy_arn = aws_iam_policy.Serviceaccountaccesstos3.arn
  role       = aws_iam_role.ServiceaccountRoleParamaetersandSecrets.name
}

# Extend the Kubernetes API by adding a ExternalSecrets object using Custom Resource Definition and a controller to implement the behavior of the object itself.
# --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"='arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.ServiceaccountRoleParamaetersandSecrets.name}'
resource "null_resource" "externalsecretsk8sobject" {

  provisioner "local-exec" {
    # working_dir = "../../demoapp/"
    command = "helm repo add external-secrets https://godaddy.github.io/kubernetes-external-secrets"
  }

  provisioner "local-exec" {
    # working_dir = "../../demoapp/"
    command = "helm install --namespace ${var.namespace} ${var.app} external-secrets/kubernetes-external-secrets --skip-crds --set securityContext.fsGroup=65534 --set env.AWS_REGION=${var.region} --set env.AWS_DEFAULT_REGION=${var.region}"
  }

  provisioner "local-exec" {
    # working_dir = "../../demoapp/"
    command = "kubectl annotate serviceaccount -n ${var.namespace} ${var.app}-kubernetes-external-secrets eks.amazonaws.com/role-arn=arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.ServiceaccountRoleParamaetersandSecrets.name}"
  }

  provisioner "local-exec" {
    # working_dir = "../../demoapp/"
    command = "kubectl delete --all pods --namespace=${var.namespace}"
  }


  depends_on = [time_sleep.wait3_10_seconds]
}
