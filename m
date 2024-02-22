Return-Path: <kvm-ppc+bounces-52-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C657085F1FB
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 08:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE022B20FFC
	for <lists+kvm-ppc@lfdr.de>; Thu, 22 Feb 2024 07:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D48290A;
	Thu, 22 Feb 2024 07:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i9PRzpNf"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E817C17995
	for <kvm-ppc@vger.kernel.org>; Thu, 22 Feb 2024 07:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708587524; cv=none; b=qWhkhJUvBjUPnJJCvbBo7mAYe+PEHLFODK4hnL9koYZU+F6IQJlXArj8PTih1Bwh5plX99EJFQEEP8KqE0MVdb79hFKy+rD8CTYAYYM1b75sddQWxvmKknWdC1/DR+gh/WyN5A120RxOR8Un5HBpIwhc8wsMsJjglRJamxtuaAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708587524; c=relaxed/simple;
	bh=FatJpgZ7yh6jAz/K9+hcZ0JcWuTaLPigjY7srK/+iR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcL78ShzLGMmu6bXLaBfy1J6si3MEa55SSrSuwmC9dNcyyb6PQ6pdiTic3cdTHHKnD4UmAjp3dh1IkDBHhipqqeAg7x7WKDl0HbDvYtYEnwXa5QdXj6oAxNe40R3FvXjHYdW85b6DaCX1NX48NqHI9P2AlQF6iVBXSnyAVsAetE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i9PRzpNf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41M71q19025870;
	Thu, 22 Feb 2024 07:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=iBXV5Uhj+q6fTB1txYSKsnZ+4XtpSrp1ctCpk6ycd48=;
 b=i9PRzpNfir4MOxHmbGV26KyZx0wCixVSA4bAAYiSbdHLuYMkCRgF2HRqfEOsVDVNhetr
 Kn3nrdypyr44h6VqY2Lc4S0epF4qSFUl2yuFD45K2I9YVvH6Oa1fJT6Gu1lQ3wltLk2a
 J4Zf96M+XHIS15bSp7kJsmzjeqwj9kKGuHtDpO/FYeQpaRsNkNWepuIkmbM9W0D0PXXX
 yIXC/z8IsGMHdjuSqSdNZ3Gz+GZ3E4zzEPQjjjT0B/xLbHxboyvFIrRdipIigQ+L6Btp
 uY1aDSvEo1PxUA0smVU3luK682jAUYjZbL74U2ZUvyV3tKw2WnWAzUwJcVrCELaB4Vur 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3we10u9p1a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 07:38:27 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41M7b4Yp018607;
	Thu, 22 Feb 2024 07:38:27 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3we10u9p0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 07:38:27 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41M6Vf9J009627;
	Thu, 22 Feb 2024 07:38:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb84pmn2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 07:38:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41M7cLx336307344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Feb 2024 07:38:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD0F120043;
	Thu, 22 Feb 2024 07:38:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A5D220040;
	Thu, 22 Feb 2024 07:38:20 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 Feb 2024 07:38:20 +0000 (GMT)
Date: Thu, 22 Feb 2024 13:08:18 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>,
        Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
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
X-Proofpoint-ORIG-GUID: ZTEtcaSc25v1jcRX7I0AmhNoVi5-FfO-
X-Proofpoint-GUID: 6DRxa-lg0rMKkNkMWXe81mnx6cL6FKEU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_05,2024-02-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 impostorscore=0
 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1011
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402220059

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
> 
Did you get time to review this simple patch ?
Is there something wrong in it or the description ?
>  // Structure words.
>  col(RESOLVE-ORIG HERE OVER CELL+ - SWAP !)
> -- 
> 2.31.1
> 

