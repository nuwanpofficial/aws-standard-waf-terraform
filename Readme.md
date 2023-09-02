## Usage

This module is created for WAFv2 with log storage to S3 with default S3 encryption.

Default Action of the WAF is set to Allow. You can change this as needed by kindly read through the readme before doing any changes. 

Configure TF Backend details. If you are using S3 fill the sections ***provider.tf*** from line number 18 onwards. If you are using local backend comment the **backend {}** section in the ***provider.tf*** file.

If you do not need any specific rule configured in the following terraform script, kindlt comment out the ***rule{}*** section in the wafv2 resources terraform files. 

In this script S3 bucket will be using the default S3 encryption. 

**Either manage this resource through TF scripts or Manually. Otherwise inconsistancies can be occurred.**

## Modification Before Use

1) Change the line line number 55 in the ***varibles.tf*** file to your domain name after the @ sign (creator variable section).

## Variables 

Provide the values to variables used by the script in ***terraform.tfvars*** file.

| Variable Name             | Description |
|---------------            |-------------|
|environment                | Kindly provide name of the environment eg: prod/dev |
|product                    | Name of the product which the infra is used         |
|aws_region                 | AWS Region which resources are going to be deployed |
|aws_profile                | Provide AWS Credential Profile Name |
|rg_short                   | AWS Region short name eg: If us-east-1; use1 |
|application                | Application name which the infra will be used |
|project_name               | Project name which the infra will be used |
|ticket_id                  | Jira ticket ID which the infra will be used |
|creator                    | Provide the email id of the executing user |
|s3_data_retentions_days    | No of days that the s3 objects needs to be kept before deletion |
|waf_rate_limit             | No of allowed request from an IP per 5 mins time period |
|block_countries            | Provide the list of Countries that needs to be blocked |
|block_ips                  | Provide the list of IPs that needs to be blocked |
|allow_ips                  | Provide the list of IPs that needs to be allowed specifically |



## Included WAF Rules as per the Order

- Primary Rule Group
  - Rate Limit Rule
  - Geo Restriction Rule
  - Nmap Scan Block Rule
  - Blocked IPs Rule
- AWSManagedRulesAmazonIpReputationList
- AWSManagedRulesAnonymousIpList
- AWSManagedRulesBotControlRuleSet
- AWSManagedRulesCommonRuleSet
- AWSManagedRulesKnownBadInputsRuleSet
- AWSManagedRulesLinuxRuleSet
- AWSManagedRulesUnixRuleSet
- AWSManagedRulesSQLiRuleSet
- AWSManagedRulesAdminProtectionRuleSet
- Allowed IPs Rule 

***Last rule "Allowed IPs Rule" is commented by default. If you need to enable this to make this WAF a by default BLOCK WAF, change the line number 7 to block{} first.***

