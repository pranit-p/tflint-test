Hello Chris

1. who updates each Service? Dev Teams or DevOps? 
   Platform security team will update each service

2. Will we canary a few services or try to enable all Services at the same time?
   We were trying to enable for all service at a same time however firstly we will deploy it on medly-dev and then goes to higher environment step by step
3. How do we rollback for a Service?
   If some incident happen and we want to do hot fix it, We will remove WAF rule using AWS console and then after some time we will remove it from terraform because empty WAF does not block any things it just like empty tunnel so we can try this scenario.
4. How specifically will we roll out WAF to a specific env? Our TF and CDKTF definitions will force us to update all envs for a Service at roughly the same time.
   We are planing to add waf in platform infra. for cloudfront distribution, you can see proxy cloudfront distribution module in platform-infra repo. [reference](https://github.com/medlypharmacy/platform-infra/tree/master/accounts/medly-dev/cloudfront_proxy)
5. For rollout and beyond, how exactly will Dev Teams and DevOps observe affects of WAF on a specific Service or Services?
   We are storing WAF logs in cloudwatch log, Dev team/DevOps team can go to cloudwatch logs in respective environment and see all logs. and also WAF provide graphical interface for how traffic goes, so people can go their and monitor traffic
6. What is the development cycle for developing custom rules?
   Right now we are focusing on AWS managed rules however in future scope, based on our security procedure we will implement custom rules as well
7. What is the Medly process for disabling WAF rules that are either too expensive or negatively affecting Services?
   We are only turn on those rules that are less expensive or will not affect negatively to our services.( In waf we have to enable rule, by default all rules are in disable state)
8. Will we have documentation oh how WAF has been implemented at Medly and how to work with WAF? Will docs be created before or after rollout?
    Yes, We will have it after rollout
9. How can we have different or additional WAF rules for different Services? Or will we just have one set for all Services? 
    we will just have one set of rules for all Services
10. Do we expect to always have WAF rule parity across envs? Could we ever see a state where prod has more rules than dev?
    Actually we treat all environments have equal priority, we decided we will have same number of rules in all environment.












Platform-security team will attach WAF to all CloudFront and api gateways, We are directly focusing on environment so we will attach WAF on dev environment for all services then Test, UAT then Prod.

, If some issue occurred with service, firstly we will remove WAF rule on that environment for unblock people then debug it with service team.
