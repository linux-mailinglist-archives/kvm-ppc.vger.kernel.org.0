Return-Path: <kvm-ppc+bounces-119-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0278CBD5C
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 May 2024 10:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C0E71F2112E
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 May 2024 08:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63E67F486;
	Wed, 22 May 2024 08:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hFXsKDcB"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA946522
	for <kvm-ppc@vger.kernel.org>; Wed, 22 May 2024 08:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716368164; cv=none; b=NfGGBvqgBvogz+MfmZ615gnQHhIK3sSzSdJlUwSO890DbsN3T6SGX7hqscwyeF3SP37KCZYNk84D+ZChHLFt56k+gOkRTeuKq5inkMMaFsK4S0escQN3bpRofqie7tqsaKduycW8rv7V5tsPJcuRIRjLSIHd2+S4bLWKfFTowOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716368164; c=relaxed/simple;
	bh=pt+mmPquODLzdTlh2LE6DZsmVUIS49rR6CrLVZNmwmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbgiZxg6bMiijXE2AVL8PVCsogSVwE56WzzGsFkzaB6YA8a34A005VB0h00udql15IEoE33GuWuHPvT36TBmXGsObwlsGpFB0cq2ZnOiI62FkXcdAtEtK7mUmFmGQarfDY4KfoRWeLIn65Fr8tFlddSlzKS2d2r5QXyXqsYhkpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hFXsKDcB; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44M8qCfU021887;
	Wed, 22 May 2024 08:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=dTVZq6l12+VMSLjds9rivqtiE2IBYav55M5N4Rjdlik=;
 b=hFXsKDcBa9rJ6CdVRUwGtdbADgcJl7h3rYFh8OPci7s9LCD/7juIzY8MsUzqOiqySm4c
 g8NIBJjrFL3FNZ3oikYFjc73fsIuDvEu4mXUiFjuqLXl5AJDYWfTNoXQvuyL1yKmu/67
 lWl7EgQyUTKraQnVvFqdqhPIhZsT5ngfwZ4vruHMJRLKUg0/5YfrcdefqKt1zo3awz6q
 k0EjFBkBq9tieDVU8hoQugChoR9tFrbphjSePgGjXkV75eDuhsu1+O2vZ98v0zS0C2S0
 1PWjUYEd3eh+9U6afSh94H3e9lta/KLIZXK4iBuPuFBbOnFi81x8LA5fzYf0i52tU3A1 Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9djsr0g4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 08:55:57 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44M8tune027870;
	Wed, 22 May 2024 08:55:56 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y9djsr0fx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 08:55:56 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44M6BuOu022240;
	Wed, 22 May 2024 08:55:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y76ntu9d4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 May 2024 08:55:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44M8tqF252560192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 08:55:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB8F920040;
	Wed, 22 May 2024 08:55:51 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F8AF20043;
	Wed, 22 May 2024 08:55:50 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.171.70.34])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 22 May 2024 08:55:50 +0000 (GMT)
Date: Wed, 22 May 2024 14:25:47 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v4] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <Zk2zExcW7u6BJhyT@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
 <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZjS3qfuj+iopSZjR@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZkMqEvgG0HxpdVzs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <34720d52-89ed-43b1-9811-40eb61904b55@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34720d52-89ed-43b1-9811-40eb61904b55@app.fastmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RSclTJjbQ5bDQF14qqZEqNmPwRLx8Oz5
X-Proofpoint-GUID: daWhEVRpPBjAi2bwUM5HCHVTbZcvujrO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_03,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405220063

Hi,

On 2024-05-20 19:03:25, Alexey Kardashevskiy wrote:
> 
> 
> On Tue, 14 May 2024, at 19:08, Kautuk Consul wrote:
> > Hi Alexey/Segher,
> > > > :-). But this is the only other path that doesn't have a CATCH
> > > > like the do-load subroutine in slof/fs/boot.fs. According to Segher
> > > > there shouldn't ever be a problem with throw because if nothing else the
> > > > outer-most interpreter loop's CATCH will catch the exception. But I
> > > > thought to cover this throw in read-sector more locally in places near
> > > > to this functionality. Because the outermost FORTH SLOF interpreter loop is not
> > > > really so related to reading a sector in disk-label.fs.
> > > > 
> > > Alexey/Segher, so what should be the next steps ?
> > > Do you find my explanation above okay or should I simply remove these
> > > CATCH blocks ? Putting a CATCH block in count-dos-logical-partitions is
> > > out of the question as there is already a CATCH in do-load in
> > > slof/fs/boot.fs. This CATCH block in the open subroutine is actually to
> > > prevent the exception to be caught at some non-local place in the code.
> > 
> > Any ideas on how we proceed with this now ?
> 
> 
> Ufff, I dropped the ball again :-/
> 
> Sorry but if read-sector cannot read a sector because of misconfiguration (not because some underlying hardware error) - this tells me that this should be handled when we open the block device which we knows the size of in sectors and if it is not an integer - barf there. Or it is not possible? In general, when you tweak libvirt xml like this - there are plenty of ways to break SLOF, this one is not worth of another exception throwing imho. Thanks,

Sure, no issues. Just thought to send in this patch as we encountered
this problem. Will abandon this email chain now. Thanks again! :-)

