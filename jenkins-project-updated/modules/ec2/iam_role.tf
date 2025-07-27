resource "aws_iam_policy" "adminpolicy" {
  name = "JenkinsAdminPolicy"
  description = "admin policy for jenkins"
  policy = jsonencode({
    "Version": "2012-10-17",
  "Statement": [{
    "Sid": "Statement1",
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
  }]
  })
}

resource "aws_iam_role" "jenkinsadminrole" {
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_policy_attachment" "Jenkinsroleattachment" {
  name = "Policy attachment"
  roles = [aws_iam_role.jenkinsadminrole.name]
  policy_arn = aws_iam_policy.adminpolicy.arn
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkinsadminprofile"
  role = aws_iam_role.jenkinsadminrole.name
}