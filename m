Return-Path: <kvm-ppc+bounces-87-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A10898211
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Apr 2024 09:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1E751C21420
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Apr 2024 07:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B330C56471;
	Thu,  4 Apr 2024 07:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SGvQj87x"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FB92574F
	for <kvm-ppc@vger.kernel.org>; Thu,  4 Apr 2024 07:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712215152; cv=none; b=je65TVFcMwmzG4AGgD53GeP3hnXLKjAy9SVdtbk7jXpPB+sKgujPmgY1XlpiUHlbl4IzROPn5IWEb1Ih8Zv+6J+2yTQpdrOg12t2Hg60srNtfoPqJR8uu2G0Mv4/N3OQkE9065ra45DtSzjU6dKKdDAR86OdI0xVUnB5KRnCIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712215152; c=relaxed/simple;
	bh=gM3lDZhLugkwvHqpQj8DRBJ9Durt4I4p1sCN7p5Ny2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qD8EW+1DgRS5NetdZTEgTOMeVakt2KkI0u/digjGUE2m0DVBp+svsMbPxkLcV7XFN4Wh6htK4Se9lDvK/d0/QMxNG3Y74TW/9gQEl4UfYhCWhj724EeHHSwbmvCi23pVxLSQTse5EaEm4bM3t5yzDL/PBnzH8ep9fqm2G9b3DsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SGvQj87x; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4346tev9004898;
	Thu, 4 Apr 2024 07:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=PmZJw9aRJ8fuuI5d9TJfRVaYkdC+rapCo7VyqadTVx4=;
 b=SGvQj87xOVW3YS4Fu8hrLAYvG+lIfteKC62YIAPqZZPcHkjrbEK+34jT8xYQagc41BrC
 4PHrLuplXfRIau+ialEqdA4xqZbmzjhBNUZwgjC2g3vKUIYFRt/8r4ZwqURSl0EsnM2i
 Kmd4ezFN0yXJCiUxdqXLGsYY6xZOcy9pJuygk3wuR17is5U1mFCRXwmixRvfF4q88UtK
 OZU/2VfMvJ8Vzw69nxDlBFGVJJiAQeQ9ld4w86TPVAXm6+2te+HDN+JVqdyXKrtr2x+T
 1i5xLsWBCM7c3rnWUNrcL29m96aaxZxGOjckMnsDg0ihaeLdy2CZpjjlHrJBbRZdXALB uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x9q8g0254-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Apr 2024 07:19:00 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4347Hcqd007232;
	Thu, 4 Apr 2024 07:18:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x9q8g0252-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Apr 2024 07:18:59 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43476416009114;
	Thu, 4 Apr 2024 07:18:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x9epxtpgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Apr 2024 07:18:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4347IssC45941170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Apr 2024 07:18:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 388DB20043;
	Thu,  4 Apr 2024 07:18:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1025820040;
	Thu,  4 Apr 2024 07:18:53 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  4 Apr 2024 07:18:52 +0000 (GMT)
Date: Thu, 4 Apr 2024 12:48:47 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
        Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v4] slof/fs/packages/disk-label.fs: improve checking for
 DOS boot partitions
Message-ID: <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YLKon1tS7bLckZdMeVrQKzQ-osR6dkC2
X-Proofpoint-ORIG-GUID: xdMy-lc3aQllo0eCXMt5viF0hLgArtsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-04_02,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 phishscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404040047

On 2024-04-04 11:35:43, Alexey Kardashevskiy wrote:
> First, sorry I am late into the discussion. Comments below.
> 
> 
> On Thu, 28 Mar 2024, at 17:00, Kautuk Consul wrote:
> > While testing with a qcow2 with a DOS boot partition it was found that
> > when we set the logical_block_size in the guest XML to >512 then the
> > boot would fail in the following interminable loop:
> 
> Why would anyone tweak this? And when you do, what happens inside the SLOF, does it keep using 512?
Well, we had an image with DOS boot partition and we tested it with
logical_block_size = 1024 and got this infinite loop.
In SLOF the block-size becomes what we configure in the
logical_block_size parameter. This same issue doesn't arise with GPT.
> 
> > <SNIP>
> > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > </SNIP>
> > 
> > Change the "read-sector" Forth subroutine to throw an exception whenever
> > it fails to read a full block-size length of sector from the disk.
> 
> Why not throwing an exception from the "beyond end" message point?
> Or fail to open a device if SLOF does not like the block size? I forgot the internals :(
This loop is interminable and this "Access beyond end of device!"
message continues forever.
SLOF doesn't have any option other than to use the block-size that was
set in the logical_block_size parameter. It doesn't have any preference
as the code is very generic for both DOS as well as GPT.
> 
> > Also change the "open" method to initiate CATCH exception handling for the calls to
> > try-partitions/try-files which will also call read-sector which could potentially
> > now throw this new exception.
> > 
> > After making the above changes, it fails properly with the correct error
> > message as follows:
> > <SNIP>
> > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > 
> > E3404: Not a bootable device!
> > 
> > E3407: Load failed
> > 
> >   Type 'boot' and press return to continue booting the system.
> >   Type 'reset-all' and press return to reboot the system.
> > 
> > Ready!
> > 0 >
> > </SNIP>
> > 
> > Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
> > ---
> > slof/fs/packages/disk-label.fs | 12 +++++++++---
> > 1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> > index 661c6b0..a6fb231 100644
> > --- a/slof/fs/packages/disk-label.fs
> > +++ b/slof/fs/packages/disk-label.fs
> > @@ -136,7 +136,8 @@ CONSTANT /gpt-part-entry
> > : read-sector ( sector-number -- )
> >     \ block-size is 0x200 on disks, 0x800 on cdrom drives
> >     block-size * 0 seek drop      \ seek to sector
> > -   block block-size read drop    \ read sector
> > +   block block-size read         \ read sector
> > +   block-size < IF throw THEN    \ if we read less than the block-size then throw an exception
> 
> When it fails, is the number of bytes ever non zero? Thanks,
No, it doesn't reach 0. It is lesser than the block-size. For example if
we set the logcial_block_size to 1024, the block-size is that much. if
we are reading the last sector which is physically only 512 bytes long
then we read that 512 bytes which is lesser than 1024, which should be
regarded as an error.
> 
> > ;
> >  
> > : (.part-entry) ( part-entry )
> > @@ -723,10 +724,15 @@ CREATE GPT-LINUX-PARTITION 10 allot
> >     THEN
> >  
> >     partition IF
> > -       try-partitions
> > +       ['] try-partitions
> >     ELSE
> > -       try-files
> > +       ['] try-files
> >     THEN
> > +
> > +   \ Catch any exception that might happen due to read-sector failing to read
> > +   \ block-size number of bytes from any sector of the disk.
> > +   CATCH IF false THEN
Segher/Alexey, can we keep this CATCH block or should I remove it ?
> > +
> >     dup 0= IF debug-disk-label? IF ." not found." cr THEN close THEN \ free memory again
> > ;
> >  
> > -- 
> > 2.31.1
> > 
> > 

