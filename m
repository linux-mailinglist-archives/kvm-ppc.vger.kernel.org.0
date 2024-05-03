Return-Path: <kvm-ppc+bounces-99-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C905B8BAA80
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 May 2024 12:09:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05B101C20F34
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 May 2024 10:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CF614A0B1;
	Fri,  3 May 2024 10:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fyv3deYR"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602FD14EC6A
	for <kvm-ppc@vger.kernel.org>; Fri,  3 May 2024 10:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714730942; cv=none; b=oLz7f8fOoI8BFnXIFJsbY4oIBdp/fsxE6AQ1IreXVMnS1DlvZb6sawce2I8HEMmr7/4Q2LPfuZWwSnqZIZASOIqXOg27KgtrdrjK28oOx8OORot1Za7oKTr3iMiAa0IKEbawuccm1G0odPYY+QNoP32+Wv8873w3mxLcSBrzvf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714730942; c=relaxed/simple;
	bh=0SC2mzZHs3v1a70GHkmaL8C8tj0BAbqa9i1HevZVnDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZjcI06SifaIbo8/vQINUfc7m5nBb/sOztX/jqo9Lz/8lrcnqO+8J6c/JUGnmejbQbQbVz1I/nAwRmjM72MrksIYTn1wdfcZt3LvPd5OI2UU30SjbpZgB18p6WKe6IZNyH3zNRxZWH1hVKGTwGSzM8bzKeFwjC9EcF9d0jAC9ts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fyv3deYR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 443A7DCS014350;
	Fri, 3 May 2024 10:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=OL0Oket23IoaXtlQgiVg27Zk79f4t7WWDcBXHPxBtR8=;
 b=fyv3deYR/LCcReZ7j38I+lFnWf3UnAP1WgxM8lN2e1OKrMZO2YRfbXPMewG3YGydn7x8
 ixNL4Ec/br1A40ovKCohT4baq28B9K7PENK+EjdfVamVKHWhpixY/kNFJbXrKVs5zQ1q
 SH1NCjDE86QLynlJNhN/d0Y8tAUbAIjLeFFbRgJ0daX88Cj+5fXrirq6JzaB25qkTqQZ
 NPDRV+BemYb6HUJ8pUs+w68gkIqb1ngbApDwFuYQ1cwmuP9FYpbOH8R1w/WuuHBdDyvo
 /XVoi+iBhFhrQZu5GZxwEzuYSw++C2Y0lSLZW8ep08cjbIOOgG1jMk88SI7erdjBuo4i qg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xvww0g068-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 May 2024 10:08:53 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 443A8rln018861;
	Fri, 3 May 2024 10:08:53 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xvww0g063-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 May 2024 10:08:53 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4436l4VJ022190;
	Fri, 3 May 2024 10:08:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xsd6n4y7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 May 2024 10:08:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 443A8lYF46334438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 May 2024 10:08:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFC7E20078;
	Fri,  3 May 2024 10:08:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 74EF62007A;
	Fri,  3 May 2024 10:08:45 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.179.18.122])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  3 May 2024 10:08:45 +0000 (GMT)
Date: Fri, 3 May 2024 15:38:41 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v4] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <ZjS3qfuj+iopSZjR@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
 <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PkMuBGcNEicK82FGQqp4Pxqgu45jU0hA
X-Proofpoint-ORIG-GUID: UJ5NV9plEN_y2IYAmvonSAzGd_ALnm4k
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-03_06,2024-05-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405030073

Hi Alexey/Segher,

> > :-). But this is the only other path that doesn't have a CATCH
> > like the do-load subroutine in slof/fs/boot.fs. According to Segher
> > there shouldn't ever be a problem with throw because if nothing else the
> > outer-most interpreter loop's CATCH will catch the exception. But I
> > thought to cover this throw in read-sector more locally in places near
> > to this functionality. Because the outermost FORTH SLOF interpreter loop is not
> > really so related to reading a sector in disk-label.fs.
> > 
> Alexey/Segher, so what should be the next steps ?
> Do you find my explanation above okay or should I simply remove these
> CATCH blocks ? Putting a CATCH block in count-dos-logical-partitions is
> out of the question as there is already a CATCH in do-load in
> slof/fs/boot.fs. This CATCH block in the open subroutine is actually to
> prevent the exception to be caught at some non-local place in the code.

Any ideas on how we proceed with this now ?

> _______________________________________________
> SLOF mailing list
> SLOF@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/slof

