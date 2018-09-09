---
author: Andrew B. Collier
date: 2018-09-08T02:00:00Z
tags: ["spark", "aws"]
title: "Refining an AWS IAM Policy for Flintrock"
---

[Flintrock ](https://github.com/nchammas/flintrock) is a tool for launching a [Spark](https://spark.apache.org/) cluster on [AWS](https://aws.amazon.com/). To get it working initially I needed an IAM (Identity and Access Management) user with the following policies:

- `AmazonEC2FullAccess` and
- `IAMFullAccess`.

Without these I got errors like

> botocore.exceptions.ClientError: An error occurred (AccessDenied) when calling the GetInstanceProfile operation: User: arn:aws:iam::690534650866:user/datawookie is not authorized to perform: iam:GetInstanceProfile on resource: instance profile EMR_EC2_DefaultRole

and

> botocore.exceptions.ClientError: An error occurred (UnauthorizedOperation) when calling the DescribeVpcs operation: You are not authorized to perform this operation.

I'm not too fussed about the `AmazonEC2FullAccess` policy, but I'm uncomfortable with `IAMFullAccess`. Full access to IAM essentially allows the user to perform the whole gamut of possible actions relating to user management. This poses all manner of security issues.

I want to prune down the range of IAM permissions. I know that the full set of permissions associated with `IAMFullAccess` was sufficient for Flintrock, but not all of them were necessary.

As a starting point I created a new policy by cloning the `IAMFullAccess` policy. To do this, click on the Import managed policy link in the Create policy dialog. Then search for and select `IAMFullAccess`.

![](/img/2018/09/iam-create-policy-import-managed.png)

I could then replace the `IAMFullAccess` policy for the user with the newly created policy. Since it was a clone, the permissions were still sufficient to launch a Spark cluster. There are 132 individual permissions associated with the original policy. You can toggle each of these independently by clicking on Actions.

By a process of elimination I pruned the list of required permissions down to the following:

- `GetInstanceProfile` and
- `PassRole`.

Those are the necessary and sufficient IAM permissions required to launch a cluster using Flintrock.

With this information in hand it's possible to create a policy from scratch with just the required permissions.

![](/img/2018/09/iam-create-policy-specific.png)

Give this new policy a suitable name and use it in place of `IAMFullAccess`. You'll still be able to use Flintrock but without incurring any unnecessary security risks.