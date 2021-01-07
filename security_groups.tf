#Create SG for bastion instance, only allowinig TCP/22
resource "aws_security_group" "bastion-sg" {

  name        = "bastion-sg"
  description = "Allow TCP/22"
  vpc_id      = aws_vpc.mattermost.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for mattermost servers
resource "aws_security_group" "mattermost-application-servers" {

  name        = "mattermost-application"
  description = "Allow TCP/80"
  vpc_id      = aws_vpc.mattermost.id
  ingress {
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow port 3306"
    from_port   = 8065
    to_port     = 8065
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 22 from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for mattermost database
resource "aws_security_group" "mattermost-database-sg" {

  name        = "mattermost-database"
  description = "Allow TCP/3306"
  vpc_id      = aws_vpc.mattermost.id
  ingress {
    description = "Allow port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for LB, only TCP/80,TCP/443 and outbound access
resource "aws_security_group" "lb-sg" {
  name        = "lb-sg"
  description = "Allow 443 and traffic to Jenkins SG"
  vpc_id      = aws_vpc.mattermost.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}