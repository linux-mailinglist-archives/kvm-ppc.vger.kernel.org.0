Return-Path: <kvm-ppc+bounces-146-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FF893CDCD
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jul 2024 07:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 811BB1F21898
	for <lists+kvm-ppc@lfdr.de>; Fri, 26 Jul 2024 05:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8D0155300;
	Fri, 26 Jul 2024 05:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LkGSmevw"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8224154C10;
	Fri, 26 Jul 2024 05:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721973003; cv=none; b=FWp2kA90Jb9XwaYvK+hKimUIgCUJqoHhR5SLJ4V7z2f8XyY7WMzzNpQ0GTxfZ7r4PR1866M945ihAP+M/wtL5Zmtb76SZVlSsDj85glV6u/0434vnkxO84utboGZgGc9L2fNjPvNY41WWCe2GeNILEouSDbvITtczfGEnkopE3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721973003; c=relaxed/simple;
	bh=1RSV4wLf77v5OYCZydF77u28YwpEi2UycxOjfiDnplk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CUrDpts6YhcFeZpeRwcUCq8m5oZWk3mq3s+zJTojHh3C49GeagvfbmJH1BILOP36NCxG3Z3xDb/PpKyGlYP2lJyy0NX1U8vlfOO2+q3k+10I6od74SoxFAkh8PqfDaqK/c9R2qJhn5Yr+9pWVYBuKTZhDzPa9ETMFht+REtLuDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LkGSmevw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46Q4USqh026158;
	Fri, 26 Jul 2024 05:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=/pL0JuAfruxg3LvJnxZHYB3JtXD
	cvdoee0Ej2lHdXwk=; b=LkGSmevwhm0aRHK+a9IJNrdqPoCeWWN1eHXuDHS7waf
	GOcy3/xFTSbTwj69u2JTvZbqSpWKw92YuNTLaFfAEFVJSBEIDFE/JFlyvHCzRfqq
	ncpROR4EKtzZNoXx+c6+Ijir3OhAifaABsQ3ejG+2iVWZglnNmUcu3pIf23gqDyQ
	+0S6deZMi73ur/rZ8Ep9pAoNNXF71+TabWMDqssPyEghDm9TXJJhXQ2MhXbbmq0E
	EHK/EoQeyYQaiCqc80haNKrtJzriNYZ8ND8NxzkbOC0H9kC9eawgKlUVYEa4njtf
	HV1wrG3F2O5clA9cJxK1vCIz6OaZyul0rOZ0nFnYosw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40m3g009m6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 05:49:46 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46Q5nkSE024488;
	Fri, 26 Jul 2024 05:49:46 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40m3g009m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 05:49:46 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46Q52p6l018513;
	Fri, 26 Jul 2024 05:49:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40kk3hmh6q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 05:49:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46Q5ndtG50332122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 05:49:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BDC720043;
	Fri, 26 Jul 2024 05:49:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05D0120040;
	Fri, 26 Jul 2024 05:49:36 +0000 (GMT)
Received: from li-e7e2bd4c-2dae-11b2-a85c-bfd29497117c.ibm.com (unknown [9.124.219.245])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 26 Jul 2024 05:49:35 +0000 (GMT)
Date: Fri, 26 Jul 2024 11:19:31 +0530
From: Amit Machhiwal <amachhiw@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Lizhi Hou <lizhi.hou@amd.com>, Rob Herring <robh@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Saravana Kannan <saravanak@google.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>,
        Kowshik Jois B S <kowsjois@linux.ibm.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH v2] PCI: Fix crash during pci_dev hot-unplug on pseries
 KVM guest
Message-ID: <dx32q3sa4oopk3fnm2zyeplotuq6gq3rmnbmaw3mo4q3lgjpe7@gvpgu4rdk4f4>
Mail-Followup-To: Bjorn Helgaas <helgaas@kernel.org>, 
	Lizhi Hou <lizhi.hou@amd.com>, Rob Herring <robh@kernel.org>, linux-pci@vger.kernel.org, 
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-ppc@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, 
	Saravana Kannan <saravanak@google.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Vaidyanathan Srinivasan <svaidy@linux.ibm.com>, Kowshik Jois B S <kowsjois@linux.ibm.com>, 
	Lukas Wunner <lukas@wunner.de>
References: <p6cs4fxzistpyqkc5bv2sb76inrw7fterocdcu3snnyjpqydbr@thxna6v2umrl>
 <20240725205537.GA858788@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725205537.GA858788@bhelgaas>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hrWbadeSvvg3pthFD6dbebsK6nYnlI9I
X-Proofpoint-ORIG-GUID: TUS0qhJ3TBEy9O6kA7xiLL7ZbyW2NSJ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_02,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 mlxlogscore=671 priorityscore=1501
 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2407260036

Hi Bjorn,

On 2024/07/25 03:55 PM, Bjorn Helgaas wrote:
> On Thu, Jul 25, 2024 at 11:15:39PM +0530, Amit Machhiwal wrote:
> > ...
> > The crash in question is a critical issue that we would want to have
> > a fix for soon. And while this is still being figured out, is it
> > okay to go with the fix I proposed in the V1 of this patch?
> 
> v6.10 has been released already, and it will be a couple months before
> the v6.11 release.
> 
> It looks like the regression is 407d1a51921e, which appeared in v6.6,
> almost a year ago, so it's fairly old.
> 
> What target are you thinking about for the V1 patch?  I guess if we
> add it as a v6.11 post-merge window fix, it might get backported to
> stable kernels before v6.11?  

Yes, I think we can go ahead with taking V1 patch for v6.11 post-merge window to
fix the current bug and ask Ubuntu to pick it while Lizhi's proposed patch goes
under test and review.

Thanks,
Amit

