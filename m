Return-Path: <kvm-ppc+bounces-49-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B23850FBB
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Feb 2024 10:29:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AC00B22E88
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Feb 2024 09:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1F6134B9;
	Mon, 12 Feb 2024 09:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZFGJQ0E8"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB6F107B4
	for <kvm-ppc@vger.kernel.org>; Mon, 12 Feb 2024 09:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707730154; cv=none; b=KVdc0/TYrniEygjXJ0B/HXEcUtsTmt4UL5PJRnlyO58ClnJnx8ESHdEWtPtBgZc4l6JljBVQMGI1J2N5qkBjCsQiEgY3aCuQCGujuU64MyFoI+gSnFWB9L8SuDGkQBqaBcJFSqBEMtuEciniWbquF3wrusGzVf5yehN2tM7N380=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707730154; c=relaxed/simple;
	bh=JCJ77ShOHqm1BorpFrgdNQbmKw8RjkGo/9UpLrTysxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=re2BUYbgIML+ziIhZuT6k/+OWuWcota3ss0wzPUyZ7sw3rsddKufJgqg60qodUgHMtN6xxLsalbBuzeZiGU/JiUQjHdxZsUEVgRXg7+kfMMRkjB6oxCG7ER/7dueXZOvjtU++Aacm5Z8L69sSmBAGeO62DIx0Qw5NbGxoyugfBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZFGJQ0E8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41C9MMnE015413;
	Mon, 12 Feb 2024 09:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=4FNACxBRyB2a6itqOAU8h5vo7s/A5bwn23IdgDSqYGE=;
 b=ZFGJQ0E8hnHdlKqUAXgJE8jWYswwkJdOcEA016JnjUyREF/Ek5xiZZBT2by3KSlOnKMd
 KxRQIGxKbPy54zp0nF6dUvzu3j7ZiyZS9vWGh2310P9SAjLziqrT/+ySb6balQLu3jnE
 ee11xcfxp4BErIwkLCBOpO3MoN8qefXyoehnJLBxPhxWmM411HiWbaiqt0MnzXfc4jm/
 O7M4yv5CARYPFdGc2ClRfEWRy767X4SH3EtkbtuSFUJL5bwISaL1Emwkjryjg30Z0S05
 DB4fDxYG6Xkx5ejhPJGEXz7CVpc/cRXuOCZqRU8ztSPuWlVIKqL4FAwkjaEU9z88nUF/ pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w7gmvg5r6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Feb 2024 09:28:57 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41C9QQgh026578;
	Mon, 12 Feb 2024 09:28:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w7gmvg5mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Feb 2024 09:28:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41C91h0o009904;
	Mon, 12 Feb 2024 09:28:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3w6p62f6cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 Feb 2024 09:28:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41C9SoOi5964490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Feb 2024 09:28:52 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B09320040;
	Mon, 12 Feb 2024 09:28:50 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1AE72004D;
	Mon, 12 Feb 2024 09:28:48 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 12 Feb 2024 09:28:48 +0000 (GMT)
Date: Mon, 12 Feb 2024 14:58:46 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>,
        Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YDnNpxHUt9RbmeImEWej2T5Qj3v2IepE
X-Proofpoint-GUID: A-UEOvEhZSYCT3Dvee6OghxqT4bikcrg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-12_06,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 mlxlogscore=986 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402120071

Hi Segher/Thomas,

On 2024-02-02 00:15:48, Kautuk Consul wrote:
> Use the standard "DOTICK <word> COMPILE," mechanism in +COMP and -COMP
> as is being used by the rest of the compiler.
> Also use "SEMICOLON" instead of "EXIT" to compile into HERE in -COMP
> as that is more informative as it mirrors the way the col() macro defines
> a colon definition.
> 
> Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
> ---
>  slof/engine.in | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/slof/engine.in b/slof/engine.in
> index 59e82f1..fa4d82e 100644
> --- a/slof/engine.in
> +++ b/slof/engine.in
> @@ -422,8 +422,8 @@ imm(.( LIT(')') PARSE TYPE)
>  col(COMPILE R> CELL+ DUP @ COMPILE, >R)
> 
>  var(THERE 0)
> -col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
> -col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
> +col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE DOTICK DOCOL COMPILE,)
> +col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT DOTICK SEMICOLON COMPILE, THERE @ DOTO HERE COMP-BUFFER EXECUTE)

What do you think about the above changes ?
Are there any more changes I could do to this patch ?
Or if you want to reject can you tell me why exactly ?

> 
>  // Structure words.
>  col(RESOLVE-ORIG HERE OVER CELL+ - SWAP !)
> -- 
> 2.31.1
> 

