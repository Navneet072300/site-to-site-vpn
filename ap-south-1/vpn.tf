resource "aws_vpn_gateway" "aws_site_vpn_gateway" {
  vpc_id = aws_vpc.AWS_SITE_VPC.id
  tags = {
    Name = "AWS_SITE_VPN_GATEWAY"
  }
}

resource "aws_customer_gateway" "customer_aws_site" {
  bgp_asn = 65000  # Replace with your BGP ASN if using BGP routing (optional)
  type    = "ipsec.1"
  ip_address = "52.87.224.79"  # Placeholder, replace with your actual IP
  tags = {
    Name = "Customer-AWS-SITE-Gateway"
  }
}

resource "aws_vpn_connection" "mumbai_to_virginia" {
  vpn_gateway_id      = aws_vpn_gateway.aws_site_vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_aws_site.id
  type                = "ipsec.1"  # IPSec tunnel type
  static_routes_only  = true
  
  tags = {
    Name = "Mumbai-to-Virginia-VPN"
  }
}