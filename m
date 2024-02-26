Return-Path: <kvm-ppc+bounces-62-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D102D866A5C
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 07:59:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BB91281357
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 06:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D7F1B951;
	Mon, 26 Feb 2024 06:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UFyBFm5K"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BEE1B7FF
	for <kvm-ppc@vger.kernel.org>; Mon, 26 Feb 2024 06:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708930780; cv=none; b=cE8qz99g4W1XxXm5DpAQifLjh0Yvlyc1TbwsbfoKV6v3OD1zgu5jKqpizbYQxaY5kstPGLLfgSbNcEzjVw9eIgeqr5+BQL5phzLiUVBBbK0nabpBREDtSYkqKEVouNJ0Gy8zoURAbml2rYXXhKfwgcvTDkSf3jRFtupDi1bv/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708930780; c=relaxed/simple;
	bh=QMCvTUVy/3Gk+bE2eUrvKi6JG9MgSlLTmBO+9S2laKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QiKi5lJRDBGrUc24rVo73V9XIVtvjDSbAowq2ase9eRVWUWmZHq++qes9KtBXOuWZ4X3DoibsYkIACKY2J3UEBbuNeX+Is4Z4KLph6Om04UvdBldzlu5tfjI+vkA6l13HN0QzLOdeED+RJ7D+Hm70sLJ87Osj1sx69R3aViiKb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UFyBFm5K; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q67SQV024809;
	Mon, 26 Feb 2024 06:59:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=QMCvTUVy/3Gk+bE2eUrvKi6JG9MgSlLTmBO+9S2laKI=;
 b=UFyBFm5KLccdIL5m7UW18lGDqpGs6TdYvQQ3qxDJnuiZtYr46m1bVPguxS1Ich+Wg35c
 0bPh68aG98NBFxs1vSlpywRRww8rAb1kSp4A6JJwGW4CSl2WNCZziqjmfbRpJJYPQ7wl
 YSEmlt3sB2Za6OkPGjvWg8nIGfDg0bnAimZZaAslE/uqccdfMeT+ddxQkJgHX2v4P+QE
 NHr7CXQULKyIih42/j0MrUHeoqqWvq+Pc3Tx7BO94y52bU2UmT8nmqS9zJ0Y7U9RPn48
 tXUq0gdD+NnvTdWgO0JMi8GFCMTJyQPZS++B3SXtnK6xQThdYA4XC8vzZwkqrQKSz9Nu bA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgh2gw4n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 06:59:26 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41Q6skle006847;
	Mon, 26 Feb 2024 06:59:25 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgh2gw4mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 06:59:25 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q5iGul021316;
	Mon, 26 Feb 2024 06:59:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wfusnqbrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 06:59:24 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41Q6xKpx65929648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 06:59:22 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AF6C2004E;
	Mon, 26 Feb 2024 06:59:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2AC82004D;
	Mon, 26 Feb 2024 06:59:18 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 Feb 2024 06:59:18 +0000 (GMT)
Date: Mon, 26 Feb 2024 12:29:16 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <Zdw2xPr5CLwgHAb4@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
 <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zdg0O/67vQIip7hN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223210456.GP19790@gate.crashing.org>
 <ZdwUc96KRsrKrd9c@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZdwXBJNBMOr/SvaP@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zdw0FhF2u5UHnPe6@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zdw0FhF2u5UHnPe6@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P70yiuErIdt-QlibapXkMRDtr3LdcZ6R
X-Proofpoint-GUID: soTSZn9fAbJMEKemKaV1Iky-a6nSjI5O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_03,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=631
 suspectscore=0 impostorscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402260051

One change:

On 2024-02-26 12:17:54, Kautuk Consul wrote:
> One strange thing I noticed is that when I copy paste the same IF-THEN
> or IF2-THEN2 lines below the ones that I already have in my OF.fs, the
> timebase seems to keep reducing for some strange reason. The number of
> IF-THEN and IF2-THEN2 statements are the exact same.

It seems it is not a good idea to put the before patch and after patch
statements together as the timebase difference keeps decreasing. So then
I ran the VM once with the "BEFORE-PATCH" and "AFTER-PATCH" changes and
I find that for 45 lines of IF-THEN and IF2-THEN2 the performance
improvement is aroung 35 microseconds only. Per IF-THEN pair then the
improvement is only in nanoseconds.

