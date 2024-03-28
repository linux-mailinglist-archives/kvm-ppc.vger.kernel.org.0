Return-Path: <kvm-ppc+bounces-81-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BE888F678
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 05:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91AA61F26158
	for <lists+kvm-ppc@lfdr.de>; Thu, 28 Mar 2024 04:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB3820DF7;
	Thu, 28 Mar 2024 04:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cTD2uVHs"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E335E28E6
	for <kvm-ppc@vger.kernel.org>; Thu, 28 Mar 2024 04:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600780; cv=none; b=QBIwyLxeqhdotJS4Cxg2vA+JqbDGVmlvy0LksO/fx4pP57HceZMdW6Jnr08lTaI74fDbbwZC61Ma04u91JnSp0mTiJZ4Q7l79LpcxwYsmzkSUH6Uu3Q7M++zri2TRx5reElxLEHAnhmmcaihtCrUs8fptRoF82E9bqP8ag5zMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600780; c=relaxed/simple;
	bh=g4lrxzTzK5VGmxBfPTmXJOAJ60GxZMGWpxMmybAU3Ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XeWCUtLRrN111PYJY8xMPAY8/Um+v35bs0PTgQfCpo6xgBJqX7Ak5vLTJdFoc/YpQ/YrrSm5e1mmY7Sc4HNbQN96GZ4DlCvYCA59KCod0dz34UDl56X4mO4S/cghBN6tWR+G0d7fiV/x6Xvi4LXAh89gLK1UcLz4UYIm3m764Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cTD2uVHs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42S4T4AV011541;
	Thu, 28 Mar 2024 04:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=f5SYGIUHjFBgaTtljLm/AjSco3TBj42Cqjgd9Q/exN8=;
 b=cTD2uVHsHGvFLSYKJ8wwLlE6SuAOXSG/ufctmhX8Xv2mZG9ySniUVsxpRolc6GDR3upC
 3cakbsvw+3TquvS1uCgj+0FCFSpSThNLUljyWMHMmO0bVSLCbOgunUDvmLYgn+ktAanh
 Sa3quTTLFSDhTkdKQ2tvsn1wrJaXzGtsGCA0UMBMVIDph6J/+IzQOL5OtbXOBgSDNnkx
 BpplCZ5VCf1hSjdrSiStf8aFIsqqXTr03wOhPuw0KYKi75XzhzwmMyB/rbJ2GoMt0g8r
 eaTythU+/ZRhoEn3B+GZ7sy9UO7vjRxg3Z4nMZZgWmZwq1iEBOm8ch9FDt5PGWKrhFyT Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x516182se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 04:39:30 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42S4dTb7028811;
	Thu, 28 Mar 2024 04:39:29 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x516182sb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 04:39:29 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42S3fNxc013358;
	Thu, 28 Mar 2024 04:39:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x29t0uf0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Mar 2024 04:39:28 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42S4dOtY47972696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Mar 2024 04:39:26 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 286072004B;
	Thu, 28 Mar 2024 04:39:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E504E2004D;
	Thu, 28 Mar 2024 04:39:22 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 28 Mar 2024 04:39:22 +0000 (GMT)
Date: Thu, 28 Mar 2024 10:09:20 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v3] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <ZgT0eCsT8SEiHV2Y@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240327054127.633598-1-kconsul@linux.ibm.com>
 <20240327134325.GF19790@gate.crashing.org>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327134325.GF19790@gate.crashing.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4jFBOJ2dGm24iIUonUkWU_seFGl-XyNE
X-Proofpoint-GUID: XhJCFRhWT-z8I9_S4HzsdZPJDDd0MP9V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-28_03,2024-03-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403280025

Hi!

On 2024-03-27 08:43:25, Segher Boessenkool wrote:
> Hi!
> 
> On Wed, Mar 27, 2024 at 01:41:27AM -0400, Kautuk Consul wrote:
> > -\ read sector to array "block"
> > -: read-sector ( sector-number -- )
> > +\ read sector to array "block" and return actual bytes read
> > +: read-sector-ret ( sector-number -- actual-bytes )
> 
> What does "-ret" mean?  The name could be clearer.
> 
> Why factor it like this, anyway?  Shouldn't "read" always read exactly
> the number of bytes it is asked to?  So, "read-sector" should always
> read exactly one sector, never more, never less.
Okay I just thought to return the bytes actually read from that 1 sector
so that I could do some checking in the subroutines calling read-sector.

> 
> If an exception happens you can (should!) throw an exception.  Which
> you can then catch at a pretty high level.
Ah, correct. Thanks for the suggestion! I think I will now try to throw
an exception from read-sector if all the code-paths imply that a "catch"
is in progress. I will try to make some change like this and send out a
v4 whenever I have time.
> 
> 
> Segher

