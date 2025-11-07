# 호스팅 영역 생성
resource "aws_route53_zone" "route53" {
  name = "powermct.shop"
}

# ALB에 도메인 연결 (A 레코드)
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.route53.zone_id
  name    = "www.powermct.shop"
  type    = "A"

  alias {
    name                   = aws_lb.web-lb.dns_name
    zone_id                = aws_lb.web-lb.zone_id
    evaluate_target_health = true
  }
}

# 루트 도메인도 ALB로 연결
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.route53.zone_id
  name    = "powermct.shop"
  type    = "A"

  alias {
    name                   = aws_lb.web-lb.dns_name
    zone_id                = aws_lb.web-lb.zone_id
    evaluate_target_health = true
  }
}