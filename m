Return-Path: <kvm-ppc+bounces-70-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A199287E2E9
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 06:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F2F5AB20D6D
	for <lists+kvm-ppc@lfdr.de>; Mon, 18 Mar 2024 05:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C91208BB;
	Mon, 18 Mar 2024 05:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RcS85Lv0"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACEB208B6
	for <kvm-ppc@vger.kernel.org>; Mon, 18 Mar 2024 05:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710738871; cv=none; b=SHM86qK22HG5wcfwdC6ROcRiHvKFA4sxAmWoG8mcRFDjdhb1SXnqI1BLQe2v17CFNuHCBoMu4XaguflSI2fpvqKRcGipx5vaL0AUSyYYtSW2tD8gh+IELo54Cf25andYg5EFRl2nt+gAw1ENUeQse23D38CnMNTw19+fxxXLYe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710738871; c=relaxed/simple;
	bh=UPAhuaRJLz8zZ1v12sR30qXvnZCGvJDNfY9M64KsiQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A3aZanBox46NYeyGEKuNK2tjByJhA2l6FQqvmqPuGb6wXlOuCq1tBQPw7FYKaJXpKtjccQ9uPKNjEYvp1Aq2hRSgXlSi7SOXxzjQ4F04BmiDSI3Swi0gBF3nDji3FLuEIOdFpaRTrNgzNKVEBYX7qrBkDDsjUjiLuEK/2S8IyRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RcS85Lv0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42I25fYZ025446;
	Mon, 18 Mar 2024 05:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=xwkis0vLXtrsYmoeTGmjv0ANasxuIO/VTK3mzsxgX+4=;
 b=RcS85Lv08vLTh74mC0NRTYVYgeMfhbejmhZMwoW8TbNmyTF9S07wMiGLG8UcsAehdUdb
 8tzjD78lm1b7rmFHdo/CwgBCaYKBUV+TtE1ZMXwdS0qhqCVqbhI4V7hUgvk5Hjtr5Em+
 tAa776EDPpb47Jp2p9qzrMSixja+10/hswIrT5tI3GbRwnjmf+rjay8N48SDJQcUu60D
 jAlU+u9NMJhmL3SCeIAKEZkSBP9z0LjhdHWMMJzJaRkm8wy4RRPGIbY+jMQyXCz7a3Ez
 eQfvLKhQ8dMHiSJnqqfeUH/MqqArEgL/LkS/xOpNwSBg5hRnAX4/ef+pzrzV5s8vklau FA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wx1d2myj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 05:14:22 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42I59mvo004392;
	Mon, 18 Mar 2024 05:14:22 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wx1d2myj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 05:14:22 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42I4SYU8002778;
	Mon, 18 Mar 2024 05:14:21 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wwrf268th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 05:14:21 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42I5EHLe46661952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Mar 2024 05:14:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A1F820043;
	Mon, 18 Mar 2024 05:14:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C1662004B;
	Mon, 18 Mar 2024 05:14:16 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 18 Mar 2024 05:14:16 +0000 (GMT)
Date: Mon, 18 Mar 2024 10:44:11 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] slof/fs/packages/disk-label.fs: improve checking for DOS
 boot partitions
Message-ID: <ZffNo8fEywkKHQPA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240222061046.42572-1-kconsul@linux.vnet.ibm.com>
 <ZelgMYUM0CzMVjbE@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZelgMYUM0CzMVjbE@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TuMqqEwyfXFlaVqQL4pPdjYUSjD0sr0d
X-Proofpoint-GUID: TI_GrYOSG33VqOjLTrAyQZOCI5lGHEKO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-17_12,2024-03-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403180037

Hi,
> 
> On 2024-02-22 01:10:46, Kautuk Consul wrote:
> > While testing with a qcow2 with a DOS boot partition it was found that
> > when we set the logical_block_size in the guest XML to >512 then the
> > boot would fail in the following interminable loop:
> > <SNIP>
> > Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
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
> > Change the count-dos-logical-partitions Forth subroutine and the Forth
> > subroutines calling count-dos-logical-partitions to check for this access
> > beyond end of device error.
> > 
> > After making the above changes, it fails properly with the correct error
> > message as follows:
> > <SNIP>
> > Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
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
> > Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
> > ---
> >  slof/fs/packages/disk-label.fs | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> > index 661c6b0..e680847 100644
> > --- a/slof/fs/packages/disk-label.fs
> > +++ b/slof/fs/packages/disk-label.fs
> > @@ -139,6 +139,13 @@ CONSTANT /gpt-part-entry
> >     block block-size read drop    \ read sector
> >  ;
> > 
> > +\ read sector to array "block" and return actual bytes read
> > +: read-sector-ret ( sector-number -- actual)
> > +   \ block-size is 0x200 on disks, 0x800 on cdrom drives
> > +   block-size * 0 seek drop      \ seek to sector
> > +   block block-size read    \ read sector
> > +;
> > +
> >  : (.part-entry) ( part-entry )
> >     cr ." part-entry>active:        " dup part-entry>active c@ .d
> >     cr ." part-entry>start-head:    " dup part-entry>start-head c@ .d
> > @@ -204,7 +211,8 @@ CONSTANT /gpt-part-entry
> >           part-entry>sector-offset l@-le    ( current sector )
> >           dup to part-start to lpart-start  ( current )
> >           BEGIN
> > -            part-start read-sector          \ read EBR
> > +            part-start read-sector-ret          \ read EBR
> > +            block-size < IF UNLOOP 0 EXIT THEN
> >              1 partition>start-sector IF
> >                 \ ." Logical Partition found at " part-start .d cr
> >                 1+
> > @@ -279,6 +287,7 @@ CONSTANT /gpt-part-entry
> >     THEN
> > 
> >     count-dos-logical-partitions TO dos-logical-partitions
> > +   dos-logical-partitions 0= IF false EXIT THEN
> > 
> >     debug-disk-label? IF
> >        ." Found " dos-logical-partitions .d ." logical partitions" cr
> > @@ -352,6 +361,7 @@ CONSTANT /gpt-part-entry
> >     no-mbr? IF drop FALSE EXIT THEN  \ read MBR and check for DOS disk-label magic
> > 
> >     count-dos-logical-partitions TO dos-logical-partitions
> > +   dos-logical-partitions 0= IF 0 EXIT THEN
> > 
> >     debug-disk-label? IF
> >        ." Found " dos-logical-partitions .d ." logical partitions" cr
> > -- 
> > 2.31.1
> > 

So how does the patch look ? Any comments from anyone ?

