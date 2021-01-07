resource "aws_lb" "application-lb" {
  name               = "mattermost-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [aws_subnet.pubsub-1.id, aws_subnet.pubsub-2.id, aws_subnet.pubsub-3.id]
  tags = {
    Name = "mattermost-LB"
  }
}


#Create variable named webserver-port , type number , default 80
#Change port to variable in jenkins-sg group ingress rule which allows traffic from LB SG.

resource "aws_lb_target_group" "app-lb-tg" {
  name        = "app-lb-tg"
  port        = var.webserver-port
  target_type = "instance"
  vpc_id      = aws_vpc.mattermost.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.webserver-port
    protocol = "HTTP"
    matcher  = "200-302"
  }
  tags = {
    Name = "mattermost-target-group"
  }
}

resource "aws_lb_listener" "mattermost-listener-http" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg.id
  }
}


resource "aws_lb_target_group_attachment" "mattermost-application-attach" {
  count            = length(aws_instance.mattermost-application)
  target_group_arn = aws_lb_target_group.app-lb-tg.arn
  target_id        = aws_instance.mattermost-application[count.index].id
  port             = var.mattermost-port
}