Return-Path: <kvm-ppc+bounces-123-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED388D1328
	for <lists+kvm-ppc@lfdr.de>; Tue, 28 May 2024 06:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E335E1F225AA
	for <lists+kvm-ppc@lfdr.de>; Tue, 28 May 2024 04:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27DE811CB8;
	Tue, 28 May 2024 04:02:36 +0000 (UTC)
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFC43AC36
	for <kvm-ppc@vger.kernel.org>; Tue, 28 May 2024 04:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716868956; cv=none; b=c0Fs8cDITOiB1xGH/UlPeLOtHprn96SeWLJDFFZQyhxHRaNRNQdlqLZF1cDBcfW5UMT+syX0V7zKdSm99RPMxXme4n2Y7v5+DvAD4c0Smwq5vNhVxwvJhEyUPRQBoNusGr67kIHjyjKQJVFQ2zQw1a9nc3DgrTrNMy17KP7t038=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716868956; c=relaxed/simple;
	bh=ixl+67H8gb+2Bb3ZFQfHfINSXELW0kDvtWOW6Jb73Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAjaXOJ0Ae111Yw3frS99xxSRg7+r9JYvBXU47oSqHpDB5oMJNcpSXZggDrwDYSVDDscewp59PGFp9BK5H9rlxY7HtfmSVjn4jBGVgPcxe7BzQOSFhDQtyuzgT1yn0AvLQrz9UKdlHhcLVWNE/9JIexKriZ9Iw4LIe+QFL71wxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44S3hEA1000881;
	Tue, 28 May 2024 04:02:16 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Dibm.com;_h=3Dcc?=
 =?UTF-8?Q?:content-type:date:from:in-reply-to:message-id:mime-version:ref?=
 =?UTF-8?Q?erences:subject:to;_s=3Dpp1;_bh=3DTRqHFZzSLBhwfxXDL6VSIcLzXZg99?=
 =?UTF-8?Q?E8KPW1Zi7up4TU=3D;_b=3DENdrMsNpo1hmrX3k0W9/DBoeRtYjGypUzq2xXHeT?=
 =?UTF-8?Q?TZgnznoFp3gPQ7PE+9TbwXAl1FPw_foCLy+U3Xq0cgcpB7oQuK7tHTy2v6H5WaO?=
 =?UTF-8?Q?JZ++tLYHCLWYLkjf2PY7lgrJPUPoI1jsYw_TdB/blv/yPmHoIvLGYBp8yCVJhSd?=
 =?UTF-8?Q?CuSsHy1LaCxZh/ObAJm0RkSRfG4c6TSZ5BpLtMwl_6zLzMH9Q46OvAgS0Ja4S34?=
 =?UTF-8?Q?1T5tbtkwlOqg/FU6G1E/x/BcGSg9FXftaO515nppnSkHbr_AVkCAagcijSQZwqx?=
 =?UTF-8?Q?ZZ4Qn0Zz2clhQqWCQtAU0AA93Sq6Mq5SFNtzUHvghFSJeV/nvDN0_Tg=3D=3D_?=
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yd7kc817n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 04:02:16 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44S42FR1026601;
	Tue, 28 May 2024 04:02:16 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yd7kc817j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 04:02:15 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44S3Z9HX027089;
	Tue, 28 May 2024 04:02:15 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ybvhkmc52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 04:02:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44S42BtO33948230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 04:02:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B70A20043;
	Tue, 28 May 2024 04:02:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 051ED2004E;
	Tue, 28 May 2024 04:02:10 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 28 May 2024 04:02:09 +0000 (GMT)
Date: Tue, 28 May 2024 09:32:07 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Kautuk Consul <kconsul@linux.vnet.ibm.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Thomas Huth <thuth@redhat.com>, Greg Kurz <groug@kaod.org>,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <ZlVXP4XtlPmxTHLs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223205723.GO19790@gate.crashing.org>
 <ZdwV/1bmGSGi8MnZ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZelfudAMYcXGCgBN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZffNVdhtAzY32Jsx@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zk21NmxuSUlWVhgs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <4fb7cb21-d8ea-4823-917b-7ce3f7349160@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fb7cb21-d8ea-4823-917b-7ce3f7349160@app.fastmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iBaNdTD5fYMmQG7yDayKicW1bOLIO7bL
X-Proofpoint-ORIG-GUID: zvKi1n61uqPbrHJ2KCpTh0et1Or-81bB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-27_06,2024-05-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 phishscore=0 mlxlogscore=793 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280029

Hi,

> 
> Is this optimization even measurable? :)
> 
> There is one thing which SLOF could do much faster (seconds or tens of seconds) - it is PCI scan where SLOF walks through all busses and slots even though it is all in the device tree already. But this "dotick" business does not scream for optimization imho. Thanks,

Yeah. In nanoseconds per control statement pair as per the benchmarking
in the emails before. For 45 IF-THEN and IF2-THEN2 statements I achieved
an improvement of around 35 microseconds on an average.
Nothing much but I just thought it is an interesting change considering
most of the Forth compiler is fine. I was just reading through the
Forth compiler in slof/engine.in and saw this and decided to post it out
of interest.

But I will abandon this patch now as you feel that this is not enough to
warrant any change in slof/engine.in. Thanks anyway!

