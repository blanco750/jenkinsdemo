# Fetch OIDC provider thumbprint for root CA.The thumbprint is a signature for the CA's certificate that was used to issue the certificate for the OIDC-compatible IdP. When you create an IAM OIDC identity provider, you are trusting identities authenticated by that IdP to have access to your AWS accoun
data "external" "thumbprint" {
    program =    ["${path.module}/oidc_thumbprint.sh", var.region]
    depends_on = [aws_eks_cluster.fuseEKScluster]
}

resource "aws_iam_openid_connect_provider" "main" {
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [data.external.thumbprint.result.thumbprint]
    url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

    lifecycle {
    ignore_changes = [thumbprint_list]
    }
}