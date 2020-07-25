# AWS ASG + RDS
Create 1 auto scalling group with 1 EC2 instance, witch create table in RDS Postgres and add timestampe in it.

## Getting Started
This code create:
- 1 ASG;
- 1 EC2 instance;
- 1 RDS Postges;

## Prerequisites
Terraform, AWS account

Change file `terraform_EXAMPLE.tfvars` to `terraform.tfvars` and fill it with variables.

For deploy you need to run the commands:

## Deployment
Download providers for terraform:
```
$ terraform init
```
You could check resources that will be created:
```
$ terraform plan
```
Create resources:
```
$ terraform apply
```
Create resources with auto-approve
```
$ teraform apply --auto-approve
```
After checking resources, you could remove all resources:
```
$ terraform destroy --auto-pprove
```


## Authors
- **Alexandr Sapon** - *Initial work* - GPP

## License
This project is licensed under the MY License. You can look into my head to read it.

## Acknowledgments

**"He who is not courageous enough to take risks will accomplish nothing in life."** (*Muhammad Ali*)

**"Genius is one percent inspiration and ninety-nine percent perspiration"** (*Thomas A. Edison*)