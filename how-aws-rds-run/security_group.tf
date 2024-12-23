##########################
# Security Group
##########################
resource "aws_security_group" "app" {
    name = "${local.app_name}-app-sg"
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${local.app_name}-app-sg"
    }
}

resource "aws_security_group_rule" "app_from_other_environments" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.app.id
    self = true
}

resource "aws_security_group_rule" "app_from_alb" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.app.id
    source_security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "app_to_any" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_group_id = aws_security_group.app.id
    cidr_blocks = ["0.0.0.0/0"]
}

