resource "aws_iam_policy" "EKSCloudWatchMetricsPolicy" {
    name   = "EKSCloudWatchMetricsPolicy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "EKSELBPolicy" {
    name   = "EKSELBPolicy"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeAccountAttributes"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role" "eks_cluster_role" {
    name                  = "${var.eksstackname}-eks-cluster-role"
    force_detach_policies = true

    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
        "Service": [
            "eks.amazonaws.com",
            "eks-fargate-pods.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
    }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCloudWatchMetricsPolicy" {
    policy_arn = aws_iam_policy.EKSCloudWatchMetricsPolicy.arn
    role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSCluserELBPolicy" {
    policy_arn = aws_iam_policy.EKSELBPolicy.arn
    role       = aws_iam_role.eks_cluster_role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
    role       = aws_iam_role.fargate_pod_execution_role.name
}

resource "aws_iam_role" "fargate_pod_execution_role" {
    name                  = "${var.eksstackname}-eks-fargate-pod-execution-role"
    force_detach_policies = true

    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
        "Service": [
            "eks.amazonaws.com",
            "eks-fargate-pods.amazonaws.com"
            ]
        },
        "Action": "sts:AssumeRole"
    }
    ]
}
POLICY
}
