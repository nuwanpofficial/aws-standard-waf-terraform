resource "aws_wafv2_rule_group" "ext_rg" {
  name     = join("-", [var.environment, var.application, "primary-wafrg", var.rg_short])
  scope    = "REGIONAL"
  capacity = 20

  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.waf_rate_limit
        aggregate_key_type = "FORWARDED_IP"
        forwarded_ip_config {
          fallback_behavior = "MATCH"
          header_name       = "X-Forwarded-For"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "GEORestrictionRule"
    priority = 2

    action {
      block {}
    }

    statement {

      geo_match_statement {
        country_codes = var.block_countries
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "GEORestrictionRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BlockNmapScanRule"
    priority = 3

    action {
      block {}
    }

    statement {
      byte_match_statement {
        search_string = "nmap"
        field_to_match {
          single_header {
            name = "user-agent"
          }
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
        positional_constraint = "CONTAINS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockNmapScanRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BlockedIPsRule"
    priority = 4

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ext_block_ipset.arn
        ip_set_forwarded_ip_config {
          header_name       = "X-Forwarded-For"
          position          = "FIRST"
          fallback_behavior = "NO_MATCH"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockedIPsRule"
      sampled_requests_enabled   = true
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = join("-", [var.environment, var.application, "primary-wafrg", var.rg_short])
    sampled_requests_enabled   = true
  }
}


########  WAFv2 Blocked IPs 
resource "aws_wafv2_ip_set" "ext_block_ipset" {
  name               = join("-", [var.environment, var.application, "blockedipset", var.rg_short])
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.block_ips
}

########  WAFv2 Allowed IPs 
resource "aws_wafv2_ip_set" "ext_allow_ipset" {
  name               = join("-", [var.environment, var.application, "allowedipset", var.rg_short])
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allow_ips
}