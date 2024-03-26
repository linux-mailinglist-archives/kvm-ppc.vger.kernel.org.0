Return-Path: <kvm-ppc+bounces-75-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB76688C703
	for <lists+kvm-ppc@lfdr.de>; Tue, 26 Mar 2024 16:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D198320750
	for <lists+kvm-ppc@lfdr.de>; Tue, 26 Mar 2024 15:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D9013C83C;
	Tue, 26 Mar 2024 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WJK8s6EK"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2841713AD03
	for <kvm-ppc@vger.kernel.org>; Tue, 26 Mar 2024 15:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711467058; cv=none; b=sKh5ljIadK7NJNA6YTbKKCTvQka9tv+i9J9RGhRjdjyMki5iWdblsZjFuyGMxBN/ATLpOdC3mo1JruinJoLJQZSMlkyzLfwg6Bzg5LWdTfpiY42+khbRjdilqfSc8ELqWn3BlDFj+yW9gqWfyY8Eo7erC3iWA2E0KErHtjkvcKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711467058; c=relaxed/simple;
	bh=oXuySRBq5Mh0GQ4qRzMUV1sx85GxlOmm116DL1hhwkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c01Exa2i3gQr/nEyJ9I8FDSf5PRX0pplKZMZq7wvSJKYoGy3uyGTaulf0dRgimR8DdARVd4yIwYYEaRWGVv+yZ7FaJBoeC/phRAgcQUQWzQEFXD4u2Ax6XdbovDISRoabpRGvLtHBy/ZfmMMNvoP47mnzC+y7z+1fvPkLkhD8vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WJK8s6EK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QErFMP029827;
	Tue, 26 Mar 2024 15:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=9EfqnzDaKlnZT1cRlwsR7PwHxk4rCTkMc2TcjKqevN8=;
 b=WJK8s6EK833FvTcjCYudl3hW8HXImtvZ2rGrc/NiyjXDRA7UPNs9EDZj1OyRrbjAiAxO
 nz+QXxn40eKVn2DBJrGaX6tHqQtGssHBr6qrhIHSgPCjYeAxE41hl8ZghdsuoBTvEf0i
 0kTmSQLb+aiCpXZiy6nfbWBhTwQtCA6V0ywltzPteM0LoiBAR5J6dh1bTkBMZm0SfAnk
 QWPxpZv8snxOpp3k105v7DZFw9qdOEPNiuHZNZJW97b7kopYDkgmVsN6xO/D/26cWqbS
 keutAUis3ifkSR1VZkvqcPLUE5dW8RuB018TrfVm75aBw6LO26+PEBphd0odkyGRXlQ1 rw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x40gkg37q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 15:30:48 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42QFUlgE024177;
	Tue, 26 Mar 2024 15:30:47 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x40gkg37m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 15:30:47 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42QFKtbQ013370;
	Tue, 26 Mar 2024 15:30:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x29t0gr4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 15:30:46 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42QFUg5j28508750
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 15:30:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B94820063;
	Tue, 26 Mar 2024 15:30:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1519E2004B;
	Tue, 26 Mar 2024 15:30:40 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.179.10.13])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 26 Mar 2024 15:30:39 +0000 (GMT)
Date: Tue, 26 Mar 2024 21:00:36 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Kautuk Consul <kconsul@linux.ibm.com>, aik@ozlabs.ru,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v2] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <ZgLqHLIGoVJHphAc@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240318103003.484602-1-kconsul@linux.vnet.ibm.com>
 <116481b9-7268-4a62-a3ac-576ffb538e1d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <116481b9-7268-4a62-a3ac-576ffb538e1d@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tm2rNGPf0MmUxvZdALA76uGWkMlORaRO
X-Proofpoint-ORIG-GUID: H6GXPjRC1pCj2Dmn_A9aH_kT9STU2jIS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 malwarescore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260108

Hi,

On 2024-03-26 15:45:46, Thomas Huth wrote:
> On 18/03/2024 11.30, Kautuk Consul wrote:
> > While testing with a qcow2 with a DOS boot partition it was found that
> > when we set the logical_block_size in the guest XML to >512 then the
> > boot would fail
> ...
> > diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> > index 661c6b0..2630701 100644
> > --- a/slof/fs/packages/disk-label.fs
> > +++ b/slof/fs/packages/disk-label.fs
> > @@ -132,11 +132,16 @@ CONSTANT /gpt-part-entry
> >      debug-disk-label? IF dup ." actual=" .d cr THEN
> >   ;
> > -\ read sector to array "block"
> > -: read-sector ( sector-number -- )
> > +\ read sector to array "block" and return actual bytes read
> > +: read-sector-ret ( sector-number -- actual-bytes )
> >      \ block-size is 0x200 on disks, 0x800 on cdrom drives
> >      block-size * 0 seek drop      \ seek to sector
> > -   block block-size read drop    \ read sector
> > +   block block-size read    \ read sector
> > +;
> > +
> > +\ read sector to array "block"
> > +: read-sector ( sector-number -- )
> > +   read-sector-ret drop
> >   ;
> >   : (.part-entry) ( part-entry )
> > @@ -204,7 +209,8 @@ CONSTANT /gpt-part-entry
> >            part-entry>sector-offset l@-le    ( current sector )
> >            dup to part-start to lpart-start  ( current )
> 
> I just noticed that according to the stack comment above, there is a
> "current" item on the stack...
> 
> >            BEGIN
> > -            part-start read-sector          \ read EBR
> > +            part-start read-sector-ret          \ read EBR
> > +            block-size < IF UNLOOP 0 EXIT THEN
> 
> ... which doesn't get dropped here before the EXIT ? Is the stack still
> right after this function exited early?

Thanks for catching this. I didn't notice this as I sent this v2 in a
hurry.

> 
> >               1 partition>start-sector IF
> >                  \ ." Logical Partition found at " part-start .d cr
> >                  1+
> > @@ -279,6 +285,7 @@ CONSTANT /gpt-part-entry
> >      THEN
> >      count-dos-logical-partitions TO dos-logical-partitions
> > +   dos-logical-partitions 0= IF false EXIT THEN
> >      debug-disk-label? IF
> >         ." Found " dos-logical-partitions .d ." logical partitions" cr
> > @@ -352,6 +359,7 @@ CONSTANT /gpt-part-entry
> >      no-mbr? IF drop FALSE EXIT THEN  \ read MBR and check for DOS disk-label magic
> >      count-dos-logical-partitions TO dos-logical-partitions
> > +   dos-logical-partitions 0= IF 0 EXIT THEN
> 
> Similar question here, what about the "addr" stack item? Shouldn't it be
> dropped first?
Yes. Will take a look at this too. Thanks!
I will make these both changes and test them out before sending out a
v3.

> 
>  Thomas
> 
> 
> PS: I'm still having trouble receiving your mail, I just discovered v2 on
> patchwork and downloaded it from there...
Okay I will check everything from my side to see if everything is in
order.
> 

