#IAM POLICY FOR IAM ROLE
resource "aws_iam_policy" "s3fullaccess" {
  name = "s3fullaccess"
  policy = jsonencode(
    {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
  )
}



#Creates an IAM role and allows ec2 instances to assume the role
resource "aws_iam_role" "ec2s3fullaccess" {
  name = "ec2s3fullaccess"
  assume_role_policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
}
  )
  tags = {
    Name = "utciams3fullaccess"
  }
}


#Attaches the policy to the role
resource "aws_iam_role_policy_attachment" "iam_role_attachment" {
  role = aws_iam_role.ec2s3fullaccess.name
  policy_arn = aws_iam_policy.s3fullaccess.arn
}

#Attaches the role to the webapp instances
resource "aws_iam_instance_profile" "webappprofile" {
  name = "webappprofile"
  role = aws_iam_role.ec2s3fullaccess.name
}