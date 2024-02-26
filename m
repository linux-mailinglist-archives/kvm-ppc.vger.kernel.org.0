Return-Path: <kvm-ppc+bounces-61-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F71866A43
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 07:48:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94F9B1C21CE4
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 06:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7285179B2;
	Mon, 26 Feb 2024 06:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aAzZQP3b"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB231BF2A
	for <kvm-ppc@vger.kernel.org>; Mon, 26 Feb 2024 06:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708930096; cv=none; b=U6L+OzKxbNp5bGgPTucbyMQBTwepxq15fNdp6xnSThGZ1CU27+hAJk+xSOSytXGH9BMh6yliTXO8hliC+xz3LK/lhA1l4c5nIqc1MWsjQG1H6Lty0/d+O+AczAM9oIwqcSK7uyZa7W91xE8XeTFXg9dw62RfEoy1qIKMlC2kUMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708930096; c=relaxed/simple;
	bh=NQn38FH+ewpm02BqQCxomDSaFF84blmz0svOu0KnDRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOwV3loJt9JfhuqbUdbqVUZzB/LnHAy2pemQLthvhFX6AuIPOlpDGOnMQowNaE2yEpwqFjVVMHAZySpdzyWV/wOY7XcYhQsf7kldhrM4Yfh/stp93KGZXD+ScXemrzyhUha55TWeMMQ0LIVYU8NoWZYhL79AEKeGSI8a/4z9EUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aAzZQP3b; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q4TsnI026281;
	Mon, 26 Feb 2024 06:48:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=yG/EcXeY8XbAr8FejMMzkoYiorZDTpVvL9GKvIf1sYg=;
 b=aAzZQP3b4rRG6kgNhimzBLByBlwk/AwdTvxYqq3zNnyfz7m1myChui5RKs6jyrjcEjaK
 po+eCX1ERfDD9POV+/bFhH08SYMMNaQMHWALow3ouC/YIj7vcKXbC/o0f2t6Wkem0Zxs
 ZRbHYyFUtywJuowJhXj0MjVnveKKT1ZsD7gEKC++n/g0+21z0fonqxPpXHlUSG4YXcR2
 S1pWlyithpOlS6a0C/TbkLPHRtnqWahDptWh52d25kUdzO4PI21XnOjP+JASWz7QVrgx
 M8h3w812qfctcbJA06m5Q3L8BL/B+npOP1geTCKse4ofUw7zZgC+685O0UvAfT1IoymO Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgdvufym7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 06:47:59 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41Q6jTxF013961;
	Mon, 26 Feb 2024 06:47:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgdvufykv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 06:47:59 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q57JIP021792;
	Mon, 26 Feb 2024 06:47:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wfu5yqfp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 06:47:58 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41Q6lsfa43123180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 06:47:56 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5232A2004E;
	Mon, 26 Feb 2024 06:47:54 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F27162004B;
	Mon, 26 Feb 2024 06:47:52 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 Feb 2024 06:47:52 +0000 (GMT)
Date: Mon, 26 Feb 2024 12:17:50 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <Zdw0FhF2u5UHnPe6@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
 <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zdg0O/67vQIip7hN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223210456.GP19790@gate.crashing.org>
 <ZdwUc96KRsrKrd9c@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZdwXBJNBMOr/SvaP@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdwXBJNBMOr/SvaP@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cQcSChGBe1h1ROsfN2UcNAY1gbUSB0Le
X-Proofpoint-ORIG-GUID: KjLfvjf4bmQy2vT0rE6ILKofM1PXb2wo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_03,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015 adultscore=0
 mlxlogscore=326 bulkscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2402260050

On 2024-02-26 10:13:52, Kautuk Consul wrote:
> Hi Thomas,
> 
> On 2024-02-26 10:02:55, Kautuk Consul wrote:
> > On 2024-02-23 15:04:56, Segher Boessenkool wrote:
> > > On Fri, Feb 23, 2024 at 11:29:23AM +0530, Kautuk Consul wrote:
> > > > > > difference (e.g. by running the command in a tight loop many times)?
> > > > Running a single loop many times will not expose much because that loop
> > > > (which is NOT within a Forth colon subroutine) will compile only once.
> > > > In my performance benchmarking with tb@ I have put 45 IF-THEN and
> > > > IF2-THEN2 control statements that will each compile once and reveal the
> > > > difference in compilation speeds.
> > > 
> > > All of this is only for things compiled in interpretation mode anyway.
> > > Even how you get the source code in (read it from a slow flash rom in
> > > the best case!) dominates performance.
> > > 
> > > You do not write things in Forth because it is perfect speed.  Write
> > > things directly in machine code if you want that, or in another high-
> > > level language that emphasises optimal execution speed.  The good things
> > > about Forth are rapid prototyping, immediate testing of all code you
> > > write, simple compact code, that kind of goodness.  Ideal for (system)
> > > firmware!
> > > 
> > > 
> > > Segher
> > 
> > Yes, but SLOF will be there on the product we sell to our customers.
> > Considering that there is a noticeable improvement in performance I just
> > thought maybe IBM management would be interested in it.
> 
> On this note, what did you also try to understand the performance
> implications of my patch ? What improvements did you observer on your
> set up?
One strange thing I noticed is that when I copy paste the same IF-THEN
or IF2-THEN2 lines below the ones that I already have in my OF.fs, the
timebase seems to keep reducing for some strange reason. The number of
IF-THEN and IF2-THEN2 statements are the exact same.

